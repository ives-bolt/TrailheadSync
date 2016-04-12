@isTest
public class AccountManagerTest {
	@isTest static void testGetAccount() {
        // Set up a test request
        Id testId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://na30.salesforce.com/services/apexrest/Accounts/' + testId + '/contacts/';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account thisAccount = AccountManager.getAccount();
        // Verify results
        System.debug('Account: ' + thisAccount);
        System.assert(thisAccount != null);
        System.debug('Contacts: ' + thisAccount.Contacts);
        System.assert(thisAccount.Contacts != null);

        
    }
    
    // Helper method
        static Id createTestRecord() {
        // Create test record
        Account testAcc = new Account(
          Name='Test record');
        insert testAcc;
        Contact testCon= new Contact(
        FirstName='John',
        LastName='Smith', 
        AccountId = testAcc.id);
        insert testCon;
        return testAcc.Id;
    }      
}