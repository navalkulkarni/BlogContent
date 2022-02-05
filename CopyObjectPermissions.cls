public class CopyObjectPermissions
  {
    
    public static void createPermissions(String inputProfile,String inputPermSet)
    {
        // Query PermissionSet in relation to your Profile
        PermissionSet permSet = [Select Id,Name,Profile.Id 
                                 FROM PermissionSet WHERE Profile.Name=: inputProfile];
		
        Database.SaveResult[] insertResultList;
		
        //check count to verify it later 
        Integer countPerm = [Select Count() 
                             FROM ObjectPermissions WHERE ParentId=:permSet.Id];
        System.debug(countPerm);
        
        //query object permissions related to permission set 
		List<ObjectPermissions> objPerms = 
    	[SELECT Id,ParentId,SobjectType,PermissionsCreate,PermissionsRead,PermissionsEdit,PermissionsDelete,
         PermissionsViewAllRecords,PermissionsModifyAllRecords FROM ObjectPermissions WHERE ParentId=:permSet.Id];

        // query for new permission set where you want to copy all profile details
        PermissionSet ps = [SELECT Id,Name FROM PermissionSet WHERE Label=: inputPermSet];

		System.debug(ps.Id + ps.Name);
		
		List<ObjectPermissions> testPerms = new List<ObjectPermissions>();
		
        //Change Parent id field of all object permissions to point to the newly created permission set
        //and store them in a new list so that we want to keep existing profile intact
        try{
    		for(Integer i= 0; i<objPerms.size();i++)
			{
    			ObjectPermissions op = objPerms[i].clone();
				//change parent id to new permission set id
				op.SobjectType = 'Account';
                op.ParentId = ps.Id;
				testPerms.add(op);
			}
            //use Database.insert with allOrNone parameter as false so that 
            //objects which dont throw an error get inserted
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
        		// Operation was successful, so get the ID of the record that was processed
        		System.debug('Successfully inserted account. Account ID: ' + sr.getId());
    			}
    			else {
        				// Operation failed, so get all errors                
        			for(Database.Error err : sr.getErrors()) {
            				System.debug('The following error has occurred.');                    
            				System.debug(err.getMessage());
        				}
    				}
            }
				
    }
 }
