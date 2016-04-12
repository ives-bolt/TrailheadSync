/**
 * @author John Ives
 * @date 4/7/16
 * @description 
 */

public with sharing class TestBatchClass implements Schedulable {
    public void execute(SchedulableContext sc) {
        System.debug( 'Inside TestBatchClass' );
    }
}