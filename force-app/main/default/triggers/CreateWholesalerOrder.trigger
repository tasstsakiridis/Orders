trigger CreateWholesalerOrder on Order__c (before insert, after insert) {
    if (Trigger.isBefore) {
       //for(Order__c ord: Trigger.new) {
       //   ord.OwnerName__c = [SELECT Name FROM User WHERE Id =:ord.OwnerId LIMIT 1].Name;
       //}
    } else {
    List<Wholesaler_Orders_Junction__c> wh_Orders = new List<Wholesaler_Orders_Junction__c>();
    for (Order__c ord : Trigger.new) {
        System.debug('ord.id: ' + ord.Id + ', wholesaler_code: ' + ord.Wholesaler_Code__c);
        wh_Orders.add(new Wholesaler_Orders_Junction__c (Order__c=ord.Id, 
                                                         Wholesaler__c=ord.Wholesaler_Code__c)
                     );
                     
    }
    
    if (wh_Orders.size() > 0) {
        insert wh_Orders;       
    }
    }
}