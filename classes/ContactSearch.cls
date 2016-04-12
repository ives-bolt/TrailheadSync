public with sharing class ContactSearch {
	public ContactSearch() {
		
	}

	public static List<Contact> searchForContacts( String lname, String zip ) {

		List<Contact> contacts = [select ID, Name, MailingPostalCode from Contact where Contact.LastName=:lname and Contact.MailingPostalCode=:zip];

		return contacts;
	} 

}