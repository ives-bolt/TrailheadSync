/**
 * @author John Ives
 * @date 4/21/16
 * @description 
 */

public with sharing class TempClassCreator {

    public static void create() {
        Type t = Type.forName('TempClass');
        TempClass tc = (TempClass) t.newInstance();
        System.debug( 'ID of newly created class: ' + tc.getMyId() );
    }

}