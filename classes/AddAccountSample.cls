public with sharing class AddAccountSample {
	public AddAccountSample() {
		// Create the account sObject 
		Account acct = new Account(Name='Acme', Phone='(415)555-1212', NumberOfEmployees=100);
		// Insert the account by using DML
		insert acct;

		// Get the new ID on the inserted sObject argument
		ID acctID = acct.Id;

		System.debug('Inserted Account Object - ID: ' + acctID + ' :: ' + acct);
	}
}