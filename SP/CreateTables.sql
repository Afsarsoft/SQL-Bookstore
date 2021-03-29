CREATE OR ALTER PROCEDURE Bookstore.CreateTables
AS
/***************************************************************************************************
File: CreateTables.sql
----------------------------------------------------------------------------------------------------
Procedure:      Bookstore.CreateTables
Create Date:    2021-03-01 (yyyy-mm-dd)
Author:         Surush Cyrus
Description:    Creates all needed Bookstore tables  
Call by:        TBD, UI, Add hoc
Steps:          NA
Parameter(s):   None
Usage:          EXEC Bookstore.CreateTables
****************************************************************************************************
SUMMARY OF CHANGES
Date(yyyy-mm-dd)    Author              Comments
------------------- ------------------- ------------------------------------------------------------
****************************************************************************************************/
SET NOCOUNT ON;

DECLARE @ErrorText VARCHAR(MAX),      
        @Message   VARCHAR(255),   
        @StartTime DATETIME,
        @SP        VARCHAR(50)

BEGIN TRY;   
SET @ErrorText = 'Unexpected ERROR in setting the variables!';  

SET @SP = OBJECT_NAME(@@PROCID)
SET @StartTime = GETDATE();    
SET @Message = 'Started SP ' + @SP + ' at ' + FORMAT(@StartTime , 'MM/dd/yyyy HH:mm:ss');  
 
RAISERROR (@Message, 0,1) WITH NOWAIT;
EXEC Bookstore.InsertHistory @SP = @SP,
    @Status = 'Start',
    @Message = @Message;


-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Bookstore.Discount.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Bookstore.Discount') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Bookstore.Discount already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
    EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message;
END
ELSE
BEGIN
    CREATE TABLE Bookstore.Discount
    (
        DiscountID TINYINT NOT NULL,
        StoreID TINYINT NOT NULL,
        Name NVARCHAR(50) NOT NULL,
        MinQuantity INT NOT NULL,
        MaxQuantity INT NOT NULL,
        Amount TINYINT NOT NULL,
        CONSTRAINT PK_Discount_DiscountID PRIMARY KEY CLUSTERED (DiscountID),
        CONSTRAINT UK_Discount_Name UNIQUE (Name)
    );

    SET @Message = 'Completed CREATE TABLE Bookstore.Discount.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
    EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Bookstore.Store.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Bookstore.Store') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Bookstore.Store already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
    EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message;
END
ELSE
BEGIN
    CREATE TABLE Bookstore.Store
    (
        StoreID TINYINT NOT NULL,
        Name NVARCHAR(50) NOT NULL,
        Address NVARCHAR(250) NOT NULL,
        CONSTRAINT PK_Store_StoreID PRIMARY KEY CLUSTERED (StoreID),
        CONSTRAINT UK_Store_Name UNIQUE (Name)
    );

    SET @Message = 'Completed CREATE TABLE Bookstore.Store.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
    EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Bookstore.Order.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Bookstore.[Order]') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Bookstore.Order already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
    EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message;
END
ELSE
BEGIN
    CREATE TABLE Bookstore.[Order]
    (
        OrderID TINYINT NOT NULL,
        StoreID TINYINT NOT NULL,
        BookID INT NOT NULL,
        OrderDate DATETIME NOT NULL,
        Quantity INT NOT NULL,
        CONSTRAINT PK_Order_OrderID_StoreID_BookID PRIMARY KEY CLUSTERED (OrderID, StoreID, BookID)
    );

    SET @Message = 'Completed CREATE TABLE Bookstore.Order.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
    EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Bookstore.Book.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Bookstore.Book') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Bookstore.Book already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
    EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message;
END
ELSE
BEGIN
    CREATE TABLE Bookstore.Book
    (
        BookID INT NOT NULL,
        TypeID TINYINT NOT NULL,
        PublisherID TINYINT NOT NULL,
        RoyaltyID TINYINT NOT NULL,
        Name NVARCHAR(50) NOT NULL,
        Price Money NOT NULL,
        Advance Money NOT NULL,
        YearToDateSales Money NOT NULL,
        PublishDate DATE NOT NULL,
        Note NVARCHAR(50) NULL
            CONSTRAINT PK_Book_BookID PRIMARY KEY CLUSTERED (BookID)
    );

    SET @Message = 'Completed CREATE TABLE Bookstore.Book.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
    EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Bookstore.BookAuthor.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Bookstore.BookAuthor') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Bookstore.BookAuthor already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
    EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message;
END
ELSE
BEGIN
    CREATE TABLE Bookstore.BookAuthor
    (
        BookID INT NOT NULL,
        AuthorID INT NOT NULL,
        RoyaltyPer Money NOT NULL,
        CONSTRAINT PK_BookAuthor_BookID_AuthorID PRIMARY KEY CLUSTERED (BookID, AuthorID)
    );

    SET @Message = 'Completed CREATE TABLE Bookstore.BookAuthor.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
    EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Bookstore.Author.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Bookstore.Author') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Bookstore.Author already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
    EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message;
END
ELSE
BEGIN
    CREATE TABLE Bookstore.Author
    (
        AuthorID INT NOT NULL,
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(50) NOT NULL,
        Address NVARCHAR(250) NOT NULL,
        Note NVARCHAR(250) NOT NULL,
        CONSTRAINT PK_Author_AuthorID PRIMARY KEY CLUSTERED (AuthorID)
    );

    SET @Message = 'Completed CREATE TABLE Bookstore.Author.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
    EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Bookstore.Royalty.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Bookstore.Royalty') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Bookstore.Royalty already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
    EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message;
END
ELSE
BEGIN
    CREATE TABLE Bookstore.Royalty
    (
        RoyaltyID TINYINT NOT NULL,
        BookID INT NOT NULL,
        Name NVARCHAR(50) NOT NULL,
        MinRange INT NOT NULL,
        MaxRange INT NOT NULL,
        CONSTRAINT PK_Royalty_RoyaltyID PRIMARY KEY CLUSTERED (RoyaltyID)
    );

    SET @Message = 'Completed CREATE TABLE Bookstore.Royalty.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
    EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Bookstore.Publisher.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Bookstore.Publisher') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Bookstore.Publisher already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
    EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message;
END
ELSE
BEGIN
    CREATE TABLE Bookstore.Publisher
    (
        PublisherID TINYINT NOT NULL,
        Name NVARCHAR(50) NOT NULL,
        Address NVARCHAR(250) NOT NULL,
        CONSTRAINT PK_Publisher_PublisherID PRIMARY KEY CLUSTERED (PublisherID),
        CONSTRAINT UK_Publisher_Name UNIQUE (Name)
    );

    SET @Message = 'Completed CREATE TABLE Bookstore.Publisher.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
    EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message
END
-------------------------------------------------------------------------------


SET @Message = 'Completed SP ' + @SP + '. Duration in minutes:  '   
   + CONVERT(VARCHAR(12), CONVERT(DECIMAL(6,2),datediff(mi, @StartTime, getdate())));   
RAISERROR(@Message, 0,1) WITH NOWAIT;
EXEC Bookstore.InsertHistory @SP = @SP,
    @Status = 'End',
    @Message = @Message

END TRY

BEGIN CATCH;
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

SET @ErrorText = 'Error: '+CONVERT(VARCHAR,ISNULL(ERROR_NUMBER(),'NULL'))      
                  +', Severity = '+CONVERT(VARCHAR,ISNULL(ERROR_SEVERITY(),'NULL'))      
                  +', State = '+CONVERT(VARCHAR,ISNULL(ERROR_STATE(),'NULL'))      
                  +', Line = '+CONVERT(VARCHAR,ISNULL(ERROR_LINE(),'NULL'))      
                  +', Procedure = '+CONVERT(VARCHAR,ISNULL(ERROR_PROCEDURE(),'NULL'))      
                  +', Server Error Message = '+CONVERT(VARCHAR(100),ISNULL(ERROR_MESSAGE(),'NULL'))      
                  +', SP Defined Error Text = '+@ErrorText;

EXEC Bookstore.InsertHistory @SP = @SP,
   @Status = 'Error',
   @Message = @ErrorText

RAISERROR(@ErrorText,18,127) WITH NOWAIT;
END CATCH;      

