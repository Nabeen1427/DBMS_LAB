-- EXPERIMENT 9: CASE STUDY - SUPERMARKET PRODUCT SALES SYSTEM
CREATE DATABASE IF NOT EXISTS SupermarketDB;
USE SupermarketDB;

DROP VIEW IF EXISTS CompletedSalesView;
DROP PROCEDURE IF EXISTS GetCompletedSales;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

-- Schema: one customer can have many sales; one product can appear in many sales.
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(80) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    StockQty INT NOT NULL,
    Category VARCHAR(40)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(80) NOT NULL,
    Phone VARCHAR(15),
    Address VARCHAR(120)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT NOT NULL,
    CustomerID INT NOT NULL,
    Quantity INT NOT NULL,
    SaleDate DATE NOT NULL,
    Status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert at least five records into each table.
INSERT INTO Products VALUES
(1, 'Rice 5kg', 350.00, 100, 'Grocery'),
(2, 'Cooking Oil 1L', 150.00, 80, 'Grocery'),
(3, 'Bath Soap', 45.00, 150, 'Personal Care'),
(4, 'Tea 500g', 220.00, 60, 'Grocery'),
(5, 'Toothpaste', 95.00, 90, 'Personal Care');

INSERT INTO Customers VALUES
(101, 'Amit Kumar', '9876543210', 'Gunupur'),
(102, 'Riya Das', '9876543211', 'Bhubaneswar'),
(103, 'Rahul Nayak', '9876543212', 'Cuttack'),
(104, 'Sita Mohanty', '9876543213', 'Puri'),
(105, 'Karan Singh', '9876543214', 'Berhampur');

INSERT INTO Sales VALUES
(1001, 1, 101, 2, '2026-10-01', 'Completed'),
(1002, 2, 102, 1, '2026-10-02', 'Completed'),
(1003, 3, 103, 4, '2026-10-03', 'Pending'),
(1004, 4, 104, 1, '2026-10-04', 'Completed'),
(1005, 5, 101, 2, '2026-10-05', 'Pending');

-- Display all products and customers.
SELECT * FROM Products;
SELECT * FROM Customers;

-- Sales with product and customer details.
SELECT sa.SaleID, p.ProductName, c.CustomerName, sa.Quantity,
       sa.SaleDate, sa.Status
FROM Sales sa
JOIN Products p ON sa.ProductID = p.ProductID
JOIN Customers c ON sa.CustomerID = c.CustomerID;

-- Product name, customer name and sale date.
SELECT p.ProductName, c.CustomerName, sa.SaleDate
FROM Sales sa
JOIN Products p ON sa.ProductID = p.ProductID
JOIN Customers c ON sa.CustomerID = c.CustomerID;

-- Update stock after a sale (apply each sale quantity).
UPDATE Products p
JOIN (SELECT ProductID, SUM(Quantity) AS SoldQty FROM Sales GROUP BY ProductID) x
  ON p.ProductID = x.ProductID
SET p.StockQty = p.StockQty - x.SoldQty;

-- Update a sale status to Completed.
UPDATE Sales SET Status = 'Completed' WHERE SaleID = 1003;

-- Increase all product prices by 10%.
UPDATE Products SET Price = Price * 1.10;

-- Add ExpiryDate; drop Address.
ALTER TABLE Products ADD ExpiryDate DATE;
ALTER TABLE Customers DROP COLUMN Address;

-- Rename Sales to Transactions.
RENAME TABLE Sales TO Transactions;

-- Add/reaffirm NOT NULL on ProductName and CHECK price > 0.
ALTER TABLE Products MODIFY ProductName VARCHAR(80) NOT NULL;
ALTER TABLE Products ADD CONSTRAINT chk_product_price CHECK (Price > 0);

-- INNER JOIN: customers and purchased products.
SELECT c.CustomerName, p.ProductName, t.Quantity, t.SaleDate
FROM Customers c
INNER JOIN Transactions t ON c.CustomerID = t.CustomerID
INNER JOIN Products p ON t.ProductID = p.ProductID;

-- LEFT JOIN: all customers, including customers without purchases.
SELECT c.CustomerName, p.ProductName, t.SaleDate
FROM Customers c
LEFT JOIN Transactions t ON c.CustomerID = t.CustomerID
LEFT JOIN Products p ON t.ProductID = p.ProductID;

-- Aggregates.
SELECT COUNT(*) AS TotalProducts FROM Products;
SELECT MAX(Price) AS MaximumPrice, MIN(Price) AS MinimumPrice FROM Products;
SELECT COUNT(*) AS CompletedSales FROM Transactions WHERE Status = 'Completed';

-- View and stored procedure.
CREATE OR REPLACE VIEW CompletedSalesView AS
SELECT p.ProductName, c.CustomerName, t.SaleDate
FROM Transactions t
JOIN Products p ON t.ProductID = p.ProductID
JOIN Customers c ON t.CustomerID = c.CustomerID
WHERE t.Status = 'Completed';

SELECT * FROM CompletedSalesView;

DELIMITER //
CREATE PROCEDURE GetCompletedSales()
BEGIN
    SELECT * FROM CompletedSalesView;
END //
DELIMITER ;

CALL GetCompletedSales();

-- Delete one customer and one product that are not referenced by transactions.
DELETE FROM Customers WHERE CustomerID = 105;
DELETE FROM Products WHERE ProductID = 5;

-- TRUNCATE requested transaction records at the end.
TRUNCATE TABLE Transactions;
SELECT * FROM Transactions;
