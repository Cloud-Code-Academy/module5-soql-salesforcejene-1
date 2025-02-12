/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Jené T. Fuller
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account account = new Account(Name = 'Account ' + math.random());

        String accountBillingCity ='New York';
        Integer accountNumberOfEmployees = 100;

        // Set some fields on the Account
        account.BillingCity = accountBillingCity;
        account.NumberOfEmployees = accountNumberOfEmployees;
        // Insert the Account into the database
        insert account;
        // Return the Id of the newly created Account
        return account.Id;
    }

    /**
     * Question 2 
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account acc = new Account(Name = name, Industry = industry);
        // Insert the Account
        insert acc;
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        String contactLastName = 'Fuller';
        // Create a new Contact instance
        Contact contact = new Contact(LastName = contactLastName, accountId = accountId);
        // Set some fields on the Contact
        
        // Set the AccountId field to the given accountId

        // Insert the Contact into the database
        insert contact;
        // Return the Id of the newly created Contact
        return contact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        Contact contactToUpdate = [SELECT Id FROM Contact WHERE Id = :contactId LIMIT 1];

        // Update the Contact's last name
        contactToUpdate.LastName = newLastName;
        // Update the Contact in the database
        update contactToUpdate;
    }   

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        Opportunity updateOpp = [SELECT Id, StageName FROM Opportunity WHERE Id = :oppId];

        // Update the Opportunity's stage
        updateOpp.stageName = newStage;
        
        // Update the Opportunity in the database
        update updateOpp;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        Account acc = [SELECT Id, Name, Industry FROM Account WHERE Id = :accountId];

        // Update the Account with the given Id with the new name and industry
        acc.Id          = accountId;
        acc.Name        = newName;
        acc.Industry    = newIndustry;
        update acc;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Loop through each Opportunity in the list
        for (Opportunity opp : opportunities) {
            opp.stageName = 'Qualification'; // Set the Opportunity's Stage to Qualification            
            opp.closeDate = Date.today().addMonths(3); // Set the Opportunity's Close Date to 3 months from today
            opp.amount    = 50000; // Set the Opportunity's Amount to 50000
            System.debug(LoggingLevel.FINEST, 'Opportunity Name' + opp.Name);
        }
        // Upsert the opportunities List so that records are either updated or created
        upsert opportunities;
    }

    /**
     * Question 8
     * Insert or update opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * HINT: There should not be duplicate opportunites based on the name
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        //Instantiate new account
        Account matchedAccount;

        //*Query Account to find a matching accountName; using a list in order to check for records.    
        List <Account> accountToInsert = [SELECT Id, Name FROM Account WHERE Name = :accountName LIMIT 1];
        
        if (accountToInsert.isEmpty()){
            //insert new account if no match is found
            matchedAccount = new Account(Name = accountName);
            insert matchedAccount;
        }  else { 
            matchedAccount = accountToInsert[0]; //Use the first record
        }

        //Query existing Opps that match the above Account
        List <Opportunity> existingOppsList = [ SELECT Id, Name
                                                FROM Opportunity 
                                                WHERE AccountId = :matchedAccount.Id];
                                                    
       //Using a set, store existing opps that are related to the matched account
        Set <String> existingOppsNames = new Set<String>();
        for (Opportunity opp : existingOppsList){
            existingOppsNames.add(opp.Name);
        }
        
        //Prepare a list of new Opps to be upserted
        List<Opportunity> listOfOppsToBeUpserted = new List<Opportunity>();


        // Loop through each Opportunity name           
        for (String opp : oppNames) {
            //add to listToBeUpserted only if opp name is not already in the existingOppsList
            if(!existingOppsNames.contains(opp)) {
                Opportunity oppsToAdd = new Opportunity(
                    Name = opp,
                    StageName = 'Prospecting',
                    Amount = 70000,
                    CloseDate = date.today().addMonths(2),
                    AccountId = matchedAccount.Id
                );
                // Add the Opportunity to the list
                listOfOppsToBeUpserted.add(oppsToAdd);
            }
        }
        
        // Create an Opportunity with the given name, if the list is not empty
        if (!listOfOppsToBeUpserted.isEmpty()){
            upsert listOfOppsToBeUpserted;
        }       
    }

    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
        List<Account> accounts = [SELECT Id, Name
                                    FROM Account 
                                    WHERE Name = :accountName
                                ];
        //instantiate a new account variable
        Account newAcc;
        // if the Account exists, update the description
        if (!accounts.isEmpty()){
            newAcc = accounts[0];
            newAcc.Description = 'Updated Account';
        } else {
            // otherwise, if the acct does not exist, generate a new Account and set the description
            newAcc = new Account(Name = accountName);
            newAcc.Description = 'New Account';
        }
        accounts.add(newAcc);
        // Upsert the Account
        upsert newAcc;
        return newAcc;
	}

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		// Loop through each Contact        
		// Extract the Account Name from Contact's LastName
        if (!contactsToUpsert.isEmpty()){
            for (Contact contact : contactsToUpsert){
                String accountName = contact.LastName;
                // 3 - Get the account based on the name or create one if it doesn't exist
                Account account = upsertAccount(accountName);
                // 4 - Link the Contact to its Account using the Account Id
                contact.AccountId = account.Id;
            }    
        }    
        // 5 - Upsert the Contacts
        upsert contactsToUpsert;
	}

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        List<Lead> listOfLeads = new List<Lead>();

        // Loop through each Lead name        
        for (String l : leadNames){
            Lead addLeads = new Lead(LastName = 'Last Name ' + leadNames, Company='Company ' + leadNames);
            listOfLeads.add(addLeads);
        }
        
        // Insert the Leads
        if (!leadNames.isEmpty()){
        insert listOfLeads;
        }         
        // Delete the Leads
        if (!leadNames.isEmpty()){
            delete listOfLeads;
        }
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        //generate list to store cases
        list<Case> storeCase = new List<Case>();

        for (Integer i = 0; i < numOfCases; i++){
            Case caseToAdd = new Case();
            storeCase.add(caseToAdd);
            caseToAdd.AccountId = accountId;
        }        
        // Insert the cases
        if (numOfCases > 0){
            insert storeCase;
        }
        
        // Delete the cases
        if (numOfCases > 0){
            delete storeCase;
        }
    }
}