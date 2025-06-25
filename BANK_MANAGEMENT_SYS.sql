create database bank;
use bank;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    dob DATE,
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10)
);

CREATE TABLE Branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    contact_number VARCHAR(20)
);

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    branch_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    position VARCHAR(50),
    hire_date DATE,
    salary DECIMAL(10, 2),
    email VARCHAR(100),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    branch_id INT,
    account_type VARCHAR(30),
    balance DECIMAL(15, 2),
    opened_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);


CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_type VARCHAR(10),
    amount DECIMAL(12, 2),
    transaction_date DATE,
    remarks TEXT,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

CREATE TABLE Loans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    loan_type VARCHAR(30),
    amount DECIMAL(15, 2),
    interest_rate DECIMAL(5, 2),
    loan_term_years INT,
    issue_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

select *from customers;
select* from branches;
select* from accounts;
select* from employees;
select* from loans;
select* from transactions;

-------- BASIC QUERIES 
--------- Get tha first 10 customers ----------
select * from customers limit 10;

-------- Find all active accounts ----------
select *from accounts
where status = 'Active';

-------- Show all transactions of type 'CREDIT' ---------
select * from transactions
where transaction_type = 'Credit';

-------- Count the number of branches -------
select count(*) as total_branches from branches;

-------- List all employees hired by after 2020 ------
select *from employees
where hire_date > '2020-01-01';

-------- Display all loans greater than 10 laks ----
select * from loans
where amount > 1000000;

---------- INTERMEDIATE QUERIES 
--------- List customers names with their account balance -------
select customers.first_name, customers.last_name , accounts.balance
from customers join accounts
on customers.customer_id = accounts.customer_id;

----------  Find the total number of transactions for each account ----
SELECT account_id, COUNT(*) AS total_transactions
FROM Transactions
GROUP BY account_id;

---------  Show total loan amount by loan type -------
select loan_type, round(sum(amount),2) as toatal_loan_amount from loans
group by loan_type;

--------- Display average balance by account type ------
select account_type, round(avg(balance),2) from accounts
group by account_type;

--------- Find accounts opened in the last 1 year ------
select * from accounts
where opened_date >= curdate() -- interval 1 year;

--------- Find employees working at the 'Central' branch ----
select employees.first_name , employees.last_name,branches.branch_name
from employees join branches
on employees.branch_id = branches.branch_id
where branches.branch_name = 'Central';

----------- Advanced SQL Queries 
---------- Find top 5 customers with the highest account balances ------
select customers.customer_id, customers.first_name, customers.last_name, accounts.balance as balance
from customers join accounts
on customers.customer_id = accounts.customer_id
order by balance desc
limit 5;

--------- List customers who have both an account and a loan -------
select customers.customer_id, customers.first_name, customers.last_name,
accounts.balance as account_blc, loans.amount as loan_amount
from customers join accounts
on customers.customer_id = accounts.customer_id
join loans
on loans.customer_id = accounts.customer_id;

-------- Find total deposits (credits) per branch -------
select branches.branch_name, round(sum(transactions.amount),2) as total_credits
from transactions join accounts
on transactions.account_id = accounts.account_id
join branches
on branches.branch_id = accounts.branch_id
where transactions.transaction_type = "Credit"
group by branches.branch_name;

-------- Get monthly transaction count and amount in 2024 ------
select month(transaction_date) as month,
count(*) as total_transactions,
round(sum(amount)) as total_amount
from transactions
where year(transaction_date) = 2024
group by month
order by month; 

-------- List customers with no transactions ------
select customers.customer_id, customers.first_name,customers.last_name
from customers join accounts
on customers.customer_id = accounts.customer_id
join transactions
on transactions.account_id = accounts.account_id
where transactions.transaction_id is null;

-------- Rank accounts by balance within each branch -------
SELECT account_id, branch_id, balance,
       RANK() OVER (PARTITION BY branch_id ORDER BY balance DESC) AS balance_rank
FROM Accounts;

----------- MORE ADVANCED QUERIES
--------  Find customers who took a loan but don’t have any account -----
select customers.customer_id,customers.first_name, customers.last_name
from customers join loans
on customers.customer_id = loans.customer_id
left join accounts
on accounts.customer_id = loans.customer_id
where accounts.account_id is null;

-------- Get the branch with the highest total account balance ------
select branches.branch_name as branch_name, round(sum(accounts.balance),2) as highest
from branches join accounts
on branches.branch_id = accounts.branch_id
group by branch_name
order by highest desc
limit 1 ;

-------- Find customers who have made more than 10 transactions ------
select customers.customer_id, customers.first_name, customers.last_name, count(transactions.transaction_id) as transaction_count
from customers join accounts
on customers.customer_id = accounts.customer_id
join transactions
on transactions.account_id = accounts.account_id
group by customers.customer_id
having count(transactions.transaction_id) > 10 ;

-------- Find the total amount of loans per state ------
SELECT customers.state, round(SUM(loans.amount)) AS total_loan
FROM Loans 
JOIN Customers  ON loans.customer_id = customers.customer_id
GROUP BY customers.state
ORDER BY total_loan DESC;

--------  List accounts that have had both credit and debit transactions -----
SELECT account_id
FROM Transactions
GROUP BY account_id
HAVING COUNT(DISTINCT transaction_type) = 2;

--------- Show the top 3 highest loan amounts per loan type -----
SELECT loan_type, customer_id, amount
FROM (
    SELECT loan_type, customer_id, amount,
           RANK() OVER (PARTITION BY loan_type ORDER BY amount DESC) AS ranked
    FROM Loans
) ranked
WHERE ranked <= 3;

-------- Calculate average transaction amount per customer ------
SELECT customers.customer_id, customers.first_name, customers.last_name,
round(AVG(transactions.amount),2) AS avg_transaction
FROM Customers 
JOIN Accounts  ON customers.customer_id = accounts.customer_id
JOIN Transactions  ON accounts.account_id = transactions.account_id
GROUP BY customers.customer_id;

--------- Find customers who have never taken a loan ------
SELECT customers.customer_id, customers.first_name, customers.last_name
FROM Customers 
LEFT JOIN Loans  ON customers.customer_id = loans.customer_id
WHERE loans.loan_id IS NULL;

-------- Display employees who work in branches with more than 1000 accounts -----
SELECT employees.first_name, employees.last_name, branches.branch_name
FROM Employees JOIN Branches 
ON employees.branch_id = branches.branch_id
WHERE branches.branch_id IN (
    SELECT branch_id
    FROM Accounts
    GROUP BY branch_id
    HAVING COUNT(*) > 1000) ;
    
--------- Find the percentage of customers who have taken loans ------
SELECT 
    ROUND(
        (SELECT COUNT(DISTINCT customer_id) FROM Loans) * 100.0 / (SELECT COUNT(*) FROM Customers),2)
        AS loan_customers_percentage;
        

--------  Find customers whose balance is above the average balance ----
select customers.customer_id, customers.first_name, customers.last_name ,
accounts.balance 
from customers join accounts
on customers.customer_id = accounts.customer_id
where accounts.balance > (select avg(balance) from accounts);

-------- Get the customer(s) with the maximum loan amount ------
select customers.customer_id, customers.first_name, customers.last_name,
loans.amount
from customers join loans
on customers.customer_id = loans.customer_id
where loans.amount > (select max(amount) from loans);

-------- List accounts with more than average number of transaction ------
select account_id from transactions
group by account_id
having count(*) >
(select avg(txt_count) from
(select  count(*) as txt_count from transactions
group by account_id) as sub_avg);

-------- Label customers based on account balance category -----
select customers.customer_id, customers.first_name, accounts.balance,
case
when accounts.balance < 10000 then "Low balance"
when accounts.balance between 10000 and 100000 then "Moderate balance"
else "High balance"
end as balance_category
from customers join accounts
on customers.customer_id = accounts.account_id;

-------- Show loan status based on amount and years ------
select loan_id, amount, loan_term_years,
case 
when amount > 1000000 and loan_term_years > 10 then "High risk"
when amount < 500000 then "Low risk"
else "Moderate risk"
end as risk
from loans;

-------- Add transaction type description -----
select transaction_id, transaction_type, amount,
case 
when transaction_type = "Credit" then "Money In"
when transaction_type = "Debit" then "Money Out"
else "Unknown"
end as type_transaction
from transactions;

--------- Rank customers by account balance ------
select customer_id ,account_id, balance,
rank() over( order by balance) as ranked 
from accounts;

-------- Get running total of transaction amount per account ------
select account_id, transaction_id, transaction_date, amount,
sum(amount) over(partition by account_id order by transaction_date) as ranning_total
from transactions;

-------- Find highest transaction per account using ROW_NUMBER ------
select * from
(select *, row_number() over(partition by account_id order by amount desc) as rn
  from transactions) ranked
 where rn = 1;
 
-------- Monthly transaction summary using DATE_FORMAT + GROUP BY -----
SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS month,
       COUNT(*) AS total_transactions,
       SUM(amount) AS total_amount
FROM Transactions
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY month;

--------- Bonus: Combine Subquery + Window Function
-- Customers who are in the top 10% balance holders ----------

SELECT * FROM (
    SELECT customer_id, balance,
           NTILE(10) OVER (ORDER BY balance DESC) AS balance_percentile
    FROM Accounts
) top10
WHERE balance_percentile = 1;

 ------ OR ---
 
 SELECT c.first_name, c.last_name, a.balance
FROM (
    SELECT account_id, customer_id, balance,
           NTILE(10) OVER (ORDER BY balance DESC) AS balance_percentile
    FROM Accounts
) a
JOIN Customers c ON a.customer_id = c.customer_id
WHERE a.balance_percentile = 1;

----- THE END 


