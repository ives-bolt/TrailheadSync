trigger HelloWorldTrigger on Account (before insert) {
    System.debug('Hello World!');
    Account a = new Account();
}