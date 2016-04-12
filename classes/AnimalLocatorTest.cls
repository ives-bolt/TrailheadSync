@isTest
public class AnimalLocatorTest {
    @isTest static void testGetAnimalName() {
        // Create the mock response based on a static resource
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock()); 
        // Call method to test
        String name = AnimalLocator.getAnimalNameById(2);
        System.debug('Name is ' + name);
        // Verify mock response is not null
        System.assertNotEquals(null,name,
            'The callout returned a null response.');
        // Verify the array contains 3 items    
        System.assertEquals('bear', name,
          'The name should equal bear.');          
    }   
	
}