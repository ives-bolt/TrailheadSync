/**
 * Created by john on 3/31/16.
 */

@IsTest
private class AccountProcessorTest {
    static testMethod void countContacts() {


        Account a1 = new Account(Name = 'Test Account');
        Account a2 = new Account(Name = 'Another Test Account');
        insert new Account[]{a1, a2};

        Contact c1 = new Contact( FirstName='John', LastName='Ives', Phone='123.456.7890', AccountId=a1.ID);
        Contact c2 = new Contact( FirstName='John', LastName='Ives', Phone='123.456.7890', AccountId=a2.ID);
        insert new Contact[]{c1, c2};

        List<Id> ids = new List<Id>{a1.Id, a2.Id};

        Test.startTest();
        System.debug('------>>>>> Starting test...');
        AccountProcessor.countContacts( ids );
        Test.stopTest();

        // Validate
        Account[] accountList = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id IN :ids];
        for( Account a : accountList ) {
            System.assert(a.Number_of_Contacts__c == 1, 'Number of Contacts did not match.');
        }
    }
}