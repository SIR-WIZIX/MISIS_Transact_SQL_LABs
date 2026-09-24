-- Task1.1

SELECT * FROM SalesLT.Customer;

-- Task1.2

SELECT
    ISNULL(Title, ''),
    ISNULL(FirstName, ''),
    ISNULL(MiddleName, ''),
    ISNULL(LastName, ''),
    ISNULL(Suffix, '')
FROM
    SalesLT.Customer;


-- Task1.3

SELECT
    SalesPerson, CONCAT(Title, LastName) AS "CustomerName",
    Phone
FROM
    SalesLT.Customer;

-- Task2.1

SELECT 
    CONCAT(CustomerID, ': ', CompanyName) AS "CustomerCompany"
FROM
    SalesLT.Customer;

-- Task2.2

SELECT 
    CONCAT(SalesOrderNumber, ' (', RevisionNumber, ')') AS OrderRevision,
    FORMAT(OrderDate, 'yyyy.MM.dd') AS OrderDate
FROM 
    SalesLT.SalesOrderHeader;

-- Task3.1

SELECT 
    CONCAT(FirstName, ISNULL(' ' + MiddleName, ''), ' ', LastName) AS CustomerName
FROM 
    SalesLT.Customer;

-- Task3.2

UPDATE SalesLT.Customer
SET EmailAddress = NULL
WHERE CustomerID % 7 = 1;


SELECT 
    CustomerID,
    ISNULL(EmailAddress, Phone) AS PrimaryContact
FROM 
    SalesLT.Customer;

-- Task3.3

UPDATE SalesLT.SalesOrderHeader
SET ShipDate = NULL
WHERE SalesOrderID > 71899;


SELECT 
    SalesOrderID,
    OrderDate,
    CASE 
        WHEN ShipDate IS NOT NULL THEN 'Shipped'
        ELSE 'Awaiting Shipment'
    END AS ShippingStatus
FROM 
    SalesLT.SalesOrderHeader;