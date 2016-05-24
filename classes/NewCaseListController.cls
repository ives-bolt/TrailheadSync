public class NewCaseListController {
    public List<Case> getNewCases() {
        String status = 'New';
        List<Case> results = Database.query('SELECT Id, CaseNumber FROM Case WHERE status=:status');
    	return results;
    }
}