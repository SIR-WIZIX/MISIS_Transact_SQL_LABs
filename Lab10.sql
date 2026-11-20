use AdventureWorksLT2019;
-- Task1.1

DECLARE @SalesOrderID int = 0;

IF NOT EXISTS (
    SELECT 1
    FROM SalesLT.SalesOrderHeader
    WHERE SalesOrderID = @SalesOrderID
)
BEGIN
    DECLARE @Message nvarchar(2048) =
        CONCAT(N'Заказ #', @SalesOrderID, N' не существует');

    THROW 50001, @Message, 1;
END;

DELETE FROM SalesLT.SalesOrderDetail
WHERE SalesOrderID = @SalesOrderID;

DELETE FROM SalesLT.SalesOrderHeader
WHERE SalesOrderID = @SalesOrderID;
GO

-- Task1.2

DECLARE @SalesOrderID int = 0;

BEGIN TRY
    IF NOT EXISTS (
        SELECT 1
        FROM SalesLT.SalesOrderHeader
        WHERE SalesOrderID = @SalesOrderID
    )
    BEGIN
        DECLARE @Message nvarchar(2048) =
            CONCAT(N'Заказ #', @SalesOrderID, N' не существует');

        THROW 50001, @Message, 1;
    END;

    DELETE FROM SalesLT.SalesOrderDetail
    WHERE SalesOrderID = @SalesOrderID;

    DELETE FROM SalesLT.SalesOrderHeader
    WHERE SalesOrderID = @SalesOrderID;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
GO

-- Task2.1

DECLARE @SalesOrderID int = 71774;

BEGIN TRY
    IF NOT EXISTS (
        SELECT 1
        FROM SalesLT.SalesOrderHeader
        WHERE SalesOrderID = @SalesOrderID
    )
    BEGIN
        DECLARE @Message nvarchar(2048) =
            CONCAT(N'Заказ #', @SalesOrderID, N' не существует');

        THROW 50001, @Message, 1;
    END;

    BEGIN TRANSACTION;

    DELETE FROM SalesLT.SalesOrderDetail
    WHERE SalesOrderID = @SalesOrderID;

    THROW 50002, N'Искусственная ошибка между удалениями', 1;

    DELETE FROM SalesLT.SalesOrderHeader
    WHERE SalesOrderID = @SalesOrderID;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION;
        THROW;
    END
    ELSE
        PRINT ERROR_MESSAGE();
END CATCH;
