/**
 * @author John Ives
 * @date 4/25/16
 * @description Test class for BD_BatchJobHelper and BD_BatchJobTrigger
 */

@IsTest
private class BD_BatchJobHelperTest {
    static testMethod void testInsertReady() {
        System.debug('\n\n\n<<<<<<<<<<STARTING testInsertReady>>>>>>>>>>\n\n');

        Integer beforeCount =  Database.countQuery( 'SELECT count() FROM Batch_Job__c' );
        Batch_Job__c job = null;

        try {
            job = new Batch_Job__c();
            job.Name = 'Test Job 1';
            job.Cron_Expression__c = '0 0 13 * * ?';
            job.Apex_Class__c = 'BD_TestBatch';
            job.Comments__c = 'Sample comment for batch job test.';
            job.State__c = 'Ready';

            Test.startTest();
            insert job;
            Test.stopTest();

        } catch( Exception e ) {
            System.assert( false, 'Excpetion caught during test :: ' + e );
        }


        Batch_Job__c theJob = [SELECT Name, Scheduled_Job_Id__c FROM Batch_Job__c WHERE Id = :job.Id];
        String cronId = theJob.Scheduled_Job_Id__c;

        Integer afterCount =  Database.countQuery( 'SELECT count() FROM Batch_Job__c' );
        System.assert( beforeCount + 1 == afterCount, 'Batch job count should of increased by 1!');
        System.assert( String.isNotEmpty(cronId), 'A Scheduled Job ID should have been mapped' );


        Integer count =  Database.countQuery( 'SELECT count() FROM CronTrigger WHERE Id = :cronId' );
        System.assert( count == 1, 'Expected to find a matching CronTrigger!' );
    }


    static testMethod void testInsertOff() {
        System.debug('\n\n\n<<<<<<<<<<STARTING testInsertOff>>>>>>>>>>\n\n');

        Integer beforeCount =  Database.countQuery( 'SELECT count() FROM Batch_Job__c' );
        Batch_Job__c job = null;

        try {
            job = new Batch_Job__c();
            job.Name = 'Test Job 1';
            job.Cron_Expression__c = '0 0 13 * * ?';
            job.Apex_Class__c = 'BD_TestBatch';
            job.Comments__c = 'Sample comment for batch job test.';
            job.State__c = 'Off';

            Test.startTest();
            insert job;
            Test.stopTest();

        } catch( Exception e ) {
            System.assert( false, 'Excpetion caught during test :: ' + e );
        }

        Integer afterCount =  Database.countQuery( 'SELECT count() FROM Batch_Job__c' );
        System.assert( beforeCount + 1 == afterCount, 'Batch job count should of increased by 1!');
        System.assert( String.isEmpty( job.Scheduled_Job_Id__c ), 'Expected Schedule Job to be blank!' );
    }


    static testMethod void testInsertScheduled() {
        System.debug('\n\n\n<<<<<<<<<<STARTING testInsertScheduled>>>>>>>>>>\n\n');

        Integer beforeCount =  Database.countQuery( 'SELECT count() FROM Batch_Job__c' );
        Batch_Job__c job = null;
        boolean failed = false;

        try {
            job = new Batch_Job__c();
            job.Name = 'Test Job 1';
            job.Cron_Expression__c = '0 0 13 * * ?';
            job.Apex_Class__c = 'BD_TestBatch';
            job.Comments__c = 'Bad state, should error.';
            job.State__c = 'Scheduled';

            Test.startTest();
            insert job;
            Test.stopTest();

        } catch( Exception e ) {
            failed = true;
            Integer afterCount =  Database.countQuery( 'SELECT count() FROM Batch_Job__c' );
            System.assertEquals( beforeCount , afterCount, 'Batch job should have failed to create!');
        }

        System.assert(failed, 'Should have thrown an exception for having bad data.');
    }



    static testMethod void testInsertBadCronExp() {
        System.debug('\n\n\n<<<<<<<<<<STARTING testInsertBadCronExp>>>>>>>>>>\n\n');

        Integer beforeCount =  Database.countQuery( 'SELECT count() FROM Batch_Job__c' );
        boolean failed = false;

        try {
            Batch_Job__c job = new Batch_Job__c();
            job.Name = 'Test Job 1';
            job.Cron_Expression__c = 'XYZ';
            job.Apex_Class__c = 'BD_TestBatch';
            job.Comments__c = 'This batch should Fail.';

            Test.startTest();
            insert job;
            Test.stopTest();

        } catch( Exception e ) {
            failed = true;
            Integer afterCount =  Database.countQuery( 'SELECT count() FROM Batch_Job__c' );
            System.assertEquals( beforeCount , afterCount, 'Batch job should have failed to create!');
        }

        System.assert(failed, 'Should have thrown an exception for having bad data.');
    }


    static testMethod void testInsertDuplicateName() {
        System.debug('\n\n\n<<<<<<<<<<STARTING testInsertDuplicateName>>>>>>>>>>\n\n');

        boolean failed = false;

        try {
            Batch_Job__c job = new Batch_Job__c();
            job.Name = 'Test Job 1';
            job.Cron_Expression__c = '0 0 13 * * ?';
            job.Apex_Class__c = 'BD_TestBatch';
            job.Comments__c = 'Sample comment for batch job test.';
            insert job;

        } catch( Exception e ) {
            System.assert(false, e);
        }

        try {
            Batch_Job__c job = new Batch_Job__c();
            job.Name = 'Test Job 1';
            job.Cron_Expression__c = '0 0 13 * * ?';
            job.Apex_Class__c = 'BD_TestBatch';
            job.Comments__c = 'Duplicate Job Name.';

            Test.startTest();
            insert job;
            Test.stopTest();

        } catch( Exception e ) {
            failed = true;
        }

        System.assert(failed, 'Should have thrown an exception for duplicate name.');
    }


    static testMethod void testUpdateName() {
        System.debug('\n\n\n<<<<<<<<<<STARTING testUpdateName>>>>>>>>>>\n\n');
        Batch_Job__c job = null;

        try {
            job = new Batch_Job__c();
            job.Name = 'Test Job 1';
            job.Cron_Expression__c = '0 0 13 * * ?';
            job.Apex_Class__c = 'BD_TestBatch';
            job.Comments__c = 'Sample comment for batch job test.';
            insert job;

            job.Name = 'Updated Test Job';
            Test.startTest();
            update job;
            Test.stopTest();

        } catch( Exception e ) {
            System.assert( false, 'Excpetion caught during test :: ' + e );
        }

        Batch_Job__c updatedJob = [ SELECT Name, Scheduled_Job_Id__c FROM Batch_Job__c WHERE Id = :job.Id ];
        System.assertEquals( job.Name, updatedJob.Name, 'Name did not update!'  );

        CronTrigger ct = [SELECT CronJobDetail.Name, CronExpression
                FROM CronTrigger WHERE Id = :updatedJob.Scheduled_Job_Id__c];
        System.assertEquals( job.Name, ct.CronJobDetail.Name, 'CronJobDetail Name did not update!'  );
    }


    static testMethod void testUpdateCronExp() {
        System.debug('\n\n\n<<<<<<<<<<STARTING testUpdateCronExp>>>>>>>>>>\n\n');
        Batch_Job__c job = null;
        String newCronExp = '0 0 20 * * ?';

        try {
            job = new Batch_Job__c();
            job.Name = 'Test Job 1';
            job.Cron_Expression__c = '0 0 13 * * ?';
            job.Apex_Class__c = 'BD_TestBatch';
            job.Comments__c = 'Sample comment for batch job test.';
            insert job;

            job.Cron_Expression__c = newCronExp;
            Test.startTest();
            update job;
            Test.stopTest();

        } catch( Exception e ) {
            System.assert( false, 'Excpetion caught during test :: ' + e );
        }


        Batch_Job__c updatedJob = [ SELECT Name, Cron_Expression__c, Scheduled_Job_Id__c
                FROM Batch_Job__c WHERE Id = :job.Id ];
        System.assertEquals( newCronExp, updatedJob.Cron_Expression__c, 'Cron Expression did not update!'  );

        CronTrigger ct = [SELECT CronExpression FROM CronTrigger WHERE Id = :updatedJob.Scheduled_Job_Id__c];
        System.assertEquals( newCronExp, ct.CronExpression, 'CronExpression did not update!'  );
    }


    static testMethod void testStateToOff() {
        System.debug('\n\n\n<<<<<<<<<<STARTING testStateToOff>>>>>>>>>>\n\n');
        Batch_Job__c job = null;
        String jobId = null;

        try {
            job = new Batch_Job__c();
            job.Name = 'Test Job 1';
            job.Cron_Expression__c = '0 0 13 * * ?';
            job.Apex_Class__c = 'BD_TestBatch';
            job.Comments__c = 'Sample comment for batch job test.';
            insert job;

            jobId = job.Id;
            job.State__c = 'Off';
            Test.startTest();
            update job;
            Test.stopTest();

        } catch( Exception e ) {
            System.assert( false, 'Excpetion caught during test :: ' + e );
        }

        Batch_Job__c updatedJob = [ SELECT Name, State__c, Scheduled_Job_Id__c
                FROM Batch_Job__c WHERE Id = :job.Id ];
        System.assertEquals( 'Off', updatedJob.State__c, 'State did not update!'  );
        System.assert( String.isEmpty( updatedJob.Scheduled_Job_Id__c ), 'Expected Schedule Job to be blank!' );

        Integer count =  Database.countQuery( 'SELECT count() FROM CronTrigger WHERE Id = :jobId' );
        System.assert( count == 0, 'The job should have been removed from the system!' );
    }

    static testMethod void testUpdateOffToOn() {
        System.debug('\n\n\n<<<<<<<<<<STARTING testInsert>>>>>>>>>>\n\n');

        Batch_Job__c job = null;

        try {
            job = new Batch_Job__c();
            job.Name = 'Test Job 1';
            job.Cron_Expression__c = '0 0 13 * * ?';
            job.Apex_Class__c = 'BD_TestBatch';
            job.Comments__c = 'Sample comment for batch job test.';
            job.State__c = 'Off';
            insert job;

            Test.startTest();
            job.State__c = 'Ready';
            update job;
            Test.stopTest();

        } catch( Exception e ) {
            System.assert( false, 'Excpetion caught during test :: ' + e );
        }

        Batch_Job__c theJob = [SELECT Name, Scheduled_Job_Id__c FROM Batch_Job__c WHERE Id = :job.Id];
        String cronId = theJob.Scheduled_Job_Id__c;
        System.assert( String.isNotEmpty(cronId), 'A Scheduled Job ID should have been mapped' );

        Integer count =  Database.countQuery( 'SELECT count() FROM CronTrigger WHERE Id = :cronId' );
        System.assert( count == 1, 'Expected to find a matching CronTrigger!' );
    }


    static testMethod void testUpdateOffToOnFail() {
        System.debug('\n\n\n<<<<<<<<<<STARTING testInsert>>>>>>>>>>\n\n');
        boolean failed = false;
        Batch_Job__c job = null;

        try {
            job = new Batch_Job__c();
            job.Name = 'Test Job 1';
            job.Cron_Expression__c = 'XYZ';
            job.Apex_Class__c = 'BD_TestBatch';
            job.Comments__c = 'Bad Cron Expression.';
            job.State__c = 'Off';
            insert job;

            Test.startTest();
            job.State__c = 'Ready';
            update job;
            Test.stopTest();

        } catch( Exception e ) {
            System.assert( String.isEmpty( job.Scheduled_Job_Id__c ), 'Expected Schedule Job to be empty!' );
            failed = true;
        }

        System.assert(failed, 'Should have thrown an exception for having bad data.');
     }


    static testMethod void testActiveToFalse() {
        System.debug('\n\n\n<<<<<<<<<<STARTING testActiveToFalse>>>>>>>>>>\n\n');
        Batch_Job__c job = null;
        String jobId = null;

        try {
            job = new Batch_Job__c();
            job.Name = 'Test Job 1';
            job.Cron_Expression__c = '0 0 13 * * ?';
            job.Apex_Class__c = 'BD_TestBatch';
            job.Comments__c = 'Sample comment for batch job test.';
            insert job;

            jobId = job.Id;
            job.Active__c = false;
            Test.startTest();
            update job;
            Test.stopTest();

        } catch( Exception e ) {
            System.assert( false, 'Excpetion caught during test :: ' + e );
        }

        Batch_Job__c updatedJob = [ SELECT Name, Active__c, Scheduled_Job_Id__c
                FROM Batch_Job__c WHERE Id = :job.Id ];
        System.assert( !updatedJob.Active__c, 'Active flag did not update!'  );
        System.assert( String.isEmpty( updatedJob.Scheduled_Job_Id__c ), 'Expected Schedule Job to be blank!' );

        Integer count =  Database.countQuery( 'SELECT count() FROM CronTrigger WHERE Id = :jobId' );
        System.assert( count == 0, 'The job should have been removed from the system!' );
    }


    static testMethod void testActiveToTrue() {
        System.debug('\n\n\n<<<<<<<<<<STARTING testActiveToTrue>>>>>>>>>>\n\n');
        Batch_Job__c job = null;

        try {
            job = new Batch_Job__c();
            job.Name = 'Test Job 1';
            job.Cron_Expression__c = '0 0 13 * * ?';
            job.Apex_Class__c = 'BD_TestBatch';
            job.Comments__c = 'Sample comment for batch job test.';
            insert job;

            job.Active__c = false;
            update job;

            job.Active__c = true;
            Test.startTest();
            update job;
            Test.stopTest();

        } catch( Exception e ) {
            System.assert( false, 'Excpetion caught during test :: ' + e );
        }

        Batch_Job__c updatedJob = [ SELECT Name, Active__c, Scheduled_Job_Id__c, State__c
                FROM Batch_Job__c WHERE Id = :job.Id ];
        System.assert( updatedJob.Active__c, 'Active flag did not update!'  );
        System.assert( String.isEmpty( updatedJob.Scheduled_Job_Id__c ), 'Expected Schedule Job to be empty!' );
        System.assertEquals( updatedJob.State__c, 'Off', 'Expected Schedule Job to be empty!' );

        String jobId = updatedJob.Scheduled_Job_Id__c;
        Integer count =  Database.countQuery( 'SELECT count() FROM CronTrigger WHERE Id = :jobId' );
        System.assert( count == 0, 'No job should have been added from the system!' );
    }


    static testMethod void testDelete() {
        System.debug('\n\n\n<<<<<<<<<<STARTING testDelete>>>>>>>>>>\n\n');

        Integer beforeCount =  Database.countQuery( 'SELECT count() FROM Batch_Job__c' );
        Batch_Job__c job = null;
        Batch_Job__c theJob = null;

                try {
            job = new Batch_Job__c();
            job.Name = 'Test Job 1';
            job.Cron_Expression__c = '0 0 13 * * ?';
            job.Apex_Class__c = 'BD_TestBatch';
            job.Comments__c = 'Sample comment for batch job test.';
            job.State__c = 'Ready';
            insert job;

            theJob = [SELECT Name, Scheduled_Job_Id__c FROM Batch_Job__c WHERE Id = :job.Id];

            Test.startTest();
            delete job;
            Test.stopTest();

        } catch( Exception e ) {
            System.assert( false, 'Excpetion caught during test :: ' + e );
        }

        Integer afterCount =  Database.countQuery( 'SELECT count() FROM Batch_Job__c' );
        System.assertEquals( beforeCount, afterCount, 'No new jobs should exist!');

        String cronId = theJob.Scheduled_Job_Id__c;
        Integer count =  Database.countQuery( 'SELECT count() FROM CronTrigger WHERE Id = :cronId' );
        System.assert( count == 0, 'Expected to not find a matching CronTrigger!' );
    }

}