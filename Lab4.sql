-- Task1.1

SELECT
    c.CompanyName,
    a.AddressLine1,
    a.City,
    'Billing' AS AddressType
FROM
    sales.customer AS c
    INNER JOIN sales.customeraddress AS ca
        ON c.CustomerID = ca.CustomerID
    INNER JOIN sales.address AS a
        ON ca.AddressID = a.AddressID
WHERE
    ca.AddressType = 'Main Office';

-- Task1.2

SELECT
    c.CompanyName,
    a.AddressLine1,
    a.City,
    'Shipping' AS AddressType
FROM
    sales.customer AS c
    INNER JOIN sales.customeraddress AS ca
        ON c.CustomerID = ca.CustomerID
    INNER JOIN sales.address AS a
        ON ca.AddressID = a.AddressID
WHERE
    ca.AddressType = 'Shipping';

-- Task1.3

SELECT
    c.CompanyName,
    a.AddressLine1,
    a.City,
    'Billing' AS AddressType
FROM
    sales.customer AS c
    INNER JOIN sales.customeraddress AS ca
        ON c.CustomerID = ca.CustomerID
    INNER JOIN sales.address AS a
        ON ca.AddressID = a.AddressID
WHERE
    ca.AddressType = 'Main Office'
UNION
SELECT
    c.CompanyName,
    a.AddressLine1,
    a.City,
    'Shipping' AS AddressType
FROM
    sales.customer AS c
    INNER JOIN sales.customeraddress AS ca
        ON c.CustomerID = ca.CustomerID
    INNER JOIN sales.address AS a
        ON ca.AddressID = a.AddressID
WHERE
    ca.AddressType = 'Shipping'
ORDER BY
    CompanyName,
    AddressType
LIMIT 10;

-- Task2.1

SELECT
    c.CompanyName
FROM
    sales.customer AS c
    INNER JOIN sales.customeraddress AS ca
        ON c.CustomerID = ca.CustomerID
WHERE
    ca.AddressType = 'Main Office'
EXCEPT
SELECT
    c.CompanyName
FROM
    sales.customer AS c
    INNER JOIN sales.customeraddress AS ca
        ON c.CustomerID = ca.CustomerID
WHERE
    ca.AddressType = 'Shipping';

-- Task2.2

SELECT
    c.CompanyName
FROM
    sales.customer AS c
    INNER JOIN sales.customeraddress AS ca
        ON c.CustomerID = ca.CustomerID
WHERE
    ca.AddressType = 'Main Office'
INTERSECT
SELECT
    c.CompanyName
FROM
    sales.customer AS c
    INNER JOIN sales.customeraddress AS ca
        ON c.CustomerID = ca.CustomerID
WHERE
    ca.AddressType = 'Shipping';

-- Task3.1

SELECT
    City,
    CountryRegion
FROM
    sales.employee
UNION
SELECT
    a.City,
    a.CountryRegion
FROM
    sales.address AS a
    INNER JOIN sales.customeraddress AS ca
        ON a.AddressID = ca.AddressID;

-- Task3.2

SELECT
    City
FROM
    sales.employee
EXCEPT
SELECT
    a.City
FROM
    sales.address AS a
    INNER JOIN sales.customeraddress AS ca
        ON a.AddressID = ca.AddressID;

-- Task3.3

SELECT
    City
FROM
    sales.employee
INTERSECT
SELECT
    a.City
FROM
    sales.address AS a
    INNER JOIN sales.customeraddress AS ca
        ON a.AddressID = ca.AddressID;

-- Task4.1

SELECT
    Name
FROM
    production.product
WHERE
    ListPrice > 50
UNION
SELECT
    Name
FROM
    production.product
WHERE
    Color IS NULL;

-- Task4.2

SELECT
    Color
FROM
    production.product
WHERE
    ListPrice > 1000
INTERSECT
SELECT
    p.Color
FROM
    production.product AS p
    INNER JOIN production.productcategory AS pc
        ON p.ProductCategoryID = pc.ProductCategoryID
WHERE
    pc.Name = 'Components';

-- Task5.1

SELECT
    'категории' AS Source,
    Name
FROM
    production.productcategory
UNION ALL
SELECT
    'модели' AS Source,
    Name
FROM
    production.productmodel;

-- Task5.2

SELECT
    Name
FROM
    production.product
WHERE
    ListPrice < 100
EXCEPT
SELECT
    Name
FROM
    production.product
WHERE
    Color IS NOT NULL;
