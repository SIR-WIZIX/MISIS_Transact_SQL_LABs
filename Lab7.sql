use AdventureWorksLT2019;
-- Task1.1

SELECT
    p.ProductID,
    p.Name AS ProductName,
    pm.Name AS ProductModel,
    pm.Summary
FROM
    SalesLT.Product AS p
    INNER JOIN SalesLT.vProductModelCatalogDescription AS pm
        ON p.ProductModelID = pm.ProductModelID
ORDER BY
    p.ProductID;
GO

-- Task1.2

DECLARE @Colors TABLE (
    Color nvarchar(15) NOT NULL PRIMARY KEY
);

INSERT INTO @Colors (Color)
SELECT DISTINCT
    Color
FROM
    SalesLT.Product
WHERE
    Color IS NOT NULL;

SELECT
    ProductID,
    Name AS ProductName,
    Color
FROM
    SalesLT.Product
WHERE
    Color IN (
        SELECT Color
        FROM @Colors
    )
ORDER BY
    Color;
GO

-- Task1.3

DROP TABLE IF EXISTS #Sizes;

CREATE TABLE #Sizes (
    Size nvarchar(5) NOT NULL PRIMARY KEY
);

INSERT INTO #Sizes (Size)
SELECT DISTINCT
    Size
FROM
    SalesLT.Product
WHERE
    Size IS NOT NULL;

SELECT
    ProductID,
    Name AS ProductName,
    Size
FROM
    SalesLT.Product
WHERE
    Size IN (
        SELECT Size
        FROM #Sizes
    )
ORDER BY
    Size DESC;

DROP TABLE #Sizes;
GO

-- Task1.4

SELECT
    p.ProductID,
    p.Name AS ProductName,
    c.ParentProductCategoryName AS ParentCategory,
    c.ProductCategoryName AS Category
FROM
    SalesLT.Product AS p
    INNER JOIN dbo.ufnGetAllCategories() AS c
        ON p.ProductCategoryID = c.ProductCategoryID
ORDER BY
    CONCAT(c.ParentProductCategoryName, N' > ', c.ProductCategoryName),
    p.Name;
GO

-- Task2.1

SELECT
    CustomerSales.CompanyContact,
    SUM(CustomerSales.TotalDue) AS Revenue
FROM (
    SELECT
        c.CustomerID,
        soh.SalesOrderID,
        CONCAT(c.CompanyName, N' (', c.FirstName, N' ', c.LastName, N')')
            AS CompanyContact,
        soh.TotalDue
    FROM
        SalesLT.Customer AS c
        INNER JOIN SalesLT.SalesOrderHeader AS soh
            ON c.CustomerID = soh.CustomerID
) AS CustomerSales
GROUP BY
    CustomerSales.CustomerID,
    CustomerSales.CompanyContact
ORDER BY
    CustomerSales.CompanyContact;
GO

-- Task2.2

WITH CustomerSales AS (
    SELECT
        c.CustomerID,
        soh.SalesOrderID,
        CONCAT(c.CompanyName, N' (', c.FirstName, N' ', c.LastName, N')')
            AS CompanyContact,
        soh.TotalDue
    FROM
        SalesLT.Customer AS c
        INNER JOIN SalesLT.SalesOrderHeader AS soh
            ON c.CustomerID = soh.CustomerID
)
SELECT
    CompanyContact,
    SUM(TotalDue) AS Revenue
FROM
    CustomerSales
GROUP BY
    CustomerID,
    CompanyContact
ORDER BY
    CompanyContact;
