@isTest
private class TestVerifyDate {
	
	@isTest static void test_CheckDates() {
		Date d1 = Date.today();
		System.debug('New date is: ' +d1 );
		Date d2 = d1.addDays(15);

		System.assertNotEquals( VerifyDate.CheckDates(d2, d1), d2, 'Date in past failed' );

		System.assertEquals( VerifyDate.CheckDates(d1, d2), d2, 'Date within 30 days failed' );

		d2 = d1.addDays(45);
		System.assertNotEquals( VerifyDate.CheckDates(d1, d2), d2, 'Date outside 30 days failed' );

        System.debug('The test has finished.');
	}
	
	
}