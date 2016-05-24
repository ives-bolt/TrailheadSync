public class StringArrayTest {

    public static List<String> generateStringArray( Integer num ) {
        System.debug('Asked to generate ' + num + ' tokens.');
        List<String> strings = new List<String>();
		
        for(Integer i=0; i<num; i++) {
            String token = 'Test ' + i;
            strings.add( token );
            System.debug('Created token: ' + token);
        }
        
        // Test it
        System.assert(strings.size() == num);
        
        return strings;
    }
    
}