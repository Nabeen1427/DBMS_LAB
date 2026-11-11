-- EXPERIMENT 10: CASE STUDY - LIBRARY MANAGEMENT SYSTEM
CREATE DATABASE IF NOT EXISTS LibraryDB;
USE LibraryDB;

DROP VIEW IF EXISTS IssuedBooksView;
DROP PROCEDURE IF EXISTS GetIssuedBooks;
DROP TABLE IF EXISTS IssueReturn;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Members;

-- Schema: members and books are related through issue/return transactions.
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(120) NOT NULL,
    Author VARCHAR(80),
    PublicationYear INT,
    TotalCopies INT NOT NULL,
    AvailableCopies INT NOT NULL
);

CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    MemberName VARCHAR(80) NOT NULL,
    Phone VARCHAR(10),
    Address VARCHAR(120)
);

CREATE TABLE IssueReturn (
    TransactionID INT PRIMARY KEY,
    BookID INT NOT NULL,
    MemberID INT NOT NULL,
    IssueDate DATE NOT NULL,
    ReturnDate DATE NULL,
    ReturnStatus VARCHAR(20) DEFAULT 'Issued',
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- Insert at least five records into each table.
INSERT INTO Books VALUES
(1, 'Database System Concepts', 'Silberschatz', 2019, 10, 8),
(2, 'Python Crash Course', 'Eric Matthes', 2023, 8, 7),
(3, 'Clean Code', 'Robert Martin', 2008, 6, 5),
(4, 'Introduction to Algorithms', 'Cormen', 2022, 5, 4),
(5, 'Computer Networks', 'Tanenbaum', 2011, 7, 7);

INSERT INTO Members VALUES
(101, 'Amit Kumar', '9876543210', 'Gunupur'),
(102, 'Riya Das', '9876543211', 'Bhubaneswar'),
(103, 'Rahul Nayak', '9876543212', 'Cuttack'),
(104, 'Sita Mohanty', '9876543213', 'Puri'),
(105, 'Karan Singh', '9876543214', 'Berhampur');

INSERT INTO IssueReturn VALUES
(1001, 1, 101, '2026-10-01', NULL, 'Issued'),
(1002, 2, 102, '2026-10-02', '2026-10-08', 'Returned'),
(1003, 3, 103, '2026-10-03', NULL, 'Issued'),
(1004, 4, 104, '2026-10-04', NULL, 'Issued'),
(1005, 1, 102, '2026-10-05', '2026-10-10', 'Returned');

-- Display all books and members.
SELECT * FROM Books;
SELECT * FROM Members;

-- Books issued along with member details.
SELECT b.Title, m.MemberName, ir.IssueDate, ir.ReturnStatus
FROM IssueReturn ir
JOIN Books b ON ir.BookID = b.BookID
JOIN Members m ON ir.MemberID = m.MemberID;

-- Book title, member name and issue date.
SELECT b.Title, m.MemberName, ir.IssueDate
FROM IssueReturn ir
JOIN Books b ON ir.BookID = b.BookID
JOIN Members m ON ir.MemberID = m.MemberID;

-- Update available copies when a book is issued (example: issue book 5).
UPDATE Books SET AvailableCopies = AvailableCopies - 1 WHERE BookID = 5;

-- Update return status and return date when book is returned.
UPDATE IssueReturn
SET ReturnStatus = 'Returned', ReturnDate = CURDATE()
WHERE TransactionID = 1001;

-- Restore one available copy for the returned book.
UPDATE Books SET AvailableCopies = AvailableCopies + 1 WHERE BookID = 1;

-- Increase number of copies of a book.
UPDATE Books
SET TotalCopies = TotalCopies + 2, AvailableCopies = AvailableCopies + 2
WHERE BookID = 5;

-- Add ISBN and drop Address.
ALTER TABLE Books ADD ISBN VARCHAR(20);
UPDATE Books SET ISBN = CONCAT('ISBN-', BookID);
ALTER TABLE Members DROP COLUMN Address;

-- Rename IssueReturn to Transactions.
RENAME TABLE IssueReturn TO Transactions;

-- Add/reaffirm NOT NULL to Title.
ALTER TABLE Books MODIFY Title VARCHAR(120) NOT NULL;

-- CHECK: phone number must contain exactly 10 digits.
ALTER TABLE Members
ADD CONSTRAINT chk_member_phone CHECK (Phone REGEXP '^[0-9]{10}$');

-- INNER JOIN: members with books they have issued.
SELECT m.MemberName, b.Title, t.IssueDate, t.ReturnStatus
FROM Members m
INNER JOIN Transactions t ON m.MemberID = t.MemberID
INNER JOIN Books b ON t.BookID = b.BookID;

-- LEFT JOIN: all members, including those without issued books.
SELECT m.MemberName, b.Title, t.IssueDate
FROM Members m
LEFT JOIN Transactions t ON m.MemberID = t.MemberID
LEFT JOIN Books b ON t.BookID = b.BookID;

-- Aggregates.
SELECT COUNT(*) AS TotalBookTitles FROM Books;
SELECT MAX(PublicationYear) AS LatestPublicationYear,
       MIN(PublicationYear) AS EarliestPublicationYear
FROM Books;
SELECT COUNT(*) AS CurrentlyIssuedBooks
FROM Transactions
WHERE ReturnStatus = 'Issued';

-- View and stored procedure: currently issued books.
CREATE OR REPLACE VIEW IssuedBooksView AS
SELECT b.Title AS BookTitle, m.MemberName, t.IssueDate
FROM Transactions t
JOIN Books b ON t.BookID = b.BookID
JOIN Members m ON t.MemberID = m.MemberID
WHERE t.ReturnStatus = 'Issued';

SELECT * FROM IssuedBooksView;

DELIMITER //
CREATE PROCEDURE GetIssuedBooks()
BEGIN
    SELECT * FROM IssuedBooksView;
END //
DELIMITER ;

CALL GetIssuedBooks();

-- Delete one member and one book with no transaction references.
DELETE FROM Members WHERE MemberID = 105;
DELETE FROM Books WHERE BookID = 5;

-- TRUNCATE requested transaction records at the end.
TRUNCATE TABLE Transactions;
SELECT * FROM Transactions;
