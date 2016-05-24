public class SubstringBetweenTest {
    static void test() {
        String url = 'blah/blah/blah/Accounts/1234567890/contacts';
        String accountID = url.substringBetween('Accounts/', '/contacts');
        System.debug('Account ID: ' + accountID);
    }
}