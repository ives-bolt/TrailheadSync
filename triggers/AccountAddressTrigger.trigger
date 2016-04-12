trigger AccountAddressTrigger on Account (before insert, before update) {
	for( Account a : Trigger.New ) {
        if( a.BillingPostalCode != null && a.Match_Billing_Address__c == true ) {
        	System.debug('Setting shipping postal code to billing postal code for: ' + a);
        	a.ShippingPostalCode = a.BillingPostalCode;
        }
    }   
}