public with sharing class OrderItem_Redirect_Controller {
	Order_Item__c oi;
	Order__c order;
    String orderId;
    String marketName;
    
	public OrderItem_Redirect_Controller(ApexPages.StandardController controller) {
		this.oi = (Order_Item__c)controller.getRecord();
        if (this.oi.Id == null) {
            Map<String, String> pageParams = ApexPages.currentPage().getParameters();
            if (pageParams.containsKey('order')) {
                this.orderId = pageParams.get('order');
				this.order = [SELECT Id, Account__c, RecordTypeId, Account__r.Market__r.Name FROM Order__c WHERE Id =:this.orderId];
                this.marketName = this.order.Account__r.Market__r.Name;
            }
        } else {
			this.oi = [SELECT Order__c, Order__r.Account__c, Order__r.RecordTypeId, Order__r.Account__r.Market__r.Name FROM Order_Item__c WHERE Id =:oi.Id];            
            this.orderId = this.oi.Order__c;
            this.marketName = this.oi.Order__r.Account__r.Market__r.Name;
        }
        
	}
	
	public PageReference Redirect() {
        PageReference ref = Page.orderItemsHTML;            
        
		ref.getParameters().put('Id', this.orderId);
        ref.getParameters().put('retUrl',this.orderId);
		return ref;
	}
}