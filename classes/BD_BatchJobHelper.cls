/**
 * @author John Ives
 * @date 4/22/16
 * @description Helper class to interact with Batch Job objects.
 */

public with sharing class BD_BatchJobHelper {


    public void beforeInsert(List<Batch_Job__c> jobs) {
        for( Batch_Job__c job : jobs ) {
            // Only schedule job if state is Ready
            if( job.State__c == 'Ready' ) {
                // Schedule the job
                scheduleJob( job );

            } else if( job.State__c != 'Off' ) {
                // Not in the expected State
                String msg = 'New record inserts should always have a State of "Ready" or "Off", this one was "'
                        + job.State__c + '", so did not insert.';
                setErrorState( job, null, msg );
            }
        }
    }


    public void beforeUpdate(List<Batch_Job__c> newJobs, Map<Id, Batch_Job__c> oldMap) {
        for( Batch_Job__c job : newJobs ) {
            // Get coresponding old job
            Batch_Job__c oldJob = oldMap.get( job.Id );

            // Abort scheduled job if record deactivated
            if( !job.Active__c ) abortJob( job, false );

            // Abort/reschedule job if state set to Ready or if name, cron expression, or class changed
            if( job.Active__c &&
                    ( job.State__c == 'Ready' ||
                            ( job.State__c != 'Off' &&
                                    ( job.Name != oldJob.Name ||
                                      job.Cron_Expression__c != oldJob.Cron_Expression__c ||
                                      job.Apex_Class__c != oldJob.Apex_Class__c
                                    )
                            )
                    )
            ) {

                if( abortJob(job, false) ) scheduleJob( job );

            } else if( job.State__c == 'Off' && (job.State__c != oldJob.State__c) ) {
                // Job was set to Off, so abort old scheduled job
                abortJob( job, false );
                
            }
        }
    }


    public void beforeDelete(List<Batch_Job__c> jobs) {
        for( Batch_Job__c job : jobs ) {
            abortJob( job, true );
        }
    }


    private Schedulable getObject( String name ) {
        Type t = Type.forName( name );
        return (Schedulable) t.newInstance();
    }


    private void setErrorState( Batch_Job__c job, Exception e, String msg ) {
        String fullMsg =  msg + ( e != null ? (' :: ' + e) : '' );
        System.debug( 'Batch Job Error: ' + fullMsg );
        job.Error_Message__c = fullMsg;
        job.State__c = 'Error';
        job.addError( fullMsg );
    }


    private void scheduleJob( Batch_Job__c job ) {
        // Only create job if record is active
        if( job.Active__c ) {
            // Clear any previous error messages
            job.Error_Message__c = '';

            try {
                // Schedule the job
                Id jobId = System.schedule( job.Name, job.Cron_Expression__c, getObject( job.Apex_Class__c ) );

                // Updated fields for succesful scheduling
                job.Scheduled_Job_Id__c = jobId;
                job.State__c = 'Scheduled';

            } catch( Exception e ) {
                setErrorState( job, e, 'Exception caught when creating a scheduled job for args ("'
                        + job.Name + '", "' + job.Cron_Expression__c + '", "' + job.Apex_Class__c + '")' );
            }
        }
    }


    private boolean abortJob( Batch_Job__c job, boolean force ) {
        boolean success = true;

        if( String.isNotBlank( job.Scheduled_Job_Id__c )  ) {
            try {
                // Abort jobs and update fields
                System.abortJob( job.Scheduled_Job_Id__c );

                if( !force ) {
                    job.Scheduled_Job_Id__c = null;
                    job.State__c = 'Off';
                }
            } catch( Exception e ) {
                setErrorState( job, e, 'Exception caught when aborting job "' + job.Scheduled_Job_Id__c + '"' );
                success = false;
            }
        }

        return success;
    }

}