-- Task1.1

SELECT
    a.CountryRegion,
    a.StateProvince,
    SUM(soh.TotalDue) AS Revenue
FROM
    SalesLT.Address AS a
    INNER JOIN SalesLT.CustomerAddress AS ca
        ON a.AddressID = ca.AddressID
    INNER JOIN SalesLT.Customer AS c
        ON ca.CustomerID = c.CustomerID
    INNER JOIN SalesLT.SalesOrderHeader AS soh
        ON c.CustomerID = soh.CustomerID
GROUP BY
    ROLLUP(a.CountryRegion, a.StateProvince)
ORDER BY
    a.CountryRegion,
    a.StateProvince;
GO

-- Task1.2

SELECT
    a.CountryRegion,
    a.StateProvince,
    SUM(soh.TotalDue) AS Revenue,
    CASE GROUPING_ID(a.CountryRegion, a.StateProvince)
        WHEN 3 THEN N'Total'
        WHEN 1 THEN CONCAT(a.CountryRegion, N' Subtotal')
        WHEN 0 THEN CONCAT(a.StateProvince, N' Subtotal')
    END AS [Level]
FROM
    SalesLT.Address AS a
    INNER JOIN SalesLT.CustomerAddress AS ca
        ON a.AddressID = ca.AddressID
    INNER JOIN SalesLT.Customer AS c
        ON ca.CustomerID = c.CustomerID
    INNER JOIN SalesLT.SalesOrderHeader AS soh
        ON c.CustomerID = soh.CustomerID
GROUP BY
    ROLLUP(a.CountryRegion, a.StateProvince)
ORDER BY
    a.CountryRegion,
    a.StateProvince;
GO

-- Task1.3

SELECT
    a.CountryRegion,
    a.StateProvince,
    a.City,
    SUM(soh.TotalDue) AS Revenue,
    CASE GROUPING_ID(a.CountryRegion, a.StateProvince, a.City)
        WHEN 7 THEN N'Total'
        WHEN 3 THEN CONCAT(a.CountryRegion, N' Subtotal')
        WHEN 1 THEN CONCAT(a.StateProvince, N' Subtotal')
        WHEN 0 THEN CONCAT(a.City, N' Subtotal')
    END AS [Level]
FROM
    SalesLT.Address AS a
    INNER JOIN SalesLT.CustomerAddress AS ca
        ON a.AddressID = ca.AddressID
    INNER JOIN SalesLT.Customer AS c
        ON ca.CustomerID = c.CustomerID
    INNER JOIN SalesLT.SalesOrderHeader AS soh
        ON c.CustomerID = soh.CustomerID
GROUP BY
    ROLLUP(a.CountryRegion, a.StateProvince, a.City)
ORDER BY
    a.CountryRegion,
    a.StateProvince,
    a.City;
GO

-- Task2.1

SELECT
    CompanyName,
    Accessories,
    Bikes,
    Clothing,
    Components
FROM (
    SELECT
        c.CompanyName,
        cat.ParentProductCategoryName,
        sod.LineTotal
    FROM
        SalesLT.Customer AS c
        INNER JOIN SalesLT.SalesOrderHeader AS soh
            ON c.CustomerID = soh.CustomerID
        INNER JOIN SalesLT.SalesOrderDetail AS sod
            ON soh.SalesOrderID = sod.SalesOrderID
        INNER JOIN SalesLT.Product AS p
            ON sod.ProductID = p.ProductID
        INNER JOIN SalesLT.vGetAllCategories AS cat
            ON p.ProductCategoryID = cat.ProductCategoryID
) AS SalesData
PIVOT (
    SUM(LineTotal)
    FOR ParentProductCategoryName IN (
        [Accessories], [Bikes], [Clothing], [Components]
    )
) AS CategoryRevenue
ORDER BY
    CompanyName;
