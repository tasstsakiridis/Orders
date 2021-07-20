/**
* Test Class in this class
*/
public with sharing class TWN_Order_Wholesaler_Email_Controller {
    public Order__c theOrder;
    public void setTheOrder(Order__c order) {
        if (order != null) {
            theOrder = [SELECT Id, Name, RecordTypeId, RecordType.Name, Status__c, Market__c, Account__c,
                                Account__r.Name, Wholesaler_Name__c,
                            (SELECT Id, Product__c, Product_Description__c, Brand_Name__c, Unit__c, Unit_Bonus__c 
                                FROM Order_Items__r)
                        FROM Order__c 
                        WHERE Id =:order.Id];

            this.items = theOrder.Order_Items__r;
        }
    }
    public Order__c getTheOrder() {
        return theOrder;
    }    

    public String msg { get; set; }
    public List<Order_Item__c> items { get; set; }
}