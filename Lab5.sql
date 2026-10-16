SET LANGUAGE us_english;

-- Task1.1

SELECT
    ProductID,
    UPPER(Name) AS ProductName,
    ROUND(Weight, 0) AS ApproxWeight
FROM
    SalesLT.Product;

-- Task1.2

SELECT
    ProductID,
    UPPER(Name) AS ProductName,
    ROUND(Weight, 0) AS ApproxWeight,
    YEAR(SellStartDate) AS SellStartYear,
    DATENAME(MONTH, SellStartDate) AS SellStartMonth
FROM
    SalesLT.Product;

-- Task1.3

SELECT
    ProductID,
    UPPER(Name) AS ProductName,
    ROUND(Weight, 0) AS ApproxWeight,
    YEAR(SellStartDate) AS SellStartYear,
    DATENAME(MONTH, SellStartDate) AS SellStartMonth,
    LEFT(ProductNumber, 2) AS ProductType
FROM
    SalesLT.Product;

-- Task1.4

SELECT
    ProductID,
    UPPER(Name) AS ProductName,
    ROUND(Weight, 0) AS ApproxWeight,
    YEAR(SellStartDate) AS SellStartYear,
    DATENAME(MONTH, SellStartDate) AS SellStartMonth,
    LEFT(ProductNumber, 2) AS ProductType
FROM
    SalesLT.Product
WHERE
    ISNUMERIC(Size) = 1;

-- Task2.1

SELECT
    c.CompanyName,
    soh.TotalDue AS Revenue,
    RANK() OVER (ORDER BY soh.TotalDue DESC) AS RankByRevenue
FROM
    SalesLT.Customer AS c
    INNER JOIN SalesLT.SalesOrderHeader AS soh
        ON c.CustomerID = soh.CustomerID
ORDER BY
    Revenue DESC;

-- Task3.1

SELECT
    p.Name,
    SUM(sod.LineTotal) AS TotalRevenue
FROM
    SalesLT.Product AS p
    INNER JOIN SalesLT.SalesOrderDetail AS sod
        ON p.ProductID = sod.ProductID
GROUP BY
    p.ProductID,
    p.Name
ORDER BY
    TotalRevenue DESC;

-- Task3.2

SELECT
    p.Name,
    SUM(sod.LineTotal) AS TotalRevenue
FROM
    SalesLT.Product AS p
    INNER JOIN SalesLT.SalesOrderDetail AS sod
        ON p.ProductID = sod.ProductID
WHERE
    p.ListPrice > 1000
GROUP BY
    p.ProductID,
    p.Name
ORDER BY
    TotalRevenue DESC;

-- Task3.3

SELECT
    p.Name,
    SUM(sod.LineTotal) AS TotalRevenue
FROM
    SalesLT.Product AS p
    INNER JOIN SalesLT.SalesOrderDetail AS sod
        ON p.ProductID = sod.ProductID
WHERE
    p.ListPrice > 1000
GROUP BY
    p.ProductID,
    p.Name
HAVING
    SUM(sod.LineTotal) > 20000
ORDER BY
    TotalRevenue DESC;
