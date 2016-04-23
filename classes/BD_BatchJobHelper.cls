/**
 * @author John Ives
 * @date 4/22/16
 * @description Helper class to interact with Batch Job objects.
 */

public with sharing class BD_BatchJobHelper {


    public void beforeInsert(List<Batch_Job__c> jobs) {
        
        for( Batch_Job__c job : jobs ) {
            // Just schedule job if state is Ready
            if( job.State__c == 'Ready' ) {
                // Schedule the job
                scheduleJob( job );

            } else {
                // Not in the expected State
                String msg = 'New record inserts should always have a State of "Ready", this one was "'
                        + job.State__c + '", so did not schedule a job.';
                setErrorState( job, msg );
                job.addError( msg );
            }
        }
    }


    public void beforeUpdate(List<Batch_Job__c> newJobs, Map<Id, Batch_Job__c> oldMap) {


    }


    public void beforeDelete(List<Batch_Job__c> jobs) {


    }


    private Schedulable getObject( String name ) {
        Type t = Type.forName( name );
        return (Schedulable) t.newInstance();
    }


    private void setErrorState( Batch_Job__c job, String msg ) {
        job.Error_Message__c = msg;
        job.State__c = 'Error';
        System.debug( 'Changed Batch Job state to Error :: ' + msg );
    }


    private void scheduleJob( Batch_Job__c job ) {

        // Only create job if record is active
        if( job.Active__c ) {

            try {
                // Schedule the job
                Id jobId = System.schedule( job.Name, job.Cron_Expression__c, getObject( job.Apex_Class__c ) );

                // Updated fields for succesful scheduling
                job.Scheduled_Job_Id__c = jobId;
                job.State__c = 'Scheduled';

                // Clear any previous error messages
                job.Error_Message__c = '';

            } catch( Exception e ) {
                System.debug( 'Exception caught when creating a scheduled job for args ("'
                        + job.Name + '", "' + job.Cron_Expression__c + '", "' + job.Apex_Class__c + '") :: ' + e );
                throw e;
            }
        }
    }


    private void abortJob( Batch_Job__c job ) {
        // TODO make it so
    }

}