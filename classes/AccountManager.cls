@RestResource(urlMapping='/Accounts/*/contacts')
global with sharing class AccountManager {
    
	@HttpGet 
    global static Account getAccount() {
        RestRequest request = RestContext.request;
        
        // Grab the account id from the URL
        String accountID = request.requestURI.substringBetween('Accounts/', '/contacts');
        System.debug( 'AccountID: ' + accountID );
        
        Account[] account = [SELECT Account.Id, Account.Name, (SELECT Contact.Id, Contact.Name FROM Account.Contacts) FROM Account WHERE Account.Id = :accountID];
        Account a = null;
        
        if( account.size() > 0 ) {
            a = account[0];
            System.debug('Account Data: ' + a);
        } else {
            System.debug('No records found!');
        }
        
        return a;
    }
    
}