public class CopyVFPages
  {
    
    // if you want to copy apex classes from existing profile use this menthod
    public static void givePageAccess(String profileName,String permSetLabel)
    {
        PermissionSet permSet = [SELECT Id,Name,Profile.Id FROM PermissionSet WHERE Profile.Name= : profileName];
		List<SetupEntityAccess> visualForceList =[SELECT SetupEntityId FROM SetupEntityAccess WHERE ParentId =:permset.Id  AND SetupEntityType = 'ApexPage'];
		
		PermissionSet ps = [SELECT Id,Name FROM PermissionSet WHERE Label= : permSetLabel];
		Database.SaveResult[] insertResultList;
		List<SetupEntityAccess> testPerms = new List<SetupEntityAccess>();
		try{
    		for(Integer i= 0; i<visualForceList.size();i++)
			{
    			SetupEntityAccess sea = visualForceList[i].clone();
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
    }
    
    // if you have a list of vf pages ready with you use this method
    public static void partWisePageAccess(List<String> profileName,String permSetLabel,List<String> inputList)
    {
        List<PermissionSet> permSet = [SELECT Id,Name,Profile.Id FROM PermissionSet WHERE Profile.Name IN: profileName];
		List<ApexPage> visualForceList = [SELECT Id,Name FROM ApexPage WHERE NAME IN: inputList];
        List<SetupEntityAccess> finalList2 = new List<SetupEntityAccess>();
        List<SetupEntityAccess> tempList = new List<SetupEntityAccess>();
        for(PermissionSet per : permSet)
        {
            tempList =[SELECT SetupEntityId FROM SetupEntityAccess WHERE ParentId =: per.Id  AND SetupEntityType = 'ApexPage' AND SetupEntityId IN: visualForceList];
        	for(SetupEntityAccess se : tempList)
            {
                finalList2.add(se);
            }
            tempList.clear();
        }
         //System.debug(finalList2);
		
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

    }
    
  }
