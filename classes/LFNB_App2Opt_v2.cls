public class LFNB_App2Opt_v2 {
    // use Controller
   
    //used for saving the value from the selected list selectList
    public String filterId {get; set;}  
        public PageReference goToPotentialMatchPage(){
       return Page.LFNB_CaseOppPageCusCtrlV43;
    }
    public PageReference goToNoMatchPage(){
       return Page.LFNB_CaseOppPageCusCtrlV45;
    }
    public LFNB_F1_Case__c app {get; set;}
    
    // List of Apps with no matchings. 
    // The wrapper list is used for selecting multiple apps
    public List<LFNBF1CaseSelectedWrapper> apps {get;set;}
     // the Applications that were checked/selected.
	public List<LFNB_F1_Case__c> selectedApps{
        get {
            if (selectedApps == null)
                selectedApps = new List<LFNB_F1_Case__c>();
             return selectedApps;
        }
        set;
    }
    
    // do not init the results or a blank rows show up initially on page load
    // the results from the search. 
    public List<LFNBOpprtunityListWrapper> searchOpts {get;set;}
    // the Opportunities that were checked/selected.
    public List<Opportunity> selectedOpts{
        get {
            if (selectedOpts == null)
                selectedOpts = new List<Opportunity>();
             return selectedOpts;
        }
        set;
    }
    
    // fired when the search button is clicked
    public PageReference search(){
        if (searchOpts == null){
            searchOpts = new List<LFNBOpprtunityListWrapper>();
        }else{
            searchOpts.clear(); //clear out the current results
        }
        // get the Case id 
        String id = ApexPages.currentPage().getParameters().get('cid');
        if(id != null){
            List<Opportunity> opts = [select id, name, closedate, stagename from Opportunity limit 3];
            for(Opportunity opt : opts){
                // create new wrapper
                LFNBOpprtunityListWrapper ow = new LFNBOpprtunityListWrapper(new OpportunityWrapper(opt));
                // add wrapper to the results
                searchOpts.add(ow);
            }
        }
        return null;
    }
    
    // fired when the No Matches option is selected
    public PageReference unmatchedApp(){
        System.debug(filterId);
        if(filterId == 'WithMatches'){
            return Page.LFNB_CaseOppPageCusCtrlV43;
        }else{
            List<LFNB_F1_Case__c> unmatchedApps;
            if (apps == null){
                unmatchedApps = [SELECT id, name,  LFNB_Opportunity_Name__c, LFNB_Opportunity_ID__c, LFNB_Matching_Rating__c 
                                            FROM LFNB_F1_Case__c 
                                        WHERE LFNB_Matching_Rating__c = 0 limit 10];
            }else{
                apps.clear(); //clear out the current results
            }
            if(unmatchedApps != null  && unmatchedApps.size() > 0){
                apps = new List<LFNBF1CaseSelectedWrapper>(unmatchedApps.size());
                for(LFNB_F1_Case__c app : unmatchedApps){
                    // create new wrapper
                    LFNBF1CaseSelectedWrapper aw = new LFNBF1CaseSelectedWrapper(app);
                    // add wrapper to the results
                    apps.add(aw);
                }
            }
        }
        return Page.LFNB_CaseOppPageCusCtrlV45;
    }
    public PageReference next(){
        // clear out the currently selected opportunities
        selectedOpts.clear();
        
        // add the slected opportunities to a new list
        for(LFNBOpprtunityListWrapper ow: searchOpts){
            
            //if (ow.selected)
               // selectedOpts.add(ow.opp);  we may not need to have a wrapper around Opp
        }
        // ensure they selected at least one opportunity or show an error message.
        if(selectedOpts.size() > 0){
            // merge
            return null;
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select one or more Opportunities.'));
            search();
            return null;
        }
    }
    
    public LFNB_F1_Case__c getAppTest(){
        if (app == null)
    		app = [select id, name, LFNB_Opportunity_Name__c, LFNB_Opportunity_ID__c, LFNB_Matching_Rating__c
                     from LFNB_F1_Case__c 
                     where id =:ApexPages.currentPage().getParameters().get('id')]; 
       	return app; 
    }
    
    public List<LFNB_F1_Case__c> getAppsTest(){  
        return [select id, name,  LFNB_Opportunity_Name__c, LFNB_Opportunity_ID__c, LFNB_Matching_Rating__c 
                	from LFNB_F1_Case__c limit 10];
    }

    
    public PageReference createNewOpt(){
        LFNB_F1_Case__c app;
        app = [select id, name, LFNB_Opportunity_Name__c, LFNB_Opportunity_ID__c 
               from LFNB_F1_Case__c 
               	where id =: 'a0kJ00000021HUu'];
        If(app != null){
            Opportunity opt = LFNB_OpportunityHelper.createOpt(app);
	        app.LFNB_Opportunity_ID__c = opt.Id;
            update app;
        }else{
            System.debug('No Case-App available with id:' + ApexPages.currentPage().getParameters().get('cid'));
        }
        
        return null;
    }
    
    private User findRegionalDirector(String email){
        return [Select name, email, ID from User WHERE email =: email LIMIT 1];
    }
    
    private List<Contact> findContacts(){

        return [SELECT name, email, ID from Contact];
        /*List<List<Contact>> contacts = [FIND :'Julie Teo' in Name Fields 
            				RETURNING Contact(name, email WHERE Contact.Account.name LIKE :'AON%' LIMIT :2)];
    	*/
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