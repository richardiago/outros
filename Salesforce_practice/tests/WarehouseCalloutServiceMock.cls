@isTest
global class WarehouseCalloutServiceMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"_id":"abc123","replacement":false,"quantity":5,"name":"Teste 1 Teste 1 Teste 1","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"},'+ 
                          '{"_id":"xyz","replacement":true,"quantity":183,"name":"Teste 2 Teste 2 Teste 2","maintenanceperiod":0,"lifespan":0,"cost":300,"sku":"100004"}]');

        response.setStatusCode(200);
        return response; 
    }
}