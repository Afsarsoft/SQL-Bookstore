/***************************************************************************************************
File: 03_InsertTables.sql
----------------------------------------------------------------------------------------------------
Create Date:    2020-09-01 (yyyy-mm-dd)
Author:         Surush Cyrus
Description:    Inserts needed rows to few tables 
Call by:        TBD, Add hoc
Steps:          N/A 
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

SET @SP = 'Script-03_InsertTables';
SET @StartTime = GETDATE();

SET @Message = 'Started SP ' + @SP + ' at ' + FORMAT(@StartTime , 'MM/dd/yyyy HH:mm:ss');   
RAISERROR (@Message, 0,1) WITH NOWAIT;
EXEC Bookstore.InsertHistory @SP = @SP,
   @Status = 'Start',
   @Message = @Message;

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed INSERT to table Publisher!';
INSERT INTO Bookstore.Publisher
   (PublisherID, Name, Address)
VALUES
   (01, 'Publisher 01', 'Publisher 01 Adress, TBD'),
   (02, 'Publisher 02', 'Publisher 02 Adress, TBD'),
   (03, 'Publisher 03', 'Publisher 03 Adress, TBD')

SET @Message = CONVERT(VARCHAR(10), @@ROWCOUNT) + ' rows effected. Completed INSERT to table Publisher';   
RAISERROR (@Message, 0,1) WITH NOWAIT;
EXEC Bookstore.InsertHistory @SP = @SP,
   @Status = 'Run',
   @Message = @Message;
-------------------------------------------------------------------------------


SET @Message = 'Completed SP ' + @SP + '. Duration in minutes:  '   
   + CONVERT(VARCHAR(12), CONVERT(DECIMAL(6,2),datediff(mi, @StartTime, getdate())));    
RAISERROR(@Message, 0,1) WITH NOWAIT;
EXEC Bookstore.InsertHistory @SP = @SP,
   @Status = 'End',
   @Message = @Message;

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
   @Message = @ErrorText;

RAISERROR(@ErrorText,18,127) WITH NOWAIT;
END CATCH;      
