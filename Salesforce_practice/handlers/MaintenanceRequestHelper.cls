public class MaintenanceRequestHelper {
    
    public static void createCaseRequest(List<Case> caseList){

        List<Case> filterdCaseList = filterCases(caseList);
        List<Case> newCaseList = new List<Case>();
        List<Work_Part__c> newWorkList = new List<Work_Part__c>();
        Map<String, Integer> result = getDueDate(filterdCaseList);

        //Cria Cases (Maintenance Request)
        if(filterdCaseList.size() != 0){

            for(Case c: filterdCaseList){
                Case cs = createCase(c, result);
                newCaseList.add(cs);
            }

            insert newCaseList;

            //Cria Work_Part__c's
            for(Case c: newCaseList){
                Work_Part__c wp = createWorkPart(c);
                newWorkList.add(wp);
            }

            insert newWorkList;
        }        

    }

    public static Map<String, Integer> getDueDate(List<Case> caseIDs){

        Map<String, Integer> result = new Map<String, Integer>();
        Map<Id, Case> caseKeys = new Map<Id, Case>(caseIDs);

        List<AggregateResult> wpc = [SELECT Maintenance_Request__r.ID cID, min(Equipment__r.Maintenance_Cycle__c) cycle
                                    FROM Work_Part__c WHERE Maintenance_Request__r.ID IN: caseKeys.keySet() GROUP BY Maintenance_Request__r.ID];

        for(AggregateResult res : wpc){
            Integer addDays = 0;
            if(res.get('cycle') != null)
                addDays += Integer.valueOf(res.get('cycle'));
            result.put((String) res.get('cID'), addDays);
        }

        return result;
    }

    public static List<Case> filterCases(List<Case> caseList){

        List<Case> result = new List<Case>();

        for(Case c: caseList){
            if((c.Type == 'Repair' || c.Type == 'Routine Maintenance') && c.Status == 'Closed'){
                result.add(c);
            }
        }

        return result;
    }

    public static Case createCase(Case c, Map<String, Integer> result){

        Case cs = new Case();

        cs.Vehicle__c = c.Vehicle__c;
        cs.Equipment__c = c.Equipment__c;
        cs.Type = 'Routine Maintenance';
        cs.Subject = 'Routine Maintenance';
        cs.Status = 'New';
        cs.Date_Reported__c = System.today();

        if(result.get(c.Id) != 0 && result.get(c.Id) != null) cs.Date_Due__c = System.today()+result.get(c.Id);
        //else cs.Date_Due__c = null;

        return cs;

    }

    public static Work_Part__c createWorkPart(Case c){

        Work_Part__c wp = new Work_Part__c();

        wp.Maintenance_Request__c = c.Id;
        wp.Equipment__c = c.Equipment__r.Id;

        return wp;
    }

}
