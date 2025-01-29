/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Jené T. Fuller
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getAllLeads() {
    //  The body of the method
    List<Lead> grabLeads = [SELECT Id, LastName, Company, Phone, Email 
                            FROM Lead
                            ];
    return grabLeads;
    }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName() {
    //  The body of the method
    List<Contact> contactFirstName = [SELECT Id, FirstName, LastName, Name
                                        FROM Contact
                                        WHERE FirstName LIKE 'John'
                                    ];
    return contactFirstName;
    }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIdsByLastName() {
    //  The body of the method
        List<Contact> contactList = [SELECT Id, LastName
                                    FROM Contact
                                    WHERE LastName IN ('Jones', 'Smith')
                                    ];
        //new list to store Ids
        List<Id> contactIdsList = new List<Id>();

        // Loop through records, store matching IDs
        for (Contact contact : contactList){
            contactIdsList.add(contact.Id);
        }
        return contactIdsList;
    }

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getClosedWonOpportunityCountByAccount (String accountId) {
        //generate SOQL
        List<Opportunity> oppsWitMatcinghAccount = [SELECT Id, Name, AccountId, StageName, CloseDate, Amount
                                                    FROM Opportunity
                                                    WHERE StageName = 'Closed Won' AND AccountId = :accountId
                                                    ];
        return oppsWitMatcinghAccount;
    }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount() {
        //Using AggregateResult query to get count
        List<AggregateResult> arAccountTotal = [SELECT COUNT(Id) totCount 
                                                FROM Account];
        
        //Check for nulls, retreive count from AR query, or return 0
        If (!arAccountTotal.isEmpty()){
            Integer totCount = (Integer)arAccountTotal[0].get('totCount');
            return totCount;
        }else {
            return 0; //no records
        }        
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id,Task> getTasksDueNextWeek() {
    //  The body of the method       

        List<Task> upcomingTask = [SELECT Id, ActivityDate
                                    FROM Task
                                    WHERE ActivityDate = NEXT_N_DAYS:7
                                ];
        
        Map<Id,Task> dueNextWeek = new Map<Id,Task>(upcomingTask);
        
        return dueNextWeek;    
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain() {
    //  The body of the method
    List<Contact> specificContacts = [SELECT Id, Name, Email
                                        FROM Contact
                                        WHERE Email LIKE '%example.com'
                                    ];
    return specificContacts;
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        List<Opportunity> oppsByKeyword = [SELECT Id, Name
                                            FROM Opportunity
                                            WHERE Name LIKE :keyword +'%'
                                            ];
        return oppsByKeyword; 
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        List<Case> filtedCases = [SELECT Id, Origin
                                    FROM Case
                                    WHERE Origin
                                    NOT IN ('Web', 'Email', null)
                                ];
        return filtedCases;
    }


    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle (String leadSource, String keyword) {
        List<Lead> findLeads = [SELECT LeadSource, Title, LastName, Company, Email, Phone
                                FROM Lead
                                WHERE LeadSource LIKE :leadSource
                                OR Title LIKE :('%' + keyword +'%')                                        
                            ];
        return findLeads;        
    } 

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        // Create a list to hold the Contact LastNames
        List<String> contactLastNames = new List<String>();

        // Query the Contacts
        List<Contact> listOfContacts = [SELECT Id, LastName, accountId
                                        FROM Contact
                                        WHERE accountId = :accountId
                                    ];   

        // Loop through each Contact and add the LastName to the list
        for (Contact contact : listOfContacts) {
            contactLastNames.add(contact.LastName);
        }
        // Return the list of Contact LastNames
        return contactLastNames;
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for the found opportunities
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        // Use AggregateQuery to get the total revenue
        List<AggregateResult> arRevnueTotal = [SELECT SUM(Amount) totRevAmt
                                                FROM opportunity
                                                WHERE StageName = :stage
                                                OR Amount >= 10000
                                            ];
        //instatiate variable to store amount as decimal
        Decimal totRevAmt = (Decimal)arRevnueTotal[0].get('totRevAmt');

        // Return the total revenue
        return totRevAmt;
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        List<Account> accountFirst10List = [SELECT Id, Name
                                            FROM Account                                            
                                            ORDER BY Name DESC
                                            LIMIT 10
                                        ];
        return accountFirst10List;
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        List<Opportunity> first5OppList = [SELECT Id, Name, Amount, CloseDate
                                            FROM Opportunity
                                            WHERE Amount > 100000
                                            ORDER BY CloseDate ASC
                                            LIMIT 5
                                        ];
        System.debug('results of first5OppList: ' + first5OppList);                                        
        return first5OppList;
        
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        List<Contact> contactMostRecentDates = [SELECT Id, LastName, Birthdate
                                                FROM Contact
                                                ORDER BY Birthdate DESC
                                                LIMIT 3
                                                ];
        return contactMostRecentDates;
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        List<Case> caseOpenOffsetby5 = [SELECT Id, Status, CreatedDate
                                        FROM Case
                                        WHERE Status = 'Open'
                                        ORDER BY CreatedDate ASC
                                        LIMIT 10
                                        OFFSET 5
                                    ];
        return caseOpenOffsetby5; 
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        // Create a set to hold the Case Ids
        Set<Id> caseIdSet = new Set<Id>();

        // Query the Cases
        List<Case> listOfCases = [SELECT Id, Subject, Status
                                FROM Case
                                WHERE AccountId =: accountId
                            ];
        // Loop through each Case and add the Id to the set
        for (Case cs : listOfCases) {
            caseIdSet.add(cs.Id);
        }

        return caseIdSet;
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();

        // Query the Accounts
        List<Account> accountsNotInCountry = [SELECT Id, Name, BillingCountry
                                                FROM Account
                                                WHERE BillingCountry NOT IN (:country)];

        // Loop through each Account and add the Id and Name to the map
        for (Account acc : accountsNotInCountry){
            accountIdsToNames.put(acc.Id, acc.BillingCountry);
        }
        return accountIdsToNames;
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        List<Contact> contactList = [SELECT Id, Account.Name
                                        FROM Contact
                                        WHERE Id = :contactId
                                    ];

        //instatiate variable to store info as string, test for null w ternary sauce!!
        String accountName = contactList[0].Account != null ? contactList[0].Account.Name : null;       
        
        return accountName;
    }    

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
        List<Account> accWOpps = [SELECT Id, Name,
                                    (SELECT Id, Name, Account.Name
                                    FROM Opportunities)
                                FROM Account
                                WHERE Id = :accountId
                                ];
                                
        Account myAcc = accWOpps[0];

        return myAcc;
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {


        //trying to validate the CRUD permissions of current user
        String objectStr = 'Account';
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(objectStr);
        Schema.DescribeSObjectResult drSObj = convertType.getDescribe();
        System.debug('###### '+drSObj.isAccessible());

        // Query the Account
        list<Account> accList = [SELECT Id, Name, BillingState
                            FROM Account
                            WHERE Id = :accountId
                        ];
        System.debug(LoggingLevel.FINEST, 'results of accList: ' + accList);

        // Store the Account's BillingState
        Account accMatch = accList[0];

        // Query the Contacts
        List<Contact> conMatchList = [SELECT Id, Name, MailingState
                                FROM Contact
                                WHERE AccountId  = :accountId
                                AND MailingState = :accMatch.BillingState];
        System.debug('results of contact match list:: '+ conMatchList);

        return conMatchList;  //*** NOT SURE WHY the no of Contacts expected doesn't match */
    }
 
    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {        
        //variable to store Account list
        List<Account> acc = new List<Account>();

        // Query the Leads
        If (Schema.SObjectType.Lead.isAccessible() &&
            Schema.SObjectType.Lead.fields.Name.isAccessible() &&
            Schema.sObjectType.Lead.fields.Email.isAccessible()) {
            List<Lead> leadList = [SELECT Id, Name, Email
                                    FROM Lead
                                    WHERE Id IN :leadIds
                                ];

            // Create a set of email domains from the Leads
            Set<String> emailDoms = new Set<String>();

            // Loop through each Lead
            for (Lead lead : leadList){
                // Get the email from the Lead
                String email = lead.Email;
                
                // Check if the email is not null
                if(email != null && email.contains('@')){
                    // Add the email domain to the set
                    String dom = email.split('@')[1];
                    //changed case for consistency
                    emailDoms.add(dom.toLowerCase());
                }
            }
            
            // Query the Accounts
            if (Schema.SObjectType.Account.isAccessible() &&
                Schema.SObjectType.Account.fields.Name.isAccessible() &&
                Schema.SObjectType.Account.fields.Website.isAccessible()){
                acc = [SELECT Id, Name, Website
                                    FROM Account
                                    WHERE Website != null
                                    AND   Website 
                                    LIKE :('%' + String.join(new List<String>(emailDoms), '%') + '%')
                                ];
            }//**NOT SURE WHY validation check did not pass for the Account object**
        }
        return acc;
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        List<OpportunityLineItem> oppOrgLineItemList = new List<OpportunityLineItem>();
        

        // Query the original Opportunity Line Items
        If (Schema.SObjectType.OpportunityLineItem.isAccessible() &&
            Schema.SObjectType.OpportunityLineItem.fields.OpportunityId.isAccessible() &&
            Schema.SObjectType.Opportunity.fields.Pricebook2Id.isAccessible() &&
            Schema.SObjectType.OpportunityLineItem.fields.Product2Id.isAccessible() &&
            Schema.SObjectType.OpportunityLineItem.fields.Quantity.isAccessible() &&
            Schema.SObjectType.OpportunityLineItem.fields.UnitPrice.isAccessible()) {

            oppOrgLineItemList = [SELECT Id, OpportunityId, Product2Id, Opportunity.Pricebook2Id, Quantity, UnitPrice
                                        FROM OpportunityLineItem
                                        WHERE OpportunityId = :origOppId
                                        ];
        } //**NOT SURE WHY validation check did not pass for the OpportunityLineItem object**

        // Create a list to hold the new line items
        List<OpportunityLineItem> newLineItems = new List<OpportunityLineItem>();
        
        // Generate a random number between 1 and 3
        Integer randomNumber = Math.round(Math.random() * 2) + 1;

        // Loop through each cloned Opportunity Id
        for (Id cloneOppId : cloneOppIds){
            // Loop through each original line item
            for (OpportunityLineItem origLineItem : oppOrgLineItemList) {   

                // Clone the original line item and add the random number to the quantity
                OpportunityLineItem clonedItem = new OpportunityLineItem();
                //clonedItem.Pricebook2Id        = oppOrgLineItemList[0].Pricebook2Id;
                //clonedItem.Pricebook2Id        = origLineItem.Pricebook2Id;
                clonedItem.OpportunityId       = cloneOppId;
                clonedItem.Product2Id          = origLineItem.Product2Id;
                clonedItem.Quantity            = origLineItem.Quantity + randomNumber;
                clonedItem.UnitPrice           = origLineItem.UnitPrice;
                //add to list
                newLineItems.add(clonedItem);
            } 
        }
        // Insert the new line items
        if (!newLineItems.isEmpty()){
            if (Schema.SObjectType.OpportunityLineItem.isAccessible()) {
                insert newLineItems;
            } //**NOT SURE WHY validation check did not pass for the Account object**
        }
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {      
        List<Opportunity>oppClosedWonList = new List<Opportunity>();
        if(Schema.SObjectType.Opportunity.isAccessible() &&
            Schema.SObjectType.Opportunity.fields.Name.isAccessible() &&
            Schema.SObjectType.Opportunity.fields.StageName.isAccessible() &&
            Schema.SObjectType.Opportunity.fields.OwnerId.isAccessible() &&
            Schema.SObjectType.Account.fields.Name.isAccessible()){
            oppClosedWonList = [SELECT Id, Name, Account.Name, Owner.Name
                                                FROM Opportunity
                                                WHERE StageName = 'Closed Won'
                                            ];
            }//**NOT SURE WHY validation check did not pass for the Account object**
        return oppClosedWonList;
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List<Opportunity> closedWonOpps = getOpportunityDetailsForClosedWon();
        // Create a set of Account Ids from the Opportunities
        /*Set<Account> acctIdSet = [SELECT Id, 
                                    (SELECT Id
                                    FROM Opportunities
                                    WHERE Id = closedWonOpps.Id)
                                    FROM Account
                                    WHERE Id = :closedWonOpps
                                ];*/

        // Query the Contacts

        // Loop through each Contact and add the Account Id and Contact to the map
        
        // Loop through each Opportunity

                // Update the Opportunity primary contact from accountToContactMap

        // Update the Opportunities
    }
}