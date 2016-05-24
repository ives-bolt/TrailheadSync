public class AnimalLocator {
    public static String getAnimalNameById( Integer id ) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        String name = null;
        
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'animals' key as a list
            Map<String, Object> animals = (Map<String, Object>) results.get('animal');
            name = (String) animals.get('name');
            System.debug('Animal Object is: ' + animals);
        }
        
        return name;
 
    }
}