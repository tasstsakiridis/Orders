trigger afterInsertOrderItem on Order_Item__c (before insert, before update) {
    for (Order_Item__c myOrderItem : Trigger.new) {
        //Price Tolerance Code
        if (myOrderItem.Price_Ref_Material__c != null)  {
            List<Price_Tolerance__c> GetPA = [Select Max_PA_Per_Case__c, PRM_Units_Per_Case__c From Price_Tolerance__c where Reference_Material_Group__c =:myOrderItem.Price_Ref_Material__c and Banner_Partner__c =:myOrderItem.Banner_Partner__c];
            if(GetPA != null && GetPA.size() > 0){
                myOrderItem.Max_PA_Per_Case__c = GetPA[0].Max_PA_Per_Case__c;
                myOrderItem.PRM_Units_Per_Case__c = GetPA[0].PRM_Units_Per_Case__c;
            }else {
                myOrderItem.Max_PA_Per_Case__c = null;
                myOrderItem.PRM_Units_Per_Case__c = null;   
            
            }//GetPA            
        }
        
        //Wholesaler Product Lookup   
        if (myOrderItem.Wholesaler__c != null) {
            System.debug('myOrderItem.Wholesaler__c: ' + myOrderItem.Wholesaler__c + ', myOrderItem.SAP_Material_Number__c: ' + myOrderItem.SAP_Material_Number__c);
            String sapMaterialNumber = myOrderItem.SAP_Material_Number__c;
            if (myOrderItem.SAP_Material_Number__c == null) {
                List<Wholesaler_Product__c> l_wp = [SELECT SAP_Material_Number__c FROM Wholesaler_Product__c WHERE Wholesaler_Number__c = :myOrderItem.Wholesaler__c AND Product__c = :myOrderItem.Product__c];
                if (l_wp != null && l_wp.size() > 0) {
                    sapMaterialNumber = l_wp[0].SAP_Material_Number__c; 
                }
            }
            
            System.debug('sapMaterialNumber: ' + sapMaterialNumber);
            if (sapMaterialNumber == null || sapMaterialNumber.length() == 0) {
                myOrderItem.Wholesaler_Product__c = null; 
                myOrderItem.Missing_Material__c = 1;
            } else {
                if (myOrderItem.Order__r.Market__c != 'Taiwan') {
                    List<Wholesaler_Product__c> GetNum = [Select Name, Description_of_the_Material_Provided__c, id from Wholesaler_Product__c where Wholesaler_Number__c =:myOrderItem.Wholesaler__c and SAP_Material_Number__c =:sapMaterialNumber and Is_Active__c = true];

                    if(GetNum != null && GetNum.size() > 0){
                        myOrderItem.Wholesaler_Product__c = GetNum[0].id;
                        myOrderItem.Missing_Material__c = 0;
                    }else {
                        myOrderItem.Wholesaler_Product__c = null; 
                        myOrderItem.Missing_Material__c = 1;
                    }//GetNum
                }
            }
        }
    }
    




}