CREATE OR ALTER PROCEDURE Bookstore.InsertOrder
    @BookstoreID     TINYINT,
    @RetailerID TINYINT,
    @Quantity   INT
AS
/***************************************************************************************************
File: InsertOrder.sql
----------------------------------------------------------------------------------------------------
Procedure:      Bookstore.InsertOrder
Create Date:    2021-03-01 (yyyy-mm-dd)
Author:         Surush Cyrus
Description:    Insert an order
Call by:        Add Hoc

Steps:          1- Check the @BookstoreID for RI issue in Bookstore.Bookstore table 
                2- Check the @RetailerID for RI issue in Bookstore.Retailer table
                3- Call SP Bookstore.GetMaxOrderID to calculate @TotalAmount
                4- Call SP Bookstore.CalTotalAmount to get @OrderID
                5- Insert to table Bookstore.[Order]

Parameter(s):   @OrderID
                @RetailerID
                @Quantity

Usage:          EXEC Bookstore.InsertOrder @BookstoreID = 1,
                                 @RetailerID = 1,
                                 @Quantity = 200
****************************************************************************************************
SUMMARY OF CHANGES
Date(yyyy-mm-dd)    Author              Comments
------------------- ------------------- ------------------------------------------------------------
****************************************************************************************************/
SET NOCOUNT ON;

DECLARE @ErrorText   VARCHAR(MAX),      
        @Message     VARCHAR(255),    
        @StartTime   DATETIME,
        @SP          VARCHAR(50),

        @OrderID     INT,
        @TotalAmount MONEY;


BEGIN TRY;   
SET @ErrorText = 'Unexpected ERROR in setting the variables!';

SET @SP = OBJECT_NAME(@@PROCID);
SET @StartTime = GETDATE();

SET @OrderID = 0;
SET @TotalAmount = 0;

SET @Message = 'Started SP ' + @SP + ' at ' + FORMAT(@StartTime , 'MM/dd/yyyy HH:mm:ss');   
RAISERROR (@Message, 0,1) WITH NOWAIT;
EXEC Bookstore.InsertHistory @SP = @SP,
   @Status = 'Start',
   @Message = @Message

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed SELECT from table Bookstore!';
-- Check to give a friendly error for RI Issue.
IF NOT EXISTS(SELECT 1
FROM Bookstore.Bookstore
WHERE BookstoreID = @BookstoreID)
BEGIN
    SET @ErrorText = 'BookstoreID = ' + CONVERT(VARCHAR(10), @BookstoreID) + ' not found in table Bookstore! This is not acceptable. Rasing Error!';
    RAISERROR(@ErrorText, 16,1);
END;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed SELECT from table Retailer!';
-- Check to give a friendly error for RI Issue.
IF NOT EXISTS(SELECT 1
FROM Bookstore.Retailer
WHERE RetailerID = @RetailerID)
BEGIN
    SET @ErrorText = 'RetailerID = ' + CONVERT(VARCHAR(10), @RetailerID) + ' not found in table Retailer! This is not acceptable. Rasing Error!';
    RAISERROR(@ErrorText, 16,1);
END;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed Calling SP GetMaxOrderID!';
EXEC Bookstore.GetMaxOrderID @MaxOrderID = @OrderID OUTPUT;

SET @Message = 'OrderID = ' + CONVERT(VARCHAR(10), @OrderID) + ' is the return value from SP Bookstore.GetMaxOrderID.';
RAISERROR (@Message, 0,1) WITH NOWAIT;
EXEC Bookstore.InsertHistory @SP = @SP,
@Status = 'Run',
@Message = @Message;

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed Calling SP CalTotalAmount!';
EXEC Bookstore.CalTotalAmount @BookstoreID = @BookstoreID,
                        @RetailerID = @RetailerID,
                        @Quantity = @Quantity,
                        @Total =  @TotalAmount OUTPUT;

SET @Message = '@TotalAmount = ' + CONVERT(VARCHAR(10), @TotalAmount) + ' is the return value from SP Bookstore.CalTotalAmount.';
RAISERROR (@Message, 0,1) WITH NOWAIT;
EXEC Bookstore.InsertHistory @SP = @SP,
                            @Status = 'Run',
                            @Message = @Message;
-------------------------------------------------------------------------------

SET @ErrorText = 'Failed INSERT to table Order!';
INSERT INTO Bookstore.[Order]
    (OrderID, BookstoreID, RetailerID, OrderDate, Quantity, TotalAmount)
VALUES
    (@OrderID, @BookstoreID, @RetailerID, GETDATE(), @Quantity, @TotalAmount)

SET @Message = CONVERT(VARCHAR(10), @@ROWCOUNT) + ' rows effected. Completed INSERT to table Order using OrderID = ' + CONVERT(VARCHAR(10), @OrderID) ;   
RAISERROR (@Message, 0,1) WITH NOWAIT;
EXEC Bookstore.InsertHistory @SP = @SP,
   @Status = 'Run',
   @Message = @Message
-------------------------------------------------------------------------------

SET @Message = 'Completed SP ' + @SP + '. Duration in minutes:  '    
      + CONVERT(VARCHAR(12), CONVERT(DECIMAL(6,2),datediff(mi, @StartTime, getdate())));    
RAISERROR (@Message, 0,1) WITH NOWAIT;    
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

