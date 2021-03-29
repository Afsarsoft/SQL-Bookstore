
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
