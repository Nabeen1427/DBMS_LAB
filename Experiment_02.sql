-- EXPERIMENT 2: SQL COMMANDS
-- IMPORTANT: MySQL does not provide RENAME DATABASE.
-- For an empty database, the practical equivalent is to create the new database
-- name and then drop the old one. For databases containing tables/data, create
-- the destination database and move/recreate tables with CREATE TABLE ... LIKE
-- and INSERT ... SELECT, then verify before dropping the source.

-- TASK 1
CREATE DATABASE IF NOT EXISTS EmployeeDB;
USE EmployeeDB;

-- MySQL rename-database workaround (database is empty in this experiment).
CREATE DATABASE IF NOT EXISTS CompanyEmployeeDB;
DROP DATABASE EmployeeDB;

-- Drop the destination as required by the experiment.
DROP DATABASE CompanyEmployeeDB;

-- TASK 2
CREATE DATABASE IF NOT EXISTS ProductStoreDB;
USE ProductStoreDB;

-- MySQL rename-database workaround (database is empty in this experiment).
CREATE DATABASE IF NOT EXISTS RetailProductDB;
DROP DATABASE ProductStoreDB;

-- Drop the destination as required by the experiment.
DROP DATABASE RetailProductDB;

-- Verify that the databases have been dropped.
SHOW DATABASES;
