// List<Lead> findLeads = [SELECT Name, LeadSource, Title
//                         FROM Lead
//                         WHERE LeadSource LIKE 'Web' OR
//                         Title LIKE '%'+ :title + '%'
//                         ];

String title = new List<String>{'Lead Chef', 'Chef Trainee'};
System.debug('results of title list: ' + title);

List<Lead> foundLeads = [SELECT Name, LeadSource, Title
                        FROM Lead
                        WHERE LeadSource IN ('Web')
                        OR Title LIKE :('%' + title + '%')
                        ];
                        
                        
System.debug('List of found Leads: ' + foundLeads);

/* 
This works
WHERE Title LIKE :title + '%'];
*/

//WHERE Title IN ('%' + :title + '%')];

List<Lead> ogLeads = [SELECT Name, LeadSource, Title
FROM Lead
WHERE LeadSource LIKE 'Web'
];
//OR Title LIKE '%' :title '%'
System.debug('List of found Leads: ' + ogLeads);


String keyword = 'Edge';
List <Opportunity> matchKeyword = [SELECT Id, Name, Account.Name
                FROM Opportunity
                WHERE Name
                LIKE :keyword + '%'
                ];
System.debug('keyword query results: ' + matchKeyword);

System.debug('results of getAllLeads: ' + SOQL.getAllLeads());

Contact testContact1 = new Contact(FirstName = 'John', LastName = 'Smith');
Contact testContact2 = new Contact(FirstName = 'Jane', LastName = 'Jones');
Contact testContact3 = new Contact(FirstName = 'Jack', LastName = 'Doe');
//ADD records to list
//contactList.addAll(testContact1, testContact2, testContact3);
List<Contact> contactList = new List<Contact>{testContact1, testContact2, testContact3};

System.debug('test contact list: ' + contactList);

List<Contact> queryContactList = [SELECT Id, LastName
FROM Contact
WHERE LastName LIKE 'James' AND 'Smith'];
System.debug('records returned: ' + queryContactList);

System.debug('Jene is getting it y\'all');

Task testTask1 = new Task(Subject = 'Test Task 1', ActivityDate = Date.today().addDays(7)); // due in 7 days
Task testTask2 = new Task(Subject = 'Test Task 2', ActivityDate = Date.today().addDays(10)); // due in 8 days, should not be returned
Task testTask3 = new Task(Subject = 'Test Task 3', ActivityDate = Date.today().addDays(2)); // due in 6 days
Task testTask4 = new Task(Subject = 'Test Task 4', ActivityDate = Date.today().addDays(14)); // due in 14 days, should not be returned
Task testTask5 = new Task(Subject = 'Test Task 5', ActivityDate = Date.today().addDays(-5)); // due in the past, should not be returned
insert new List<Task>{testTask1, testTask2, testTask3, testTask4, testTask5};

