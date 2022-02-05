public class CopyFieldPermissions
  {
    
    public static void createFieldPermissions(String profileName,String permSetLabel)
    {
        PermissionSet permSet = [SELECT Id,Name,Profile.Id FROM PermissionSet WHERE Profile.Name=:profileName];

		List<FieldPermissions> fieldPerms =
    		[SELECT SobjectType,ParentId, Field, PermissionsEdit,PermissionsRead 
  			FROM FieldPermissions WHERE ParentId=:permSet.Id];

			System.debug(permSet.Id + '  '+fieldPerms[0].ParentId);
		
        	Database.SaveResult[] insertResultList;
        
			PermissionSet ps = [SELECT Id,Name,Label FROM PermissionSet WHERE Label=:permSetLabel];
		
			List<FieldPermissions> testPerms = new List<FieldPermissions>();
        try{
            for(Integer i=0; i< fieldPerms.size();i++)
			{
    			FieldPermissions fp =fieldPerms[i].clone();
    			fp.ParentId = ps.Id;
    			testPerms.add(fp);
			}

        	System.debug('Field Permission Count : '+testPerms.size());
			insertResultList = Database.insert(testPerms,false);
           System.debug('Field Permission Count after insert : '+insertResultList.size());

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
        		// Operation was successful, so get the ID of the record that was processed
        		//System.debug('Successfully inserted field permission ' + sr.getId());
    			}
    			else {
        				// Operation failed, so get all errors                
        			for(Database.Error err : sr.getErrors()) {
            				//System.debug('The following error has occurred.');                    
            				System.debug(err.getMessage());
        				}
    				}
            }
			
			

    }
}
