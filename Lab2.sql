-- Task1.1

SELECT DISTINCT
    City,
    StateProvince
FROM
    SalesLT.Address;

-- Task1.2

SELECT TOP 10 PERCENT
    Name,
    Weight
FROM
    SalesLT.Product
ORDER BY
    Weight DESC;

-- Task1.3

SELECT
    Name,
    Weight
FROM
    SalesLT.Product
ORDER BY
    Weight DESC
OFFSET 10 ROWS
FETCH NEXT 100 ROWS ONLY;

-- Task2.1

SELECT
    Name,
    Color,
    Size
FROM
    SalesLT.Product
WHERE
    ProductModelID = 1;

-- Task2.2

SELECT
    ProductNumber,
    Name
FROM
    SalesLT.Product
WHERE
    Color IN ('black', 'red', 'white')
    AND Size IN ('S', 'M');

-- Task2.3

SELECT
    ProductNumber,
    Name,
    ListPrice
FROM
    SalesLT.Product
WHERE
    ProductNumber LIKE 'BK-%';

-- Task2.4

SELECT
    ProductNumber,
    Name,
    ListPrice
FROM
    SalesLT.Product
WHERE
    ProductNumber LIKE 'BK-[^R]%-[0-9][0-9]';
