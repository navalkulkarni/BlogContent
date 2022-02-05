public class CopyApexClasses
  {
    // if you want to copy apex classes from existing profile use this menthod
     public static void giveApexClassAccess(String profileName,String permSetLabel)
    {
        PermissionSet permSet = [SELECT Id,Name,Profile.Id FROM PermissionSet WHERE Profile.Name= : profileName];
		List<SetupEntityAccess> apexclassList =[SELECT SetupEntityId FROM SetupEntityAccess WHERE ParentId =:permset.Id  AND SetupEntityType = 'ApexClass' LIMIT 100];
		
		PermissionSet ps = [SELECT Id,Name FROM PermissionSet WHERE Label= : permSetLabel];
		Database.SaveResult[] insertResultList;
		List<SetupEntityAccess> testPerms = new List<SetupEntityAccess>();
		try{
    		for(Integer i= 0; i<apexClassList.size();i++)
			{
    			SetupEntityAccess sea = apexClassList[i].clone();
				sea.ParentId = ps.Id;
				testPerms.add(sea);
			}
			insertResultList = Database.insert(testPerms,false);
		}catch(DMLException e)
			{
    			for(Integer i= 0;i< e.getNumDml();i++)
    			{	System.debug(e.getDmlMessage(i));
     				
    			}
			}catch(Exception e)
			{
   				 System.debug(e.getMessage());
			}
        
        // Iterate through each returned result
			for (Database.SaveResult sr : insertResultList) {
    			if (sr.isSuccess()) {
        		
        		//System.debug('Successfully inserted object permission ' + sr.getId());
    			}
    			else {
        				   
        			for(Database.Error err : sr.getErrors()) {
            				
            				System.debug(err.getMessage());
        				}
    				}
            }
    }// method ends here
    
    // if you have a list of apex classes ready with you use this method
    public static void partWiseClassAccess(List<String> profileName,String permSetLabel,List<String> inputList)
    {
        List<PermissionSet> permSet = [SELECT Id,Name,Profile.Id FROM PermissionSet WHERE Profile.Name IN: profileName];
		List<ApexClass> apexClassList = [SELECT Id,Name FROM ApexClass WHERE NAME IN: inputList];
        List<SetupEntityAccess> finalList2 = new List<SetupEntityAccess>();
        List<SetupEntityAccess> tempList = new List<SetupEntityAccess>();
        for(PermissionSet per : permSet)
        {
            tempList =[SELECT SetupEntityId FROM SetupEntityAccess WHERE ParentId =: per.Id  AND SetupEntityType = 'ApexClass' AND SetupEntityId IN: apexClassList];
        	for(SetupEntityAccess se : tempList)
            {
                finalList2.add(se);
            }
            tempList.clear();
        }
         System.debug(finalList2.size());
		
		PermissionSet ps = [SELECT Id,Name FROM PermissionSet WHERE Label= : permSetLabel];
		Database.SaveResult[] insertResultList;
		List<SetupEntityAccess> testPerms = new List<SetupEntityAccess>();
		try{
    		for(Integer i= 0; i<finalList2.size();i++)
			{
    			SetupEntityAccess sea = finalList2[i].clone();
				sea.ParentId = ps.Id;
				testPerms.add(sea);
			}
			insertResultList = Database.insert(testPerms,false);
		}catch(DMLException e)
			{
    			for(Integer i= 0;i< e.getNumDml();i++)
    			{	System.debug(e.getDmlMessage(i));
     				
    			}
			}catch(Exception e)
			{
   				 System.debug(e.getMessage());
			}
        
        // Iterate through each returned result
			for (Database.SaveResult sr : insertResultList) {
    			if (sr.isSuccess()) {
        		
        		//System.debug('Successfully inserted object permission ' + sr.getId());
    			}
    			else {
        				   
        			for(Database.Error err : sr.getErrors()) {
            				
            				System.debug(err.getMessage());
        				}
    				}
            }
      }// method ends here
    
}
