public class WarehouseCalloutService {
    
    //Faz a requisição GET e recebe os dados a serem atualizados
    @future(callout=true)
    public static void runWarehouseEquipmentSync(){

        //Requisição
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200){

            List<Product2Json> results = (List<Product2Json>) JSON.deserialize(response.getBody(), List<Product2Json>.class);
            upsertEquipment(results);
        }

    }

    //Faz o update dos objetos recebidos
    public static void upsertEquipment(List<Product2Json> equips) {

        List<Product2> productUpdateList = new List<Product2>();

        for(Product2Json p2j : equips){
            Product2 np = p2j.getEquipment();
            productUpdateList.add(np);

        }

        upsert productUpdateList Warehouse_SKU__c;
    }

    

    //Inner Class p/ Product2
    public class Product2Json{

        String id;
        Boolean replacement;
        Integer quantity;
        String name;
        Integer lifespan;
        Integer cost;
        String sku;
        Integer maintenanceperiod;


        //Match de Product2Json com Product2 
        public Product2 getEquipment(){

            Product2 np = new Product2();

            np.Replacement_Part__c = this.replacement;
            np.Cost__c = this.cost;
            np.Current_Inventory__c = this.quantity;
            np.Lifespan_Months__c = this.lifespan;
            np.Maintenance_Cycle__c	= this.maintenanceperiod;
            np.Warehouse_SKU__c	= this.sku;
            np.Name = this.name;
            np.ProductCode = this.id;

            return np;
        }

    }
}

