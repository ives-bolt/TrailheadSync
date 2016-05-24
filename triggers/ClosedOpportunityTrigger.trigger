trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {

	List<Task> tasks = new List<Task>();

	for( Opportunity o : Trigger.new ) {
		if( o.StageName == 'Closed Won' ) {
			Task task = new Task();
			task.WhatId = o.Id;
			task.Subject = 'Follow Up Test Task';
			tasks.add(task);
		}
	}

	if( tasks.size() > 0 ) {
		insert tasks;
	}
}