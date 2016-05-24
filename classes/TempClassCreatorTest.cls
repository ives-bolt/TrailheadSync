/**
 * @author John Ives
 * @date 4/21/16
 * @description 
 */

@IsTest
private class TempClassCreatorTest {
    static testMethod void testBehavior() {
        TempClassCreator.create();
        for(Integer i = 0 ; i < 100000; i++ ) {}
        TempClassCreator.create();
        for(Integer i = 0 ; i < 100000; i++ ) {}
        TempClassCreator.create();

    }
}