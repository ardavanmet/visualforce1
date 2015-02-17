public with Sharing class LFNB_App2Opt_vCaseNoMatchV2 {

    public PageReference goToPotentialMatchPage(){
       return Page.LFNB_CaseOppPageCusCtrlV43;
    }
    public PageReference goToNoMatchPage(){
       return Page.LFNB_CaseOppPageCusCtrlV45;
    }
    // set controller
    private ApexPages.StandardSetController setCon;
    
    // List of Apps with no matchings. 
    // The wrapper list is used for selecting multiple apps
    public List<LFNBF1CaseSelectedWrapper> apps {
        get{
			if (apps == null){
                List<LFNB_F1_Case__c> unmatchedApps = this.setCon.getRecords();
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
            return apps;
        }     
     	set;
     }

    // constructor
    public LFNB_App2Opt_vCaseNoMatchV2(){
        //gather data set
        this.setCon= new ApexPages.StandardSetController( [SELECT id, name,  LFNB_Opportunity_Name__c, LFNB_Opportunity_ID__c, LFNB_Matching_Rating__c 
                                                       	   FROM LFNB_F1_Case__c 
                                                           WHERE LFNB_Matching_Rating__c = 0]);
        this.setCon.setpageNumber(1);
        this.setCon.setPageSize(5);
    }
    
    // the Applications that were checked/selected.
	public List<LFNB_F1_Case__c> selectedApps{
        get {
            if (selectedApps == null)
                selectedApps = new List<LFNB_F1_Case__c>();
             return selectedApps;
        }
        set;
    }
    public PageReference createOps(){
        // clear out the currently selected opportunities
        selectedApps.clear();
        
        // add the selected apps to a new list
        for(LFNBF1CaseSelectedWrapper aw: apps){
            
            //if (ow.selected)
               // selectedApps.add(aw.app);  we may not need to have a wrapper around Opp
        }
        // ensure they selected at least one opportunity or show an error message.
        if(selectedApps.size() > 0){
            // LFNB_OpportunityHelper.createOpts();
            return null;
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select one or more Opportunities.'));
            return null;
        }
    }
   
    /* PAGINATION HELPERS */
     //  advance to next page
    public void doNext(){
        if(this.setCon.getHasNext())
            this.setCon.next();
    }
    // advance to previous page
    public void doPrevious(){
        if(this.setCon.getHasPrevious())
            this.setCon.previous(); 
    }
     // return whether previous page exists
    public Boolean getHasPrevious(){
       return this.setCon.getHasPrevious();
    }
    // return whether next page exists
    public Boolean getHasNext(){
        return this.setCon.getHasNext();
    }
    // return page number
    public Integer getPageNumber(){
 
        return this.setCon.getPageNumber();
 
    }
    // return total pages
    Public Integer getTotalPages(){
 
        Decimal totalSize = this.setCon.getResultSize();
        Decimal pageSize = this.setCon.getPageSize();
 
        Decimal pages = totalSize/pageSize;
 
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
}