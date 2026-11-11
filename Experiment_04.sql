-- EXPERIMENT 4: SQL FILTERING OPERATORS
CREATE DATABASE IF NOT EXISTS Experiment4DB;
USE Experiment4DB;

DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50) NOT NULL,
    Designation VARCHAR(40),
    Department VARCHAR(30),
    Salary DECIMAL(10,2) NULL
);

INSERT INTO Employee VALUES
(1, 'SUMAN', 'Manager', 'IT', 45000),
(2, 'RAVI', 'Developer', 'IT', 25000),
(3, 'SURESH', 'Accountant', 'Finance', 18000),
(4, 'ALLEN', 'Developer', 'IT', 30000),
(5, 'KIRAN', 'Clerk', 'HR', 12000),
(6, 'RAJ', 'Manager', 'Sales', 35000),
(7, 'ANURAG', 'Analyst', 'Finance', NULL),
(8, 'SALLU', 'Assistant', 'HR', 15000),
(9, 'PETER', 'Developer', 'IT', 28000),
(10, 'KUMAR', 'Clerk', 'Sales', 10000);

-- BETWEEN and NOT BETWEEN.
SELECT * FROM Employee WHERE Salary BETWEEN 10000 AND 30000;
SELECT * FROM Employee WHERE Salary NOT BETWEEN 10000 AND 30000;

-- IN and NOT IN.
SELECT * FROM Employee WHERE Designation IN ('Manager', 'Developer');
SELECT * FROM Employee WHERE Designation NOT IN ('Manager', 'Developer');

-- NULL and NOT NULL.
SELECT * FROM Employee WHERE Salary IS NULL;
SELECT * FROM Employee WHERE Salary IS NOT NULL;

-- LIKE patterns.
SELECT * FROM Employee WHERE EmpName LIKE 'S%';     -- starts with S
SELECT * FROM Employee WHERE EmpName LIKE '%R';     -- ends with R
SELECT * FROM Employee WHERE EmpName LIKE '%U%';    -- contains U
SELECT * FROM Employee WHERE EmpName LIKE '%A%';    -- contains A
SELECT * FROM Employee WHERE EmpName LIKE '%LL%';   -- contains LL
SELECT * FROM Employee WHERE EmpName LIKE '%E%';    -- contains E

-- Relational operators.
SELECT * FROM Employee WHERE Salary = 25000;
SELECT * FROM Employee WHERE Salary != 25000;
SELECT * FROM Employee WHERE Salary > 20000;
SELECT * FROM Employee WHERE Salary < 20000;
SELECT * FROM Employee WHERE Salary >= 25000;
SELECT * FROM Employee WHERE Salary <= 25000;

-- Logical operators.
SELECT * FROM Employee WHERE Designation = 'Developer' AND Salary >= 25000;
SELECT * FROM Employee WHERE Designation = 'Manager' OR Salary < 15000;

-- ORDER BY ascending and descending.
SELECT * FROM Employee ORDER BY EmpName ASC;
SELECT * FROM Employee ORDER BY EmpName DESC;

-- DISTINCT designations.
SELECT DISTINCT Designation FROM Employee;

-- GROUP BY and HAVING.
SELECT Department, COUNT(*) AS EmployeeCount, AVG(Salary) AS AverageSalary
FROM Employee
GROUP BY Department
HAVING COUNT(*) >= 2;

-- DELETE employees whose names match a pattern.
-- This example deletes names containing 'LL' (ALLEN and SALLU).
DELETE FROM Employee WHERE EmpName LIKE '%LL%';

-- Update salaries for employees whose names start with R.
UPDATE Employee SET Salary = Salary * 1.10 WHERE EmpName LIKE 'R%';

-- Arithmetic salary calculations.
SELECT EmpName, Salary,
       Salary + Salary * 0.10 AS SalaryWith10PercentBonus,
       Salary - Salary * 0.05 AS SalaryAfter5PercentTax,
       Salary * 2 AS DoubleSalary
FROM Employee
WHERE Salary IS NOT NULL;
