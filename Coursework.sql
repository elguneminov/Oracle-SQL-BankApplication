/*

****
Question A (3 Marks)
Find employees whose first name includes the string “on” and live in 
Edinburgh, displaying their full names.
****

*/

SELECT  e.name.title || '. ' || 
	e.name.firstName || ' ' || 
	e.name.surname || ' is living in ' || 
	e.address.city
AS 	"First name contains 'on'"
FROM 	employee_table e 
WHERE 	INSTR(e.name.firstname,'on')>0
AND 	e.address.city = 'Edinburgh';


/*

****
Question B (3 Marks)
Find the number of saving accounts at each branch, displaying the
number and branch’s address.
****

*/

SELECT    
    a.branch_id.branch_id AS "Branch ID",
    a.branch_id.city AS "City of branch",
    count(a.acc_type) AS "Number of savings accounts"
FROM 
    account_table a
WHERE
    acc_type = 'Savings'
GROUP BY
    a.acc_type, a.branch_id.city,  a.branch_id.branch_id
ORDER BY 
    a.branch_id.branch_id ASC; 

/*

****
Question C (3 Marks)
At each branch, find customers who have the highest balance in their
savings account, displaying their names, the balance, the branch ID
and the free overdraft limit in their current accounts.
****

*/ 

SELECT 
        c.account_number.branch_id.branch_id AS branch_ID, 
        c.cust_id.cust_id AS cust_ID,
        c.cust_id.print_name() AS full_name,
        c.account_number.account_number AS accnum_of_savings, 
        c.account_number.balance AS balance_of_savings       
    FROM ( 
        SELECT 
            c.account_number.branch_id.branch_id AS branch_id, 
            c.account_number.acc_type AS acc_type, 
            MAX (c.account_number.balance) AS max_balance
            FROM 
                customer_account c
            WHERE 
                c.account_number.acc_type = 'Savings' 
            GROUP BY c.account_number.branch_id.branch_id, c.account_number.acc_type
        ) balance
    JOIN customer_account c 
    ON 
        c.account_number.branch_id.branch_id = balance.branch_id
    AND 
        c.account_number.acc_type = balance.acc_type 
    AND 
        c.account_number.balance = balance.max_balance
    LEFT JOIN customer_account t2
    ON t2.cust_id.cust_id = c.cust_id.cust_ID
    AND t2.account_number.acc_type = 'Basic';
    
/*

****
Question D (3 Marks)
Find employees who are supervised by a manager and have accounts in
the bank, displaying the branch address that the employee works in and
the branch address that the account is opened with.
****

*/

SELECT     
    'Emp ID: ' || e.emp_id || ',  ' ||
    e.print_name()   AS employee, 
    c.account_number.account_number AS "Account Number",
    e.supervisor_id.print_name() AS "Supervisor",
    e.supervisor_id.position.job_title AS "Supervisor Job Title" 
FROM 
    employee_table e, customer_account c
WHERE 
    c.cust_id.name.firstname = e.name.firstname
AND 
    c.cust_id.name.surname = e.name.surname
AND 
    e.supervisor_id.position.job_title = 'Manager'
ORDER BY 
    e.emp_id ASC; 

/*

****
Question E (5 marks)
At each branch, find customers who have the highest free overdraft
limit in all current accounts that are joint accounts, displaying the
branch’s ID, the customer’s full names, the free overdraft limit in
his/her current account.
****

*/  

SELECT 
    c.account_number.branch_id.branch_id AS branch_id, 
    c.cust_id.print_name() AS full_name, 
    c.account_number.limit_of_free_OD AS free_od
    FROM ( 
        SELECT c.account_number.branch_id.branch_id AS branch_id, 
            MAX(c.account_number.limit_of_free_OD) AS maxOD
            FROM customer_account c 
            GROUP BY c.account_number.branch_id.branch_id
        ) maxOD, customer_account c
        WHERE c.account_number.limit_of_free_OD = maxOD.maxOD AND
         c.account_number.branch_id.branch_id = maxOD.branch_id
         ORDER BY c.account_number.branch_id.branch_id ASC;

/*

****
Question F (5 marks)
Find customers who have more than one mobile, and at least one of the
numbers starts with 0770, displaying the customer’s full name and
mobile numbers. COLLECTIONS must be used
****

*/  

SELECT  
    c.cust_id,
    c.print_name(),
    t.phone_value
FROM 
    (SELECT c.cust_id AS cust_id, count(t.phone_version) AS mob_count, phone_version AS phone_version
    FROM customer_table c, table(c.phone) t 
    WHERE t.phone_version = 'Mobile'     
    AND t.phone_value LIKE '07%'
    GROUP BY c.cust_id, phone_version) phone_nums, customer_table c, table(c.phone) t
WHERE c.cust_id = phone_nums.cust_id
AND t.phone_version = phone_nums.phone_version
AND t.phone_version = 'Mobile'
AND phone_nums.mob_count > 1
ORDER BY c.cust_id;


/*

****
Question G (5 marks)
Find the number of employees who are supervised by Mrs Smith, who
is supervised by Mr Jones. REFERENCES must be used. 
****



*/  
--Select from where superivsor I'd = select from employment where first name = and surname = and superivsorid = select from employment first name and surname

SELECT 
    COUNT(e.print_name()) as number_of_employees, 
    e.supervisor_id.print_name() AS supervisor_of_employees, 
    (SELECT e.supervisor_id.print_name() FROM employee_table e WHERE e.supervisor_id.name.Surname = 'Jones') AS supervisor_of_Mrs_Smith
    FROM employee_table e
    WHERE
        e.supervisor_id.name.firstname = 'Jourdan' AND
        e.supervisor_id.name.surname = 'Smith'
        AND e.supervisor_id.emp_id = (
            select e.emp_id FROM employee_table e
            WHERE 
                e.supervisor_id.name.surname = 'Jones')
    GROUP BY e.supervisor_id.print_name() ;
/*

****
Question H (8 marks)
Award employees at the end of a year: gold medals for employees who
have been working at the bank for more than 12 years and supervised
more than 6 staff; silver medals for employees who have been working
at the bank for more than 8 years and supervised more than 3 staff;
bronze medals for employees who have been working at the bank for
more than 4 years, displaying their names and Medal awarded (only
displaying those who have been awarded). METHODS must be used.
****

*/  

SELECT 
    e.emp_id AS "Employee ID" , 
    e.print_name() AS "Employee Full Name" ,
    e.years_at_company() AS "Years at Company",
    e.count_supervised() || ' people' AS "Supervises", 
    e.awardStar() AS "Awarded Medal"
FROM 
    employee_table e 
WHERE
    e.awardStar() != 'No Medal Awarded';
