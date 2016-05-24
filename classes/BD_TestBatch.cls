/**
 * @author John Ives
 * @date 4/25/16
 * @description Sample Schedulable class for testing purposes.
 */

public with sharing class BD_TestBatch implements Schedulable {
    public void execute( SchedulableContext context ) {
        System.debug('Inside execute method of BD_TestBatch with context: ' + context);
    }

}