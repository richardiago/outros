@isTest
public class MaintenanceRequestTest {
    
    @isTest static void positiveCaseWithEquipmentDateCycleTest(){

        List<Case> listCase = createCase(1, 0, 0);

        listCase[0].Status = 'Closed';

        //Perform Test
        Test.startTest();
        update listCase;

        List<Case> newCase = [SELECT Id, Vehicle__c, Equipment__c, Date_Due__c, Status FROM Case 
                                WHERE Vehicle__c =: listCase[0].Vehicle__c AND
                                Equipment__c =: listCase[0].Equipment__c AND Status =: 'New'];
        Test.stopTest();

        //Verify
        System.assert(newCase.size() == 1);
        System.assertEquals(listCase[0].Vehicle__c, newCase[0].Vehicle__c);
        System.assertEquals(listCase[0].Equipment__c, newCase[0].Equipment__c);
        System.assertEquals(System.today()+60, newCase[0].Date_Due__c);

    }

    @isTest static void positiveCaseWithoutEquipmentDateCycleTest(){

        List<Case> listCase = createCase(1, 0, 1);

        listCase[0].Status = 'Closed';

        //Perform Test
        Test.startTest();
        update listCase;

        List<Case> newCase = [SELECT Id, Vehicle__c, Equipment__c, Date_Due__c, Status FROM Case 
                                WHERE Vehicle__c =: listCase[0].Vehicle__c AND
                                Equipment__c =: listCase[0].Equipment__c AND Status =: 'New'];
        Test.stopTest();

        //Verify
        System.assert(newCase.size() == 1);
        System.assertEquals(listCase[0].Vehicle__c, newCase[0].Vehicle__c);
        System.assertEquals(listCase[0].Equipment__c, newCase[0].Equipment__c);
        System.assertEquals(listCase[0].Date_Due__c, newCase[0].Date_Due__c);

    }

    @isTest static void negativeCaseTest(){

        List<Case> listCase = createCase(1, 1, 0);

        listCase[0].Status = 'Closed';

        Test.startTest();
        update listCase;

        List<Case> newCase = [SELECT Id, Vehicle__c, Equipment__c, Status FROM Case 
                                WHERE Vehicle__c =:listCase[0].Vehicle__c AND
                                Equipment__c =: listCase[0].Equipment__c AND Status =: 'New'];
        Test.stopTest();

        System.assert(newCase.size() == 0);

    }

    @isTest static void bulkCaseTest(){

        List<Case> listCase = createCase(200, 0, 0);

        for(Case c : listCase){
            c.Status = 'Closed';
        }

        Test.startTest();
        update listCase;

        List<Case> newCase = [SELECT Id, Vehicle__c, Equipment__c, Status FROM Case 
                                WHERE Vehicle__c =: listCase[0].Vehicle__c AND
                                Equipment__c =: listCase[0].Equipment__c AND Status =: 'New'];
        Test.stopTest();

        System.assert(newCase.size() == 200);
        

    }

    //Função auxiliar que cria Cases com Work_Parts
    public static List<Case> createCase(Integer quant, Integer f, Integer g){

        List<Case> caseList = new List<Case>();

        //Cria Vehicle__c e Product2 para associar ao Case
        Vehicle__c car = new Vehicle__c(Name = 'VeiculoTeste');
        insert car;

        Product2 equip = new Product2(Name = 'Equipamento de Teste', Replacement_Part__c = true, IsActive = true);
        if(g == 0) {equip.Maintenance_Cycle__c = 60;}
        insert equip;

        for(Integer i = 0; i<quant; i++){

            if(f == 0){
                caseList.add(new Case(Type = 'Repair', Subject = 'Assunto', Status = 'Working', Vehicle__c = car.Id, Equipment__c = equip.Id));           
            }
            else{
                caseList.add(new Case(Type='Other', Subject = 'Assunto2', Status = 'Working', Vehicle__c = car.Id, Equipment__c = equip.Id));  
            }
        }

        insert caseList;

        //Cria Work_Part's associados aos Cases
        List<Work_Part__c> wpList = new List<Work_Part__c>();

        for(Case c : caseList){
            Work_Part__c wp = new Work_Part__c(Maintenance_Request__c = c.Id, Equipment__c = c.Equipment__c);
            wpList.add(wp);
        }   

        insert wpList;
        return caseList;
    }
    
}
