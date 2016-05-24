public class RandomContactFactory {
    public static List<Contact> generateRandomContacts( Integer cNum, String lname ) {
        List<Contact> contacts = new List<Contact>();
        
        for( Integer i = 0; i < cNum; i++ ) {
            Contact c = new Contact();
            c.FirstName = 'FName'+i;
            c.LastName = lname;
      		
            contacts.add(c);
        }
        
        return contacts;
    }
}