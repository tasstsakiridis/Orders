trigger OrderItem on Order_Item__c (before insert, before update, after update) {
    if (Trigger.isBefore) {
        for(Order_Item__c oi : Trigger.new) {
	        //Wholesaler Product Lookup   
            if (oi.Wholesaler__c != null) {
                List<Wholesaler_Product__c> l_wp;
                String sapMaterialNumber = oi.SAP_Material_Number__c;
                oi.Missing_Material__c = 1;
				oi.Wholesaler_Product__c = null;
                
                if (sapMaterialNumber == null) {
                    l_wp = [SELECT Id, SAP_Material_Number__c FROM Wholesaler_Product__c WHERE Wholesaler_Number__c =:oi.Wholesaler__c AND Product__c =:oi.Product__c AND Is_Active__c = true];
                } else {
                    l_wp = [SELECT Id FROM Wholesaler_Product__c WHERE Wholesaler_Number__c =:oi.Wholesaler__c AND SAP_Material_Number__c =:sapMaterialNumber AND Is_Active__c = true];
                }

                if (l_wp != null && l_wp.size() > 0) {
                    oi.Wholesaler_Product__c = l_wp.get(0).Id;
                    oi.Missing_Material__c = 0;
                }
            }
        }
        
    } else {
        List<id> orderList = new List<id>();
        for (Order_Item__c oi : trigger.new){
            orderList.add(oi.Order__c);    
        }
        //Get a list of orders to send to the goal helper
        List <Order__c> orders = [select Id,CreatedBy.id, (select id, Product__r.Brand__c, Product__c, 
                                                           order__r.id, order__r.CreatedBy.id, order__r.Order_date__c
                                                           from order_items__r) 
                                  from Order__c 
                                  where Id in :orderList];
        System.debug('Trigger Orders sent to goal helper: '+orders);
        
        //Send away!
        if (orders.size() > 0){
            Goal_Helper.orderGoal(orders);        
        }    
        
    }
}