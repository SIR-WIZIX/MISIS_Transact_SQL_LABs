USE AdventureWorksLT2019;

DROP TABLE IF EXISTS lab6.OrderLine;
DROP TABLE IF EXISTS lab6.Orders;
DROP TABLE IF EXISTS lab6.Product;
DROP TABLE IF EXISTS lab6.Customer;
DROP TABLE IF EXISTS lab6.AuditLog;
GO

-- Task1.1

IF SCHEMA_ID(N'lab6') IS NULL
    EXEC(N'CREATE SCHEMA lab6;');
GO

-- Task1.2

CREATE TABLE lab6.Customer (
    CustomerID int NOT NULL,
    Name nvarchar(100) NOT NULL,
    City nvarchar(50) NOT NULL,
    Email nvarchar(100) NULL,
    CreatedAt datetime2 NOT NULL
        CONSTRAINT DF_Customer_CreatedAt DEFAULT SYSDATETIME(),
    CONSTRAINT PK_Customer PRIMARY KEY (CustomerID),
    CONSTRAINT UQ_Customer_Email UNIQUE (Email)
);

CREATE TABLE lab6.Product (
    ProductID int NOT NULL,
    Name nvarchar(100) NOT NULL,
    Price decimal(10, 2) NOT NULL,
    CONSTRAINT PK_Product PRIMARY KEY (ProductID),
    CONSTRAINT CK_Product_Price CHECK (Price >= 0)
);
GO

-- Task1.3

CREATE TABLE lab6.Orders (
    OrderID int IDENTITY(1, 1) NOT NULL,
    OrderDate date NOT NULL
        CONSTRAINT DF_Orders_OrderDate DEFAULT (CAST(GETDATE() AS date)),
    CustomerID int NOT NULL,
    CONSTRAINT PK_Orders PRIMARY KEY (OrderID),
    CONSTRAINT FK_Orders_Customer FOREIGN KEY (CustomerID)
        REFERENCES lab6.Customer (CustomerID)
);

CREATE TABLE lab6.OrderLine (
    OrderID int NOT NULL,
    ProductID int NOT NULL,
    Qty int NOT NULL,
    CONSTRAINT PK_OrderLine PRIMARY KEY (OrderID, ProductID),
    CONSTRAINT FK_OrderLine_Orders FOREIGN KEY (OrderID)
        REFERENCES lab6.Orders (OrderID) ON DELETE CASCADE,
    CONSTRAINT FK_OrderLine_Product FOREIGN KEY (ProductID)
        REFERENCES lab6.Product (ProductID),
    CONSTRAINT CK_OrderLine_Qty CHECK (Qty > 0)
);
GO

-- Task1.4

INSERT INTO lab6.Customer (CustomerID, Name, City, Email)
VALUES
    (1, N'Егор', N'Москва', N'egor@example.com'),
    (2, N'Михаил', N'Тверь', N'mikhail@example.com'),
    (3, N'Софа', N'Рязань', NULL);

INSERT INTO lab6.Product (ProductID, Name, Price)
VALUES
    (1, N'Клавиатура', 3500.00),
    (2, N'Мышь', 1500.00),
    (3, N'Монитор', 20000.00);

DECLARE @FirstOrderID int;
DECLARE @SecondOrderID int;

INSERT INTO lab6.Orders (CustomerID)
VALUES (1);

SET @FirstOrderID = CAST(SCOPE_IDENTITY() AS int);

INSERT INTO lab6.Orders (CustomerID)
VALUES (2);

SET @SecondOrderID = CAST(SCOPE_IDENTITY() AS int);

INSERT INTO lab6.OrderLine (OrderID, ProductID, Qty)
VALUES
    (@FirstOrderID, 1, 2),
    (@FirstOrderID, 2, 1),
    (@SecondOrderID, 3, 1);

BEGIN TRY
    INSERT INTO lab6.Product (ProductID, Name, Price)
    VALUES (4, N'Ошибка цены', -1.00);
END TRY
BEGIN CATCH
    SELECT
        N'1.4: отрицательная цена' AS Test,
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorText;
END CATCH;

BEGIN TRY
    INSERT INTO lab6.OrderLine (OrderID, ProductID, Qty)
    VALUES (@FirstOrderID, 999, 1);
END TRY
BEGIN CATCH
    SELECT
        N'1.4: отсутствующий товар' AS Test,
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorText;
END CATCH;

BEGIN TRY
    INSERT INTO lab6.Customer (CustomerID, Name, City, Email)
    VALUES (4, N'Дубликат email', N'Москва', N'egor@example.com');
END TRY
BEGIN CATCH
    SELECT
        N'1.4: повторный email' AS Test,
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorText;
END CATCH;

-- В SQL Server одностолбцовое UNIQUE допускает только один NULL.
BEGIN TRY
    INSERT INTO lab6.Customer (CustomerID, Name, City, Email)
    VALUES (4, N'Второй NULL', N'Москва', NULL);
END TRY
BEGIN CATCH
    SELECT
        N'1.4: второй NULL в UNIQUE' AS Test,
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorText;
END CATCH;
GO

-- Task2.1

ALTER TABLE lab6.Customer
ADD Phone nvarchar(20) NULL;
GO

-- Task2.2

ALTER TABLE lab6.Customer
ALTER COLUMN Phone nvarchar(30) NULL;

SELECT
    N'До ALTER' AS Stage,
    COLUMN_NAME,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_SCHEMA = N'lab6'
    AND TABLE_NAME = N'Customer'
    AND COLUMN_NAME = N'Name';

ALTER TABLE lab6.Customer
ALTER COLUMN Name nvarchar(150);

-- При ALTER COLUMN без NULL/NOT NULL столбец становится допускающим NULL.
SELECT
    N'После ALTER без NOT NULL' AS Stage,
    COLUMN_NAME,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_SCHEMA = N'lab6'
    AND TABLE_NAME = N'Customer'
    AND COLUMN_NAME = N'Name';

ALTER TABLE lab6.Customer
ALTER COLUMN Name nvarchar(150) NOT NULL;
GO

-- Task2.3

INSERT INTO lab6.Customer (CustomerID, Name, City, Email)
VALUES (4, N'Анна', N'Омск', N'anna.example.com');

BEGIN TRY
    ALTER TABLE lab6.Customer WITH CHECK
    ADD CONSTRAINT CK_Customer_Email CHECK (Email LIKE N'%@%');
END TRY
BEGIN CATCH
    SELECT
        N'2.3: существующий email без @' AS Test,
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorText;
END CATCH;

UPDATE lab6.Customer
SET Email = N'anna@example.com'
WHERE CustomerID = 4;

ALTER TABLE lab6.Customer WITH CHECK
ADD CONSTRAINT CK_Customer_Email CHECK (Email LIKE N'%@%');

-- NULL LIKE ... даёт UNKNOWN. CHECK отвергает FALSE, поэтому NULL проходит.
-- Используем уже имеющегося клиента с NULL, не нарушая UQ_Customer_Email.
UPDATE lab6.Customer
SET Email = NULL
WHERE CustomerID = 3;

SELECT CustomerID, Email
FROM lab6.Customer
WHERE Email IS NULL;

-- WITH NOCHECK: исторические строки не проверяются, новые проверяются.
ALTER TABLE lab6.Customer
DROP CONSTRAINT CK_Customer_Email;

UPDATE lab6.Customer
SET Email = N'anna.example.com'
WHERE CustomerID = 4;

ALTER TABLE lab6.Customer WITH NOCHECK
ADD CONSTRAINT CK_Customer_Email CHECK (Email LIKE N'%@%');

SELECT name, is_disabled, is_not_trusted
FROM sys.check_constraints
WHERE parent_object_id = OBJECT_ID(N'lab6.Customer')
    AND name = N'CK_Customer_Email';

BEGIN TRY
    INSERT INTO lab6.Customer (CustomerID, Name, City, Email)
    VALUES (5, N'Неверный email', N'Москва', N'invalid.example.com');
END TRY
BEGIN CATCH
    SELECT
        N'2.3: NOCHECK при создании не разрешает новые неверные строки' AS Test,
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorText;
END CATCH;

-- Восстанавливаем корректные данные и доверенное ограничение.
UPDATE lab6.Customer
SET Email = N'anna@example.com'
WHERE CustomerID = 4;

ALTER TABLE lab6.Customer WITH CHECK
CHECK CONSTRAINT CK_Customer_Email;

SELECT name, is_disabled, is_not_trusted
FROM sys.check_constraints
WHERE parent_object_id = OBJECT_ID(N'lab6.Customer')
    AND name = N'CK_Customer_Email';
GO

-- Task2.4

EXEC sys.sp_rename
    @objname = N'lab6.Customer.Phone',
    @newname = N'Mobile',
    @objtype = N'COLUMN';
GO

-- sp_rename предупреждает: ссылки на старое имя в коде могут перестать работать.
ALTER TABLE lab6.Customer
DROP COLUMN Mobile;
GO

-- Task4.1
-- В методичке задача 3 отсутствует; исходная нумерация сохранена.

CREATE TABLE lab6.AuditLog (
    LogID int NOT NULL,
    Message nvarchar(100) NOT NULL,
    CONSTRAINT PK_AuditLog PRIMARY KEY (LogID)
);

INSERT INTO lab6.AuditLog (LogID, Message)
VALUES
    (1, N'Создан клиент'),
    (2, N'Создан заказ'),
    (3, N'Добавлена позиция');

DELETE FROM lab6.AuditLog;

SELECT COUNT(*) AS RemainingRows
FROM lab6.AuditLog;

-- FK из OrderLine запрещает TRUNCATE Orders, даже при ON DELETE CASCADE.
BEGIN TRY
    EXEC(N'TRUNCATE TABLE lab6.Orders;');
END TRY
BEGIN CATCH
    SELECT
        N'4.1: TRUNCATE таблицы, на которую ссылается FK' AS Test,
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorText;
END CATCH;
GO

-- Task5.1

SELECT
    p.ProductID,
    p.Name,
    p.ListPrice
FROM
    SalesLT.Product AS p
WHERE
    p.ListPrice > (
        SELECT AVG(sod.UnitPrice)
        FROM SalesLT.SalesOrderDetail AS sod
    )
ORDER BY
    p.ProductID;

-- Task5.2

SELECT
    p.ProductID,
    p.Name,
    p.ListPrice
FROM
    SalesLT.Product AS p
WHERE
    p.ListPrice >= 100
    AND p.ProductID IN (
        SELECT sod.ProductID
        FROM SalesLT.SalesOrderDetail AS sod
        WHERE sod.UnitPrice < 100
    )
ORDER BY
    p.ProductID;

-- Task5.3

SELECT
    p.ProductID,
    p.Name,
    p.StandardCost,
    p.ListPrice,
    (
        SELECT AVG(sod.UnitPrice)
        FROM SalesLT.SalesOrderDetail AS sod
        WHERE sod.ProductID = p.ProductID
    ) AS AvgSellingPrice
FROM
    SalesLT.Product AS p
ORDER BY
    p.ProductID;

-- Task5.4

SELECT
    p.ProductID,
    p.Name,
    p.StandardCost,
    p.ListPrice,
    (
        SELECT AVG(sod.UnitPrice)
        FROM SalesLT.SalesOrderDetail AS sod
        WHERE sod.ProductID = p.ProductID
    ) AS AvgSellingPrice
FROM
    SalesLT.Product AS p
WHERE
    p.StandardCost > (
        SELECT AVG(sod.UnitPrice)
        FROM SalesLT.SalesOrderDetail AS sod
        WHERE sod.ProductID = p.ProductID
    )
ORDER BY
    p.ProductID;

-- Task6.1

SELECT
    soh.SalesOrderID,
    soh.CustomerID,
    soh.TotalDue
FROM
    SalesLT.SalesOrderHeader AS soh
    CROSS APPLY [dbo].[ufnGetAllCategories]() AS ci
ORDER BY
    soh.SalesOrderID;


SELECT
    soh.SalesOrderID,
    soh.CustomerID,
    ci.FirstName,
    ci.LastName,
    soh.TotalDue
FROM
    SalesLT.SalesOrderHeader AS soh
    inner JOIN dbo.ufnGetCustomerInformation(soh.CustomerID) AS ci
    ON
        ci.CustomerID = soh.CustomerID
ORDER BY
    soh.SalesOrderID;


-- Task6.2

SELECT
    ca.CustomerID,
    ci.FirstName,
    ci.LastName,
    a.AddressLine1,
    a.City
FROM
    SalesLT.CustomerAddress AS ca
    INNER JOIN SalesLT.Address AS a
        ON ca.AddressID = a.AddressID
    CROSS APPLY dbo.ufnGetCustomerInformation(ca.CustomerID) AS ci
ORDER BY
    ca.CustomerID;
