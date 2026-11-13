use AdventureWorksLT2019;
-- Task1.1

IF OBJECT_ID(N'SalesLT.SalesOrderNumber', N'SO') IS NULL
BEGIN
    DECLARE @NextOrderID int = (
        SELECT ISNULL(MAX(SalesOrderID), 0) + 1
        FROM SalesLT.SalesOrderHeader
    );
    DECLARE @SequenceSQL nvarchar(300) =
        N'CREATE SEQUENCE SalesLT.SalesOrderNumber AS int START WITH '
        + CAST(@NextOrderID AS nvarchar(20)) + N' INCREMENT BY 1;';

    EXEC sys.sp_executesql @SequenceSQL;
END;
GO

DECLARE @OrderDate date = CAST(GETDATE() AS date);
DECLARE @DueDate date = DATEADD(DAY, 7, @OrderDate);
DECLARE @CustomerID int = 1;
DECLARE @SalesOrderID int = NEXT VALUE FOR SalesLT.SalesOrderNumber;

IF COLUMNPROPERTY(OBJECT_ID(N'SalesLT.SalesOrderHeader'), N'SalesOrderID', 'IsIdentity') = 1
    SET IDENTITY_INSERT SalesLT.SalesOrderHeader ON;

INSERT INTO SalesLT.SalesOrderHeader (
    SalesOrderID,
    OrderDate,
    DueDate,
    CustomerID,
    ShipMethod
)
VALUES (
    @SalesOrderID,
    @OrderDate,
    @DueDate,
    @CustomerID,
    N'CARGO TRANSPORT 5'
);

IF COLUMNPROPERTY(OBJECT_ID(N'SalesLT.SalesOrderHeader'), N'SalesOrderID', 'IsIdentity') = 1
    SET IDENTITY_INSERT SalesLT.SalesOrderHeader OFF;

PRINT CONCAT(N'SalesOrderID: ', @SalesOrderID);

-- Task1.2

DECLARE @OrderID int = @SalesOrderID;
DECLARE @ProductID int = 760;
DECLARE @Quantity smallint = 1;
DECLARE @UnitPrice money = 782.99;

IF EXISTS (
    SELECT 1
    FROM SalesLT.SalesOrderHeader
    WHERE SalesOrderID = @OrderID
)
BEGIN
    INSERT INTO SalesLT.SalesOrderDetail (
        SalesOrderID,
        ProductID,
        OrderQty,
        UnitPrice
    )
    VALUES (
        @OrderID,
        @ProductID,
        @Quantity,
        @UnitPrice
    );
END
ELSE
    PRINT N'Заказ не существует';

SET @OrderID = 0;

IF EXISTS (
    SELECT 1
    FROM SalesLT.SalesOrderHeader
    WHERE SalesOrderID = @OrderID
)
BEGIN
    INSERT INTO SalesLT.SalesOrderDetail (
        SalesOrderID,
        ProductID,
        OrderQty,
        UnitPrice
    )
    VALUES (
        @OrderID,
        @ProductID,
        @Quantity,
        @UnitPrice
    );
END
ELSE
    PRINT N'Заказ не существует';
GO

-- Task2.1

DECLARE @MarketAverage money = 2000;
DECLARE @MaximumAllowed money = 5000;
DECLARE @AveragePrice money;
DECLARE @MaximumPrice money;

SELECT
    @AveragePrice = AVG(p.ListPrice),
    @MaximumPrice = MAX(p.ListPrice)
FROM
    SalesLT.Product AS p
    INNER JOIN SalesLT.vGetAllCategories AS cat
        ON p.ProductCategoryID = cat.ProductCategoryID
WHERE
    cat.ParentProductCategoryName = N'Bikes';

WHILE @AveragePrice < @MarketAverage
BEGIN
    UPDATE p
    SET ListPrice = p.ListPrice * 1.1
    FROM
        SalesLT.Product AS p
        INNER JOIN SalesLT.vGetAllCategories AS cat
            ON p.ProductCategoryID = cat.ProductCategoryID
    WHERE
        cat.ParentProductCategoryName = N'Bikes';

    SELECT
        @AveragePrice = AVG(p.ListPrice),
        @MaximumPrice = MAX(p.ListPrice)
    FROM
        SalesLT.Product AS p
        INNER JOIN SalesLT.vGetAllCategories AS cat
            ON p.ProductCategoryID = cat.ProductCategoryID
    WHERE
        cat.ParentProductCategoryName = N'Bikes';

    IF @MaximumPrice >= @MaximumAllowed
        BREAK;
END;

PRINT CONCAT(N'Новая средняя цена на велосипед: ', @AveragePrice);
PRINT CONCAT(N'Новая максимальная цена велосипеда: ', @MaximumPrice);
