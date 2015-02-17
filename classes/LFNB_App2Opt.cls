public class LFNB_App2Opt {
	
    LFNB_F1_Case__c app;
    List<Opportunity> searchOpts = new List<Opportunity>();
    Boolean selected = true;
     
    public LFNB_F1_Case__c getAppTest(){
        if (app == null)
    		app = [select id, name, LFNB_Opportunity_Name__c, LFNB_Opportunity_ID__c from LFNB_F1_Case__c 
                     where id =:ApexPages.currentPage().getParameters().get('id')]; 
       	return app; 
    }
    
    public Boolean getSelected(){
        return selected;
    }
    
    public List<LFNB_F1_Case__c> getAppsTest(){  
        return [select id, name, LFNB_Opportunity_Name__c, LFNB_Opportunity_ID__c 
                	from LFNB_F1_Case__c limit 10];
    }
    
    public List<Opportunity> getOpts(){
       // return [select id, name from Opportunity where name = 'Dugan Gerald 58 Male 1 - MJ5GG'];
       return searchOpts;
    }
    
    public PageReference findOpts(){
        System.debug(ApexPages.currentPage().getParameters().get('oname'));
        searchOpts = [select id, name from Opportunity 
                	where name =:ApexPages.currentPage().getParameters().get('oname')];
        return null; // stay on the same page
    }
    
    public PageReference createNewOpt(){
        LFNB_F1_Case__c app;
        app = [select id, name, LFNB_Opportunity_Name__c, LFNB_Opportunity_ID__c 
                from LFNB_F1_Case__c 
               	where id =: 'a0kJ00000021HUu'];
        If(app != null){
            Opportunity opt = createOpt();
	        app.LFNB_Opportunity_ID__c = opt.Id;
            update app;
        }else{
            System.debug('No Case-App available with id:' + ApexPages.currentPage().getParameters().get('cid'));
        }
        
        return null;
    }
    
    private Opportunity createOpt(){
        Opportunity opt = new Opportunity();
        opt.name = 'case_2_opt_test';
        Account acc = [select id from Account where id = '001J000001Q6dW3'];
        opt.AccountId = acc.Id;
        opt.StageName = 'S07 - Formal';
        Date closeDate = date.today(); closeDate = closeDate.addMonths(3);
        opt.CloseDate = closeDate;
        insert opt;
        return opt;
    }

    /*
    *   helper class that represents a row
    */
    public with sharing class CCWRowItem{
 
        public LFNB_F1_Case__c app{get;set;}
        public Boolean IsSelected{get;set;}
 
        public CCWRowItem(LFNB_F1_Case__c c, Boolean s){
            this.app=c;
            this.IsSelected=s;
        }
    }    
    /*public PageReference save(){
    	PageReference p = null;
        try{
            Opportunity opt = new Opportunity(name)
        }
    }*/
}