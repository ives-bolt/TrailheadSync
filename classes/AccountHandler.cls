public with sharing class AccountHandler {
	public AccountHandler() {

	}

	public static Account insertNewAccount( String acctName ) {
		Account acct = new Account(Name=acctName);

		try {
				insert acct;
				System.debug('Insert Account Record for Name=' + acctName + ' : ID=' + acct.ID);

			} catch (DmlException e) {
				System.debug( 'DMLEXCEPTION Caught: ' + e.getMessage() );
				return null;
			}

			return acct;
	}
}