public with sharing class LFNB_App2Opt_v4 {
    // class used for pagination
    
    public String filterId {get; set;}  //used for selectList
    /*
    *   set controller
    */
    private ApexPages.StandardSetController setCon;
 
    /*
    *   the contact ids selected by the user
    */
    private Set<Id> selectedF1RecordIds;
 
    /*
    *   constructor
    */
    public LFNB_App2Opt_v4(){
        //init variable
        this.selectedF1RecordIds= new Set<Id>();
 
        //gather data set
        this.setCon= new ApexPages.StandardSetController( [select id, name, LFNB_Opportunity_Name__c, 
                                                           LFNB_Opportunity_ID__c, LFNB_Matching_Rating__c
                     									   from LFNB_F1_Case__c order by LFNB_Matching_Rating__c DESC]);
        this.setCon.setpageNumber(1);
        this.setCon.setPageSize(5);
    }
    
    /*
    *   advance to next page
    */
    public void doNext(){
        if(this.setCon.getHasNext())
            this.setCon.next();
    }
 
    /*
    *   advance to previous page
    */
    public void doPrevious(){
        if(this.setCon.getHasPrevious())
            this.setCon.previous(); 
    }
    
    /*
    *   return current page of groups
    */
    public List<LFNB_F1_Case__c> getF1Records(){
 
        List<LFNB_F1_Case__c> rows = new List<LFNB_F1_Case__c>();
 
        /*for(sObject r : this.setCon.getRecords()){
            Contact c = (Contact)r;
 
            CCWRowItem row = new CCWRowItem(c,false);
            if(this.selectedContactIds.contains(c.Id)){
                row.IsSelected=true;
            }
            else{
                row.IsSelected=false;
            }
            rows.add(row);
        }*/
        return this.setCon.getRecords();
    }
 
    /*
    *   return whether previous page exists
    */
    public Boolean getHasPrevious(){
       return this.setCon.getHasPrevious();
    }
 
    /*
    *   return whether next page exists
    */
    public Boolean getHasNext(){
        return this.setCon.getHasNext();
    }
 
    /*
    *   return page number
    */
    public Integer getPageNumber(){
 
        return this.setCon.getPageNumber();
 
    }
 
    /*
    *    return total pages
    */
    Public Integer getTotalPages(){
 
        Decimal totalSize = this.setCon.getResultSize();
        Decimal pageSize = this.setCon.getPageSize();
 
        Decimal pages = totalSize/pageSize;
 
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
 
}