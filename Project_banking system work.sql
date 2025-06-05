-- Creating a Database
create database Banking_System;
use Banking_System;
-- Creating a 1st Table (Customers)
create table Customers(
CustomerID int primary key,
First_name varchar(50),
Last_name varchar(50),
Email varchar(50),
Phone_number int,
Address varchar(50),
DOB date
);
-- Inserting the values in Customers table
insert into Customers(CustomerID,First_name,Last_name,Email,Phone_number,Address,DOB)
values
(1,'Vivek','Kumar','vk01@gmail.com',0987654321,'B13 Mayapuri','1996-08-08'),
(2,'Akash','Dev','ak56@gmail.com',1234567890,'A-Block GK','2000-04-19'),
(3,'Rakhi','Singh','rk66@gmail.com',1324567879,'B-Block GK','1999-12-01'),
(4,'Deepika','Paswan','dp23@gmail.com',1029384756,'A12 Mayapuri','2001-10-28'),
(5,'Nehal','Roy','Nr12@gmail.com',1234432154,'C-Block Ashok Nagar','2000-01-02'),
(6,'Pooja','Kumari','pk@gmail.com',1232321232,'E-Block Ashok Nagar','2002-06-04'),
(7,'Ravi','Gupta','ravi@email.com',1234432174,'GK Part1','1989-08-08'),
(8,'Neha','Joshi','nj@email.com',1029384754,'Zamrudpur E-Block','2003-03-07'),
(9,'Vikram','Rao','vrao@email.com',1374567879,'C New Ashok Nagar','2000-10-16'),
(10,'Manisha','Das','manisha@email.com',2123567890,'C17 Mayapuri','2001-07-29');

-- Retreieving all customers details
select * from Customers;

-- Creating a 2nd Table (Accounts)
create table Accounts(
AccountID int primary key,
CustomerID int,
Account_Type varchar(50),
Balance decimal(10,2),
Status varchar(50),
Created_at timestamp,
foreign key (CustomerID) REFERENCES Customers(CustomerID)
);
-- Inserting values in Accounts Table
insert into Accounts(AccountID,CustomerID,Account_Type,Balance,Status,Created_at)
values
(101,1,'Savings',5000.00,'Active','2015-03-03 10:15:00'),
(102,2,'Salary',25000.00,'Active','2019-04-03 11:30:00'),
(103,3,'Saving',20000.00,'Active','2018-05-10 13:10:00'),
(104,4,'Salary',45000.00,'Active','2013-01-02 14:20:00'),
(105,5,'Current',65000.00,'Active','2019-06-12 10:00:00'),
(106,6,'Loan',50000.00,'Active','2020-12-22 10:30:00'),
(107,7,'Savings',15000.00,'Active','2008-06-15 09:30:00'),
(108,8,'Current',25000.00,'Active','2022-02-20 11:15:00'),
(109,9,'Salary',60000.00,'Active','2019-10-05 14:00:00'),
(110,10,'Savings',20000.00,'Active','2018-12-25 08:45:00');

-- Retreieving all Accounts details
select * from Accounts;

-- Showing joining table (Customers and Account)
select
a.AccountId, 
a.Account_type, 
a.Balance, 
a.Status, 
c.CustomerID, 
c.First_name, 
c.Last_name, 
c.Email
from Accounts a
join Customers c ON a.CustomerID = c.CustomerID;

-- Creating a 3rd Table (Transactions)
create table Transactions(
TransactionID int primary key,
AccountID int,
Transaction_Type varchar(50),
Amount decimal(10,2),
Status varchar(20),
Transaction_date timestamp,
Balance_After_Transaction decimal(10,2),
foreign key (AccountID) REFERENCES Accounts(AccountID)
);
-- Inserting values in Transactions table
insert into Transactions(TransactionID,AccountID,Transaction_type,Amount,Status,Transaction_date,Balance_After_Transaction)
values
(1001,101,'Deposit',5000.00,'Success','2015-03-03 10:15:00',5000.00),
(1002,102,'Deposit',25000.00,'Success','2019-04-03 11:31:00',25000.00),
(1003,103,'Deposit',10000.00,'Success','2018-05-11 13:00:00',30000.00),
(1004,104,'Withdrawal',30000.00,'Failed','2013-02-10 11:30:00',15000.00),
(1005,105,'Withdrawal',10000.00,'Failed','2019-06-12 10:05:00',55000.00),
(1006,106,'Withdrawal',20000.00,'Failed','2025-01-05 10:00:00',50000.00),
(1007,106,'Deposit',5000.00,'Failed','2025-01-15 10:00:00',50000.00),
(1008,106,'Withdrawal',2000.00,'Failed','2025-01-26 11:30:00',50000.00),
(1009,107,'Deposit',3000.00,'Successful','2020-02-21 14:20:00',12000.00),
(1010,108,'Deposit',10000.00,'Successful','2019-10-06 10:15:00',15000.00),
(1011,109,'Withdrawal',5000.00,'Failed','2023-02-01 10:00:00',55000.00),
(1012,110,'Withdrawal',7000.00,'Failed','2023-02-05 12:15:00',13000.00);

-- Retreieving all Transactions details
select * from Transactions;

-- Showing joining table (Accounts and Transactions)
select
    t.TransactionID, 
    t.AccountID, 
    a.Account_type, 
    a.Balance, 
    t.Transaction_type, 
    t.Amount, 
    t.Transaction_date, 
    t.Status
FROM Transactions t
JOIN Accounts a ON t.AccountID = a.AccountID;

-- Retrieve Account Statement for a Specific Customer Within a Date Range
select
t.AccountID, 
t.Transaction_type, 
t.Amount, 
t.Transaction_date
From Transactions t
Join Accounts a ON t.AccountID = a.AccountID
Where a.CustomerID = 6  -- Change this to the specific customer_id
and t.Transaction_date between '2024-12-02 ' and '2025-01-30' -- Specify the date range
ORDER BY t.Transaction_date;

-- Query to Identify Accounts with More Than 3 Failed Transactions
select 
a.CustomerID, 
t.AccountID, 
COUNT(*) AS Failed_Transactions
from Transactions t
join Accounts a ON t.AccountID = a.AccountID  
where t.Status = 'Failed'  
and t.Transaction_date between '2024-12-02' and '2025-01-30' 
group by a.CustomerID, t.AccountID  
having COUNT(*) >=3;

-- Create the transaction_logs table (Ensure it's created before using it)
CREATE TABLE IF NOT EXISTS transaction_logs (
log_id INT AUTO_INCREMENT PRIMARY KEY,
AccountID INT,
Transaction_type VARCHAR(50),
Amount DECIMAL(10, 2),
status VARCHAR(20),
Transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- Transfer Money Between Two Accounts (Atomic Transaction & Rollback)
DELIMITER $$

CREATE PROCEDURE transfer_money(IN sender_account INT, IN receiver_account INT, IN transfer_amount DECIMAL(10, 2))
BEGIN
-- Start the transaction
START TRANSACTION;

-- Step 1: Check if the sender has enough balance
IF (SELECT balance FROM Accounts WHERE AccountID = 103) < 15000 THEN
-- Rollback if insufficient funds
ROLLBACK;
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient funds, transaction rolled back';
END IF;

-- Step 2: Deduct money from sender's account
UPDATE Accounts
SET balance = balance - 15000
WHERE AccountID = 103;

-- Step 3: Add money to receiver's account
UPDATE Accounts
SET balance = balance + 15000
WHERE AccountID = 101;

-- Step 4: Log the transaction for sender before commit
INSERT INTO transaction_logs (AccountID, Transaction_type, Amount, status)
    VALUES (103, 'debit', 15000, 'committed');

-- Log the transaction for receiver before commit
INSERT INTO transaction_logs (AccountID, Transaction_type, Amount, status)
VALUES (101, 'credit', 15000, 'committed');

-- Step 5: Commit the transaction
COMMIT;

END $$

DELIMITER ;

-- Calling the stored procedure
CALL transfer_money(103, 101, 15000.00);

-- Checking the transaction logs for account 103
SELECT * FROM transaction_logs WHERE AccountID IN (103, 101);

-- Set a Maximum Withdrawal Limit on Individual Transactions for Each Account
-- Alter Transactions table to add a constraint for withdrawal limit
DELIMITER $$

CREATE TRIGGER check_withdrawal_limit
BEFORE INSERT ON Transactions
FOR EACH ROW
BEGIN
    -- Check if the transaction type is 'Withdrawal' and if the amount exceeds the limit
    IF NEW.Transaction_Type = 'Withdrawal' AND NEW.Amount > 5000.00 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Withdrawal amount exceeds the $5000 limit';
    END IF;
END $$

DELIMITER ;
-- Try to insert a withdrawal above the limit (should trigger the error)
INSERT INTO Transactions (TransactionID, AccountID, Transaction_Type, Amount, Status, Transaction_date, Balance_After_Transaction)
VALUES (1012, 107, 'Withdrawal', 15000.00, 'Failed', '2025-03-04 12:00:00', 12000.00),
(1011, 103, 'Withdrawal', 25000.00, 'Failed', '2018-06-15 13:00:00', 30000.00),
(1010, 106, 'Withdrawal', 25000.00, 'Failed', '2025-01-19 14:00:00', 50000.00);
-- Query to check if a customer has attempted a withdrawal exceeding $5000 in the last month
-- Query to check if a customer has attempted a withdrawal exceeding $5000 in the last month
SELECT 
t.TransactionID, 
a.AccountID, 
a.CustomerID, 
t.Amount
FROM 
Transactions t
JOIN 
Accounts a ON t.AccountID = a.AccountID
WHERE 
t.Transaction_Type = 'Withdrawal'
AND t.Amount > 5000.00
AND t.Status = 'Failed'  -- Only consider failed transactions
and t.Transaction_date between '2024-12-02 ' and '2025-01-30' -- Specify the date range
ORDER BY t.Transaction_date;
-- SQL Trigger to Implement Daily Transaction Limit
DELIMITER $$

DELIMITER $$

CREATE TRIGGER check_daily_transaction_limit
BEFORE INSERT ON Transactions
FOR EACH ROW
BEGIN
    DECLARE total_amount DECIMAL(10, 2);

    -- Calculate the total transaction amount for the same day for the account
    SELECT SUM(Amount)
    INTO total_amount
    FROM Transactions
    WHERE AccountID = NEW.AccountID
    AND DATE(Transaction_date) = DATE(NEW.Transaction_date);

    -- Check if the total transaction amount for the day exceeds the limit of $10,000
    IF (total_amount + NEW.Amount) > 10000.00 THEN
        -- Reject the transaction if the total exceeds $10,000
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Daily transaction limit of 10,000 exceeded for this account';
    END IF;
END $$

DELIMITER ;
-- First Transaction: 4,000 Withdrawal at 9:00 AM
INSERT INTO Transactions (TransactionID, AccountID, Transaction_Type, Amount, Status, Transaction_date, Balance_After_Transaction)
VALUES (1006, 106, 'Withdrawal', 4000.00, 'Success', '2025-03-04 09:00:00', 46000.00);

-- Second Transaction: 5,000 Withdrawal at 2:00 PM
INSERT INTO Transactions (TransactionID, AccountID, Transaction_Type, Amount, Status, Transaction_date, Balance_After_Transaction)
VALUES (1007, 106, 'Withdrawal', 5000.00, 'Success', '2025-01-19 14:00:00', 41000.00);
SELECT * FROM Transactions WHERE AccountID = 106;