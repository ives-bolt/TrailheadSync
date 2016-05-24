/**
 * Created by john on 3/31/16.
 */

public with sharing class AccountProcessor {
    @future
    public static void countContacts( List<Id> acctIdList ) {
        List<Account> accounts = [ SELECT Number_of_Contacts__c, ( SELECT Contact.Id FROM Account.Contacts ) FROM Account WHERE Account.Id IN :acctIdList ];

        for( Account a : accounts ) {
            Integer count = a.Contacts.size();
            System.debug( 'Account: ' + a );
            System.debug( 'Count: ' + count );
            a.Number_of_Contacts__c = count;
        }

        update accounts;
    }
}