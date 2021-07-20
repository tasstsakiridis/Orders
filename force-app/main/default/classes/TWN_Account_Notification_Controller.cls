/**
* Test Class:  TWN_Account_Notification_Controller_Test
*/
public with sharing class TWN_Account_Notification_Controller {
    public Account theAccount;
    public void setTheAccount(Account a) {
        this.isActivating = false;
        if (a != null) {
            theAccount = [SELECT Id, Name, RecordTypeId, RecordType.Name, Status__c, Market__c, Type_of_Application__c,
                                Detail_Link__c
                        FROM Account 
                        WHERE Id =:a.Id];

            this.isActivating = theAccount.Type_of_Application__c != null && theAccount.Type_of_Application__c == 'Activate';
            String s = Label.Account_Activation_Notification;
            if (!this.isActivating) {
                s = Label.Account_DeActivation_Notification;
            }

            msg = s.replace('{0}', theAccount.Name);
            this.detailLink = theAccount.Detail_Link__c;
        }
    }
    public Account getTheAccount() {
        return theAccount;
    }    

    public Boolean isActivating { get; set; }
    public String msg { get; set; }
    public String detailLink { get; set; }
}