CREATE OR ALTER PROCEDURE Bookstore.CreateFKs
AS
/***************************************************************************************************
File: CreateFKs.sql
----------------------------------------------------------------------------------------------------
Procedure:      Bookstore.CreateFKs
Create Date:    2021-03-01 (yyyy-mm-dd)
Author:         Surush Cyrus
Description:    Creates FKs for all needed Bookstore tables  
Call by:        TBD, UI, Add hoc
Steps:          NA
Parameter(s):   None
Usage:          EXEC Bookstore.CreateFKs
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
SET @ErrorText = 'Failed adding FOREIGN KEY for Table Bookstore.Discount.';

IF EXISTS (SELECT *
FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'Bookstore.FK_Discount_Store_StoreID')
   AND parent_object_id = OBJECT_ID(N'Bookstore.Discount')
)
BEGIN
   SET @Message = 'FOREIGN KEY for Table Bookstore.Discount already exist, skipping....';
   RAISERROR(@Message, 0,1) WITH NOWAIT;
   EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message;
END
ELSE
BEGIN
   ALTER TABLE Bookstore.Discount
   ADD CONSTRAINT FK_Discount_Store_StoreID FOREIGN KEY (StoreID)
      REFERENCES Bookstore.Store (StoreID);

   SET @Message = 'Completed adding FOREIGN KEY for TABLE Bookstore.Discount.';
   RAISERROR(@Message, 0,1) WITH NOWAIT;
   EXEC Bookstore.InsertHistory @SP = @SP,
   @Status = 'Run',
   @Message = @Message;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed adding FOREIGN KEY for Table Bookstore.Book.';

IF EXISTS (SELECT *
FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'Bookstore.FK_Book_Royalty_RoyaltyID')
   AND parent_object_id = OBJECT_ID(N'Bookstore.Book')
)
BEGIN
   SET @Message = 'FOREIGN KEY for Table Bookstore.Book already exist, skipping....';
   RAISERROR(@Message, 0,1) WITH NOWAIT;
   EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message;
END
ELSE
BEGIN
   ALTER TABLE Bookstore.Book
   ADD CONSTRAINT FK_Book_Publisher_PublisherID FOREIGN KEY (PublisherID)
      REFERENCES Bookstore.Publisher (PublisherID);

   SET @Message = 'Completed adding FOREIGN KEY for TABLE Bookstore.Book.';
   RAISERROR(@Message, 0,1) WITH NOWAIT;
   EXEC Bookstore.InsertHistory @SP = @SP,
   @Status = 'Run',
   @Message = @Message;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed adding FOREIGN KEY for Table Bookstore.Order.';

IF EXISTS (SELECT *
FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'Bookstore.FK_Order_Store_StoreID')
   AND parent_object_id = OBJECT_ID(N'Bookstore.Order')
)
BEGIN
   SET @Message = 'FOREIGN KEY for Table Bookstore.Order already exist, skipping....';
   RAISERROR(@Message, 0,1) WITH NOWAIT;
   EXEC Bookstore.InsertHistory @SP = @SP,
   @Status = 'Run',
   @Message = @Message;
END
ELSE
BEGIN
   ALTER TABLE Bookstore.[Order]
   ADD CONSTRAINT FK_Order_Store_StoreID FOREIGN KEY (StoreID)
      REFERENCES Bookstore.Store (StoreID),
    CONSTRAINT FK_Order_Book_BookID FOREIGN KEY (BookID)
      REFERENCES Bookstore.Book (BookID);

   SET @Message = 'Completed adding FOREIGN KEY for TABLE Bookstore.Order.';
   RAISERROR(@Message, 0,1) WITH NOWAIT;
   EXEC Bookstore.InsertHistory @SP = @SP,
   @Status = 'Run',
   @Message = @Message;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed adding FOREIGN KEY for Table Bookstore.BookAuthor.';

IF EXISTS (SELECT *
FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'Bookstore.FK_BookAuthor_Book_BookID')
   AND parent_object_id = OBJECT_ID(N'Bookstore.BookAuthor')
)
BEGIN
   SET @Message = 'FOREIGN KEY for Table Bookstore.BookAuthor already exist, skipping....';
   RAISERROR(@Message, 0,1) WITH NOWAIT;
   EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message;
END
ELSE
BEGIN
   ALTER TABLE Bookstore.BookAuthor
   ADD CONSTRAINT FK_BookAuthor_Book_BookID FOREIGN KEY (BookID)
      REFERENCES Bookstore.Book (BookID),
    CONSTRAINT FK_BookAuthor_Author_AuthorID FOREIGN KEY (AuthorID)
      REFERENCES Bookstore.Author (AuthorID);

   SET @Message = 'Completed adding FOREIGN KEY for TABLE Bookstore.BookAuthor.';
   RAISERROR(@Message, 0,1) WITH NOWAIT;
   EXEC Bookstore.InsertHistory @SP = @SP,
   @Status = 'Run',
   @Message = @Message;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed adding FOREIGN KEY for Table Bookstore.Royalty.';

IF EXISTS (SELECT *
FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'Bookstore.FK_Royalty_Book_BookID')
   AND parent_object_id = OBJECT_ID(N'Bookstore.Royalty')
)
BEGIN
   SET @Message = 'FOREIGN KEY for Table Bookstore.Royalty already exist, skipping....';
   RAISERROR(@Message, 0,1) WITH NOWAIT;
   EXEC Bookstore.InsertHistory @SP = @SP,
        @Status = 'Run',
        @Message = @Message;
END
ELSE
BEGIN
   ALTER TABLE Bookstore.Royalty
   ADD CONSTRAINT FK_Royalty_Book_BookID FOREIGN KEY (BookID)
      REFERENCES Bookstore.Book (BookID);

   SET @Message = 'Completed adding FOREIGN KEY for TABLE Bookstore.Royalty.';
   RAISERROR(@Message, 0,1) WITH NOWAIT;
   EXEC Bookstore.InsertHistory @SP = @SP,
   @Status = 'Run',
   @Message = @Message;
END
-------------------------------------------------------------------------------

SET @Message = 'Completed SP ' + @SP + '. Duration in minutes:  '   
   + CONVERT(VARCHAR(12), CONVERT(DECIMAL(6,2),datediff(mi, @StartTime, getdate())));    
RAISERROR(@Message, 0,1) WITH NOWAIT;
EXEC Bookstore.InsertHistory @SP = @SP,
   @Status = 'End',
   @Message = @Message

END
TRY

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

