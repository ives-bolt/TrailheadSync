@isTest
public class TestRestrictContactByName {
    
    @isTest static void test_RestrictContactByName() {
        Contact c = new Contact();
        c.FirstName = 'Dumbo';
        c.LastName = 'INVALIDNAME';
        
        // Perform test
        Test.startTest();
       	Database.SaveResult result = Database.insert(c, false);
        Test.stopTest();
        
        System.debug('Starting Assert for fail scenerio test_RestrictContactByName: ' + result);
     	System.assert( !result.isSuccess() );
        System.debug('Finished test_RestrictContactByName');
    } 
    
    @isTest static void test_RestrictContactByName2() {
        Contact c = new Contact();
        c.FirstName = 'John';
        c.LastName = 'Ives';
        
         // Perform test
        Test.startTest();
       	Database.SaveResult result = Database.insert(c);
        Test.stopTest();
        
     	System.assert( result.isSuccess() );
        System.debug('Finished test_RestrictContactByName2');
    }
        
}