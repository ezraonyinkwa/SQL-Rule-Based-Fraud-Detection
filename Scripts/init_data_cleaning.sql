---Creating a duplicate incase we make a mistake we can always have our raw data
SELECT *
INTO transactions_data
FROM bank_transactions_data;

SELECT *
FROM transactions_data

--Data Cleaning Process to carry out.
--- (1.) Round off the Transaction amount & bal to nearest 2 d.p
--- (2.) Separate Transaction Date from transaction time

-----Roundoff transaction Amount & Balance Amount to 2dp.
SELECT ROUND (TransactionAmount,2)
FROM transactions_data; -----Testing Query

UPDATE transactions_data
SET TransactionAmount = ROUND(TransactionAmount,2);

UPDATE transactions_data
SET AccountBalance = ROUND(AccountBalance,2);

----Separating time from dates

--For columns (1) TransactionsDate (2) PreviousTransactionDate

---Begin by adding new columns for the dates and time.

ALTER TABLE transactions_data
ADD TransactionsDate DATE; 

ALTER TABLE transactions_data 
ADD TransactionsTime TIME;

ALTER TABLE transactions_data
ADD CurrentTransactionDate DATE;

ALTER TABLE transactions_data
ADD CurrentTransactionTime TIME;

---	Adding the data into the specific columns.
SELECT CONVERT(DATE,[TransactionDate])
FROM transactions_data; ---Testing Query

UPDATE transactions_data
SET TransactionsDate = CONVERT(Date,[TransactionDate]);

UPDATE transactions_data
SET TransactionsTime = CONVERT(TIME,[TransactionDate]);


UPDATE transactions_data
SET CurrentTransactionTime = CONVERT(TIME,[PreviousTransactionDate]);

UPDATE transactions_data
SET CurrentTransactionDate = CONVERT(DATE,[PreviousTransactionDate]);

---Drop columns with combined date and time.
ALTER TABLE transactions_data
DROP COLUMN TransactionDate;

ALTER TABLE transactions_data
DROP COLUMN PreviousTransactionDate;

