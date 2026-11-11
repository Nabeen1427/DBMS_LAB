-- EXPERIMENT 3: DDL AND DML COMMANDS
CREATE DATABASE IF NOT EXISTS Experiment3DB;
USE Experiment3DB;

-- Create Persons table with suitable data types.
DROP TABLE IF EXISTS Persons;
CREATE TABLE Persons (
    PersonID INT PRIMARY KEY,
    FirstName VARCHAR(40) NOT NULL,
    LastName VARCHAR(40),
    Age INT,
    City VARCHAR(40)
);

-- Display table structure.
DESCRIBE Persons;

-- Insert records.
INSERT INTO Persons (PersonID, FirstName, LastName, Age, City) VALUES
(1, 'Amit', 'Kumar', 21, 'Bhubaneswar'),
(2, 'Riya', 'Das', 20, 'Cuttack'),
(3, 'Rahul', 'Nayak', 22, 'Gunupur');

-- Retrieve selected columns.
SELECT PersonID, FirstName, City FROM Persons;

-- ALTER: add a column.
ALTER TABLE Persons ADD Email VARCHAR(100);

-- ALTER: modify a column.
ALTER TABLE Persons MODIFY City VARCHAR(60);

-- ALTER: drop a column.
ALTER TABLE Persons DROP COLUMN Email;

-- Create Employees so the requested rename can be demonstrated.
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50) NOT NULL,
    Department VARCHAR(40)
);
INSERT INTO Employees VALUES
(101, 'Suman', 'IT'),
(102, 'Priya', 'HR');

-- Rename Employees to Staff.
RENAME TABLE Employees TO Staff;
SELECT * FROM Staff;

-- Update an employee's department.
UPDATE Staff SET Department = 'Finance' WHERE EmployeeID = 102;
SELECT * FROM Staff;

-- Delete an employee record.
DELETE FROM Staff WHERE EmployeeID = 101;
SELECT * FROM Staff;

-- TRUNCATE removes all rows but keeps the table structure.
TRUNCATE TABLE Persons;
SELECT * FROM Persons;

-- DROP removes the table itself.
DROP TABLE Persons;
SHOW TABLES;
