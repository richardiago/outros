@isTest
private class WarehouseCalloutServiceTest{

    @isTest
    static void testGetCallout(){

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        // Call method to test
        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();

        WarehouseSyncSchedule updateEquipments = new WarehouseSyncSchedule();
        String sch = '0 0 13 * * ?';
        String jobID = System.schedule('Update Equipments2', sch, updateEquipments);
        Test.stopTest();

        List<Product2> resultList = [SELECT Name FROM Product2 ORDER BY Name];

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id =: jobID];
        System.assertEquals(sch, ct.CronExpression);

        // Verifica quantidade de objetos na lista
        System.assertEquals(2, resultList.size());

        //Verifica dados do 1º objeto da lista
        System.assertEquals('Teste 1 Teste 1 Teste 1', resultList[0].name);

        //Verifica dados do 2º objeto da lista
        System.assertEquals('Teste 2 Teste 2 Teste 2', resultList[1].name);

    }
}