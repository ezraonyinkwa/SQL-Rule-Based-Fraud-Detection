---Creating the data modelling tables DimCustomer,DimDevice,DimMerchant,FactTable(FactTransactionsData)

--- Begin by creating the tables and linking them with the primary key.
CREATE TABLE DimCustomer(
AccountID VARCHAR (50)PRIMARY KEY NOT NULL,
CustomerAge INT,
CustomerOccupation VARCHAR (50),
Location VARCHAR(50)
)

CREATE TABLE DimDevice(
DeviceID VARCHAR(50) PRIMARY KEY,
IP_Address VARCHAR (50)
)

CREATE TABLE DimMerchant(
MerchantID VARCHAR (50) PRIMARY KEY,
Channel VARCHAR(50),
TransactionType VARCHAR (50)
)

CREATE TABLE FactTransactionsData(
TransactionID VARCHAR (50) PRIMARY KEY,
AccountID VARCHAR (50) NOT NULL,
MerchantID VARCHAR (50),
DeviceID VARCHAR (50),
TransactionAmount DECIMAL(10,2),
CustomerAge INT,
IP_Address VARCHAR (50),
TransactionDuration VARCHAR (50),
LoginAttempts INT,
AccountBalance DECIMAL (10,2),
TransactionsDate DATE,
TransactionsTime TIME,
CurrentTransactionDate DATE,
CurrentTransactionTime TIME,

FOREIGN KEY (AccountID) REFERENCES DimCustomer(AccountID),
FOREIGN KEY (MerchantID) REFERENCES DimMerchant(MerchantID),
FOREIGN KEY (DeviceID) REFERENCES DimDevice(DeviceID)
);




---Inserting data into the Tables
SELECT MerchantID, Channel, TransactionType
FROM (
    SELECT 
        MerchantID,
        Channel,
        TransactionType,
        ROW_NUMBER() OVER (PARTITION BY MerchantID ORDER BY (SELECT NULL)) AS rn
    FROM transactions_data
) AS t
WHERE rn = 1; ---Testing the query for inserting no duplicates inorder not to violate the primary key


INSERT INTO DimMerchant (MerchantID, Channel, TransactionType)
SELECT MerchantID, Channel, TransactionType
FROM (
    SELECT 
        MerchantID,
        Channel,
        TransactionType,
        ROW_NUMBER() OVER (PARTITION BY MerchantID ORDER BY (SELECT NULL)) AS rn
    FROM transactions_data
) AS t
WHERE rn = 1;

SELECT * 
FROM DimMerchant; ---Checking data in the DimMerchant table no duplicates thus no violation of Primary key.

INSERT INTO DimCustomer(AccountID,CustomerAge,CustomerOccupation,Location) --- DimCustomer Table
SELECT AccountID,CustomerAge,CustomerOccupation,Location  
FROM (
    SELECT 
        AccountID,
        CustomerAge,
        CustomerOccupation,
        Location,
        ROW_NUMBER() OVER (PARTITION BY AccountID ORDER BY (SELECT NULL)) AS ai
    FROM transactions_data
) AS td
WHERE ai = 1; 

INSERT INTO DimDevice(DeviceID,IP_Address) ---DimDevice Table.
SELECT DeviceID,IP_Address
FROM(
SELECT DeviceID,
IP_Address,
ROW_NUMBER()OVER (PARTITION BY DeviceID ORDER BY (SELECT NULL)) AS di
FROM transactions_data
)AS td
WHERE di=1;


INSERT INTO FactTransactionsData(TransactionID,AccountID,MerchantID,DeviceID,TransactionAmount, CustomerAge,IP_Address ,
TransactionDuration ,LoginAttempts,AccountBalance,TransactionsDate ,TransactionsTime,CurrentTransactionDate,CurrentTransactionTime)
SELECT TransactionID,AccountID,MerchantID,DeviceID,TransactionAmount, CustomerAge,IP_Address ,
TransactionDuration ,LoginAttempts,AccountBalance,TransactionsDate ,TransactionsTime,CurrentTransactionDate,CurrentTransactionTime
FROM transactions_data;

ALTER TABLE FactTransactionsData
ADD TransactionType VARCHAR (50); ---added a column that was important for developing the system and it was missing in the fact table.

UPDATE f
SET f.TransactionType = t.TransactionType
FROM FactTransactionsData f
INNER JOIN transactions_data t
    ON f.TransactionID = t.TransactionID;
