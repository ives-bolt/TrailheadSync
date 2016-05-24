public class ParkLocator {
	
    public static String[] country( String countryName ) {
        
        ParkService.ParksImplPort parkService = new ParkService.ParksImplPort();
        String[] parks = parkService.byCountry(countryName);
       	System.debug('Parks in ' + countryName + ' are: ' + parks);
        
        return parks;
    }
}