-- EXPERIMENT 1: BASICS OF MYSQL
-- MySQL 8.0+
-- Run this file in MySQL Workbench.

-- 1. Declare and display variables using SET and SELECT.
SET @student_name = 'Nabeen';
SET @student_age = 19;
SELECT @student_name AS StudentName, @student_age AS StudentAge;

-- 2. Numeric, string, and date data types.
SET @num_value = 125.75;                 -- DECIMAL-like numeric value
SET @string_value = 'MySQL Lab';         -- String value
SET @date_value = '2026-11-11';          -- DATE value
SELECT @num_value AS NumericValue,
       @string_value AS StringValue,
       CAST(@date_value AS DATE) AS DateValue;

-- 3. Arithmetic operators: +, -, *, /, %.
SELECT 20 + 5 AS Addition,
       20 - 5 AS Subtraction,
       20 * 5 AS Multiplication,
       20 / 5 AS Division,
       20 % 6 AS Modulus;

-- 4. Comparison operators: =, <, >, <=, >=, <>.
SELECT 10 = 10 AS EqualTo,
       5 < 10 AS LessThan,
       15 > 10 AS GreaterThan,
       10 <= 10 AS LessThanOrEqual,
       12 >= 10 AS GreaterThanOrEqual,
       10 <> 5 AS NotEqualTo;

-- 5. Logical operators and predicates: AND, OR, IN, BETWEEN, LIKE, NOT.
DROP TABLE IF EXISTS BasicEmployees;
CREATE TABLE BasicEmployees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(40) NOT NULL,
    Department VARCHAR(30),
    Salary DECIMAL(10,2),
    City VARCHAR(30)
);
INSERT INTO BasicEmployees VALUES
(1, 'Suman', 'IT', 25000, 'Bhubaneswar'),
(2, 'Ravi', 'HR', 18000, 'Cuttack'),
(3, 'Anita', 'IT', 32000, 'Gunupur'),
(4, 'Kamal', 'Sales', 22000, 'Berhampur'),
(5, 'Sita', 'HR', 28000, 'Puri');

SELECT * FROM BasicEmployees WHERE Department = 'IT' AND Salary > 20000;
SELECT * FROM BasicEmployees WHERE Department = 'HR' OR Salary >= 30000;
SELECT * FROM BasicEmployees WHERE Department IN ('IT', 'HR');
SELECT * FROM BasicEmployees WHERE Salary BETWEEN 20000 AND 30000;
SELECT * FROM BasicEmployees WHERE EmpName LIKE 'S%';
SELECT * FROM BasicEmployees WHERE NOT Department = 'Sales';
