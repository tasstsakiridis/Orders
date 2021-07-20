trigger Order on Order__c (after delete, after insert, after update) {
	List<Order__c> ol = new List<Order__c>();
    set<Id> callCardSet = new set<Id>();
    set<Id> callCardAdd = new set<Id>();
    set<Id> callCardSubtract = new set<Id>();
    
    if(!trigger.isDelete){
	    for(Order__c o: Trigger.new) {
	        if (o.Status__c != 'Waiting Approval') {
	            if (o.Status__c == 'New' && o.Is_Flagged_For_Approval__c == true && o.Material_Errors__c == 0 && o.Number_Of_LineItems__c > 0) {
	                try {
	                    Approval.Processsubmitrequest req = new Approval.Processsubmitrequest();
	                    req.setObjectId(o.Id);
	                
	                    Approval.ProcessResult pr = Approval.process(req);
	                } catch(Exception ex) {
	                    
	                }
	            }
	        }
	        if(trigger.isUpdate){
		        if(o.CallCard__c != trigger.oldMap.get(o.Id).CallCard__c){
		        	if(o.CallCard__c != null){
		        		callCardSet.add(o.CallCard__c);
		        	}else{
		        		callCardSet.add(trigger.oldMap.get(o.Id).CallCard__c);
		        	}  		
		        }
	        }
	        if(trigger.isInsert && o.CallCard__c != null){
        		callCardSet.add(o.CallCard__c);
	        }
	    }	        
    }else{
    	//trigger is delete
    	for(Order__c o:trigger.old){
    		if(o.CallCard__c != null){
    			callCardSubtract.add(o.CallCard__c);
    		}
    		callCardSet.add(o.CallCard__c);
    	}
    }
    if(!callCardSet.isEmpty()){
	    	set<CallCard__c> callCardUpdateSet = new set<CallCard__c>(); 
	    	for(CallCard__c cc:[SELECT Id, of_Orders__c, (SELECT Id FROM Orders__r) FROM CallCard__c WHERE Id IN :callCardSet]){
    			cc.of_Orders__c = cc.Orders__r.size();
	    		system.debug('cc.of_Orders__s: '+cc.of_Orders__c);
	    		callCardUpdateSet.add(cc);
	    	}
	    	list<CallCard__c> callCardList = new list<CallCard__c>();
	    	callCardList.addAll(callCardUpdateSet);
	    	update callCardList;
	    }
}