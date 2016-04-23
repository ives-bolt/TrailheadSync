/**
 * @author John Ives
 * @date 4/22/16
 * @description Trigger for events on the Batch Job object.
 */

trigger BD_BatchJobTrigger on Batch_Job__c (before insert, before update, before delete) {
    BD_BatchJobHelper helper = new BD_BatchJobHelper();

    if( Trigger.isBefore ) {
        if( Trigger.isDelete ) {
            // TODO call delete logic
        } else if( Trigger.isInsert || Trigger.isUpdate ) {
            // TODO call new/update logic
        }
    } else {
        // Do nothing for now
    }


}