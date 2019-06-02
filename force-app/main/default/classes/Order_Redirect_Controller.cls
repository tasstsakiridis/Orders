public with sharing class Order_Redirect_Controller {
	Order__c thisOrder;
    String recordTypeId;
    Map<String,String> pageParams;
	
	public Order_Redirect_Controller(ApexPages.StandardController controller) {
        pageParams = ApexPages.currentPage().getParameters();
        for(String s : pageParams.keySet()) {
            System.debug('pageparam. ' + s + ' : ' + pageParams.get(s));
        }
		thisOrder = (Order__c)controller.getRecord();
        System.debug('order.Id: ' + thisOrder.Id);
        if (thisOrder.Id != null) {
        	thisOrder = [SELECT Id, Name, RecordTypeId, Account__c, CallCard__c FROM Order__c WHERE Id =:thisOrder.Id];            
            if (pageParams.containsKey('RecordType')) {
                recordTypeId = pageParams.get('RecordType');
            } else {
	            recordTypeId = thisOrder.RecordTypeId;                
            }
        } else {
            recordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        }
	}
	
	public PageReference Redirect() {
        String orderKeyPrefix = Order__c.SObjectType.getDescribe().getKeyPrefix();
        if (recordTypeId == null) {
	        Map<String, RecordTypeInfo> rtMap = Order__c.SObjectType.getDescribe().getRecordTypeInfosByName();
            for(RecordTypeInfo rti : rtMap.values()) {
                System.debug('recordType: ' + rti.getName() + ', id: ' + rti.getRecordTypeId() + ', isDefault: ' + rti.isDefaultRecordTypeMapping() + ', available: ' + rti.isAvailable() + ', isMaster: ' + rti.isMaster());
                if (rti.isAvailable() == true && rti.isMaster() == false) {
                    recordTypeId = rti.getRecordTypeId();
                    break;
                }
            }
        }
        System.debug('recordTypeId: ' + recordTypeId);
		PageReference ref = Page.Order;
        ref.getParameters().put('recordTypeId', recordTypeId);            
        if (thisOrder != null) {
            ref.getParameters().put('id', thisOrder.Id);
            ref.getParameters().put('accountId', thisOrder.Account__c);                
            ref.getParameters().put('callCardId', thisOrder.CallCard__c);                                
        }
        /*
        if (recordTypeId == rtNewDirect || recordTypeId == rtNewIndirect) {
            ref.getParameters().put('recordTypeId', recordTypeId);            
            if (thisOrder != null) {
                ref.getParameters().put('id', thisOrder.Id);
                ref.getParameters().put('accountId', thisOrder.Account__c);                
                ref.getParameters().put('callCardId', thisOrder.CallCard__c);                                
            }
        } else {
            String refUrl = '';
            if (thisOrder.Id == null) {
				refUrl = '/'+orderKeyPrefix + '/e';
            } else {
			    refUrl = '/'+thisOrder.Id+'/e';
            }
                        
            ref = new PageReference(refUrl);
            ref.getParameters().put('RecordType', recordTypeId);
            ref.getParameters().put('nooverride', '1');
            for(String s : pageParams.keySet()) {
                if (s.startsWithIgnoreCase('CF00')) {
	                ref.getParameters().put(s, pageParams.get(s));   
                }
            } 
            
            if(pageParams.containsKey('retUrl')) {
	            ref.getParameters().put('retUrl',pageParams.get('retUrl'));  
            }
            System.debug('ref: ' + ref.getUrl());
    		ref.setRedirect(true);            
        }
        */       
		return ref;
	}
}