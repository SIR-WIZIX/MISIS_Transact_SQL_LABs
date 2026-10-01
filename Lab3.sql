-- Task1.1

SELECT
    c.CompanyName,
    soh.SalesOrderID,
    soh.TotalDue
FROM
    SalesLT.Customer AS c
    INNER JOIN SalesLT.SalesOrderHeader AS soh
        ON c.CustomerID = soh.CustomerID;

-- Task1.2

SELECT
    c.CompanyName,
    soh.SalesOrderID,
    soh.TotalDue,
    a.AddressLine1,
    a.AddressLine2,
    a.City,
    a.StateProvince,
    a.PostalCode,
    a.CountryRegion
FROM
    SalesLT.Customer AS c
    INNER JOIN SalesLT.SalesOrderHeader AS soh
        ON c.CustomerID = soh.CustomerID
    INNER JOIN SalesLT.CustomerAddress AS ca
        ON c.CustomerID = ca.CustomerID
        AND ca.AddressType = 'Main Office'
    INNER JOIN SalesLT.Address AS a
        ON ca.AddressID = a.AddressID;

-- Task2.1

SELECT
    c.CompanyName,
    c.FirstName,
    c.LastName,
    soh.SalesOrderID,
    soh.TotalDue
FROM
    SalesLT.Customer AS c
    LEFT JOIN SalesLT.SalesOrderHeader AS soh
        ON c.CustomerID = soh.CustomerID
ORDER BY
    CASE
        WHEN soh.SalesOrderID IS NULL THEN 1
        ELSE 0
    END,
    c.CompanyName,
    soh.SalesOrderID;

-- Task2.2

SELECT
    c.CustomerID,
    c.CompanyName,
    c.FirstName,
    c.LastName,
    c.Phone
FROM
    SalesLT.Customer AS c
    LEFT JOIN SalesLT.CustomerAddress AS ca
        ON c.CustomerID = ca.CustomerID
WHERE
    ca.AddressID IS NULL;

-- Task2.3

SELECT
    c.CustomerID,
    p.ProductID
FROM
    SalesLT.Customer AS c
    LEFT JOIN SalesLT.SalesOrderHeader AS soh
        ON c.CustomerID = soh.CustomerID
    LEFT JOIN SalesLT.SalesOrderDetail AS sod
        ON soh.SalesOrderID = sod.SalesOrderID
    FULL OUTER JOIN SalesLT.Product AS p
        ON sod.ProductID = p.ProductID
WHERE
    soh.SalesOrderID IS NULL;
