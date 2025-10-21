---High Transaction Amount (Threshold Breach)
SELECT 
    TransactionID, AccountID, TransactionAmount, CurrentTransactionDate
FROM FactTransactionsData
WHERE TransactionAmount > 5000;

---Multiple Transactions in a Short Time (Velocity Rule)
SELECT 
    AccountID,
    COUNT(*) AS TxnCount,
    MIN(CurrentTransactionTime) AS StartTime,
    MAX(CurrentTransactionTime) AS EndTime
FROM FactTransactionsData
WHERE CurrentTransactionDate >= DATEADD(MINUTE, -10, GETDATE())
GROUP BY AccountID
HAVING COUNT(*) >= 5; --- 0 cases meaning fraudster have started using a different way to bypass this.

---- Same Device Used by Multiple Accounts
SELECT 
    d.DeviceID,
    COUNT(DISTINCT f.AccountID) AS DistinctAccounts
FROM FactTransactionsData f
JOIN DimDevice d ON f.DeviceID = d.DeviceID
GROUP BY d.DeviceID
HAVING COUNT(DISTINCT f.AccountID) > 3; --- 344 cases found that contained a device used by >3 accounts.

--- Transactions from Unusual Locations
SELECT 
    f.AccountID,
    l.Location,
    COUNT(*) AS TxnCount
FROM FactTransactionsData f
JOIN DimCustomer l ON f.AccountID = l.AccountID
GROUP BY f.AccountID, l.Location
HAVING COUNT(*) = 1;  --- 24 Cases found

--- Rapid Balance Depletion
SELECT 
    AccountID,
    MIN(AccountBalance) AS MinBalance,
    MAX(AccountBalance) AS MaxBalance,
    (MAX(AccountBalance) - MIN(AccountBalance)) AS DropAmount
FROM FactTransactionsData
GROUP BY AccountID
HAVING (MAX(AccountBalance) - MIN(AccountBalance)) > 0.8 * MAX(AccountBalance);

--- Repeated Failed Login Attempts
SELECT 
    AccountID,
    AVG(LoginAttempts) AS AvgAttempts
FROM FactTransactionsData
GROUP BY AccountID
HAVING AVG(LoginAttempts) > 3; --- One case was found of accountID AC00169

--- Transactions from Multiple Devices in One Hour
SELECT 
    AccountID,
    COUNT(DISTINCT DeviceID) AS DistinctDevices,
    DATEPART(HOUR, CurrentTransactionTime) AS HourWindow
FROM FactTransactionsData

--- Same IP Used by Multiple Merchants
SELECT 
    d.IP_Address,
    COUNT(DISTINCT f.MerchantID) AS MerchantsUsingIP
FROM FactTransactionsData f
JOIN DimDevice d ON f.DeviceID = d.DeviceID
GROUP BY d.IP_Address
HAVING COUNT(DISTINCT f.MerchantID) > 2; --- 338 Cases found of multiple merchants using the same IP_Address.

--- Inconsistent Transaction Type Behavior
SELECT 
    AccountID,
    COUNT(DISTINCT TransactionType) AS TxnTypes
FROM FactTransactionsData
GROUP BY AccountID
HAVING COUNT(DISTINCT TransactionType) >= 2; 

---Odd Transaction Time (Night Hours)
SELECT 
    TransactionID, AccountID, CurrentTransactionTime, TransactionAmount
FROM FactTransactionsData
WHERE DATEPART(HOUR, CurrentTransactionTime) BETWEEN 0 AND 4; --- No transactions made in odd hours.

GROUP BY AccountID, DATEPART(HOUR, CurrentTransactionTime)
HAVING COUNT(DISTINCT DeviceID) > 3; 
