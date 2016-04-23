/**
 * @author john 
 * @date 3/31/16
 * @description DESCRIPTION_HERE
 */

public with sharing class TempClass {
    public Long myId = -1;

    public TempClass() {
        System.debug('Created an new instance of class TempClass!!!');
        myId = System.currentTimeMillis();
    }


    public Long getMyId() {
        return myId;
    }

}