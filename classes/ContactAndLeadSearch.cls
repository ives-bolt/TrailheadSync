public with sharing class ContactAndLeadSearch {
	public ContactAndLeadSearch() {
		
	}

	public static List<List< SObject>> searchContactsAndLeads(String name) {

		List<List<sObject>> searchList = [FIND :name IN NAME FIELDS 
                   RETURNING Lead(Name),Contact(Name)];

		return searchList;
	}
}