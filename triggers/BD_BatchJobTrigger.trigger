/**
 * @author John Ives
 * @date 4/22/16
 * @description Trigger for events on the Batch Job object.
 */

trigger BD_BatchJobTrigger on Batch_Job__c (before insert, before update, before delete) {
    BD_BatchJobHelper helper = new BD_BatchJobHelper();

    if( Trigger.isBefore ) {
        if( Trigger.isDelete ) helper.beforeDelete( Trigger.old );
        else if( Trigger.isInsert ) helper.beforeInsert( Trigger.new );
        else if(  Trigger.isUpdate ) helper.beforeUpdate( Trigger.new, Trigger.oldMap );
    }

}