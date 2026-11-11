-- EXPERIMENT 6: SQL FUNCTIONS IN EMPLOYEE MANAGEMENT SYSTEM
CREATE DATABASE IF NOT EXISTS Experiment6DB;
USE Experiment6DB;

DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(60) NOT NULL,
    Designation VARCHAR(40),
    Department VARCHAR(40),
    Salary DECIMAL(10,2),
    JoiningDate DATE
);

INSERT INTO Employee VALUES
(1, 'Amit Kumar', 'Developer', 'IT', 32500.75, '2021-04-12'),
(2, 'Riya Das', 'Analyst', 'Finance', 28750.40, '2022-08-20'),
(3, 'Rahul Nayak', 'Manager', 'IT', 45800.90, '2019-02-15'),
(4, 'Sita Mohanty', 'Clerk', 'HR', 19500.25, '2023-01-05'),
(5, 'Karan Singh', 'Developer', 'IT', 36200.60, '2020-11-10');

-- UPPER() and LOWER().
SELECT EmpName, UPPER(EmpName) AS UpperName, LOWER(EmpName) AS LowerName
FROM Employee;

-- LENGTH().
SELECT EmpName, LENGTH(EmpName) AS NameLength FROM Employee;

-- CONCAT().
SELECT CONCAT(EmpName, ' - ', Designation) AS EmployeeDetails FROM Employee;

-- SUBSTRING(): first three characters.
SELECT EmpName, SUBSTRING(EmpName, 1, 3) AS FirstThreeCharacters FROM Employee;

-- ROUND().
SELECT EmpName, Salary, ROUND(Salary) AS RoundedSalary FROM Employee;

-- ABS(): difference from a sample reference salary.
SELECT EmpName, Salary, ABS(Salary - 30000) AS AbsoluteDifferenceFrom30000
FROM Employee;

-- Current date and time.
SELECT CURDATE() AS CurrentDate, NOW() AS CurrentDateTime;

-- DATEDIFF(): years of service (completed years approximation).
SELECT EmpName, JoiningDate,
       FLOOR(DATEDIFF(CURDATE(), JoiningDate) / 365.25) AS YearsOfService
FROM Employee;

-- Aggregate functions.
SELECT COUNT(*) AS TotalEmployees,
       MAX(Salary) AS MaximumSalary,
       MIN(Salary) AS MinimumSalary,
       AVG(Salary) AS AverageSalary,
       SUM(Salary) AS TotalSalary
FROM Employee;

-- Department-wise salary summary.
SELECT Department, COUNT(*) AS EmployeeCount,
       SUM(Salary) AS TotalSalary, AVG(Salary) AS AverageSalary
FROM Employee
GROUP BY Department;
