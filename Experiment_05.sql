-- EXPERIMENT 5: SQL CONSTRAINTS
-- CHECK constraints are enforced in MySQL 8.0.16 and later.
CREATE DATABASE IF NOT EXISTS Experiment5DB;
USE Experiment5DB;

DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;

-- 1. Department table with PRIMARY KEY.
CREATE TABLE Department (
    DeptID INT,
    DeptName VARCHAR(50) NOT NULL,
    CONSTRAINT pk_department PRIMARY KEY (DeptID)
);

-- 2. Employee table with PRIMARY KEY, NOT NULL, UNIQUE and DEFAULT.
CREATE TABLE Employee (
    EmpID INT,
    EmpName VARCHAR(60) NOT NULL,
    Email VARCHAR(100),
    Salary DECIMAL(10,2) DEFAULT 20000.00,
    JoiningDate DATE DEFAULT (CURRENT_DATE),
    MobileNumber VARCHAR(10),
    DeptID INT,
    CONSTRAINT pk_employee PRIMARY KEY (EmpID),
    CONSTRAINT uq_employee_email UNIQUE (Email)
);

-- 3. Add FOREIGN KEY using ALTER TABLE.
ALTER TABLE Employee
ADD CONSTRAINT fk_employee_department
FOREIGN KEY (DeptID) REFERENCES Department(DeptID);

-- 4. Add CHECK constraint on Salary.
ALTER TABLE Employee
ADD CONSTRAINT chk_employee_salary CHECK (Salary >= 5000);

-- 5. Add UNIQUE constraint on Mobile Number.
ALTER TABLE Employee
ADD CONSTRAINT uq_employee_mobile UNIQUE (MobileNumber);

-- 6. Insert valid records.
INSERT INTO Department VALUES
(10, 'IT'), (20, 'HR'), (30, 'Finance');

INSERT INTO Employee (EmpID, EmpName, Email, Salary, JoiningDate, MobileNumber, DeptID) VALUES
(1, 'Amit', 'amit@example.com', 30000, '2024-06-10', '9876543210', 10),
(2, 'Riya', 'riya@example.com', 25000, '2025-01-15', '9876543211', 20),
(3, 'Rahul', 'rahul@example.com', DEFAULT, DEFAULT, '9876543212', 10);

SELECT * FROM Department;
SELECT * FROM Employee;

-- 7. Constraint violation demonstrations.
-- Run each statement separately (uncomment one at a time) to see its error.
-- Duplicate PRIMARY KEY:
-- INSERT INTO Employee (EmpID, EmpName, Email, MobileNumber, DeptID) VALUES
-- (1, 'Duplicate ID', 'dup1@example.com', '9000000001', 10);
-- FOREIGN KEY violation (DeptID 99 does not exist):
-- INSERT INTO Employee (EmpID, EmpName, Email, MobileNumber, DeptID) VALUES
-- (4, 'Wrong Dept', 'wrongdept@example.com', '9000000002', 99);
-- UNIQUE violation (duplicate email):
-- INSERT INTO Employee (EmpID, EmpName, Email, MobileNumber, DeptID) VALUES
-- (5, 'Duplicate Email', 'amit@example.com', '9000000003', 10);
-- NOT NULL violation:
-- INSERT INTO Employee (EmpID, EmpName, Email, MobileNumber, DeptID) VALUES
-- (6, NULL, 'nullname@example.com', '9000000004', 10);
-- CHECK violation (salary below 5000):
-- INSERT INTO Employee (EmpID, EmpName, Email, Salary, MobileNumber, DeptID) VALUES
-- (7, 'Low Salary', 'low@example.com', 1000, '9000000005', 10);
-- UNIQUE mobile violation:
-- INSERT INTO Employee (EmpID, EmpName, Email, MobileNumber, DeptID) VALUES
-- (8, 'Duplicate Mobile', 'mobile@example.com', '9876543210', 10);

-- 8. Modify a DEFAULT value.
ALTER TABLE Employee ALTER COLUMN Salary SET DEFAULT 22000.00;

-- 9. Drop a constraint (optional): remove the salary CHECK constraint.
ALTER TABLE Employee DROP CHECK chk_employee_salary;

SHOW CREATE TABLE Employee;
