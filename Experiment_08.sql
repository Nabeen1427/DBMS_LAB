-- EXPERIMENT 8: CASE STUDY - STUDENT INFORMATION SYSTEM
CREATE DATABASE IF NOT EXISTS StudentDB;
USE StudentDB;

DROP VIEW IF EXISTS ActiveEnrollmentsView;
DROP PROCEDURE IF EXISTS GetActiveEnrollments;
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Courses;

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(60) NOT NULL,
    Age INT,
    Address VARCHAR(100)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(80) NOT NULL,
    Credits INT NOT NULL,
    Capacity INT NOT NULL
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollDate DATE NOT NULL,
    Grade VARCHAR(5),
    Status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Insert five records in each table.
INSERT INTO Students VALUES
(1, 'Amit', 20, 'Gunupur'),
(2, 'Riya', 21, 'Bhubaneswar'),
(3, 'Rahul', 22, 'Cuttack'),
(4, 'Sita', 20, 'Berhampur'),
(5, 'Karan', 23, 'Puri');

INSERT INTO Courses VALUES
(101, 'DBMS', 4, 30),
(102, 'Python Programming', 3, 25),
(103, 'Data Structures', 4, 35),
(104, 'Mathematics', 3, 40),
(105, 'Computer Networks', 3, 20);

INSERT INTO Enrollments VALUES
(1001, 1, 101, '2026-07-01', 'A', 'Active'),
(1002, 2, 102, '2026-07-02', NULL, 'Active'),
(1003, 3, 103, '2026-07-03', 'B', 'Completed'),
(1004, 4, 101, '2026-07-04', NULL, 'Active'),
(1005, 5, 104, '2026-07-05', 'A', 'Completed');

-- Display all students and courses.
SELECT * FROM Students;
SELECT * FROM Courses;

-- Enrolled courses with student details.
SELECT s.StudentID, s.Name, c.CourseName, e.EnrollDate, e.Status
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
JOIN Courses c ON e.CourseID = c.CourseID;

-- Course name, student name and enrollment date.
SELECT c.CourseName, s.Name AS StudentName, e.EnrollDate
FROM Enrollments e
JOIN Courses c ON e.CourseID = c.CourseID
JOIN Students s ON e.StudentID = s.StudentID;

-- Update course capacity when a student enrolls (example: decrement remaining seats).
UPDATE Courses SET Capacity = Capacity - 1 WHERE CourseID = 101;

-- Update grade/status after course completion.
UPDATE Enrollments
SET Grade = 'A', Status = 'Completed'
WHERE EnrollmentID = 1002;

-- Increase course capacity.
UPDATE Courses SET Capacity = Capacity + 5 WHERE CourseID = 103;

-- Add Email column and drop Address column.
ALTER TABLE Students ADD Email VARCHAR(100);
UPDATE Students SET Email = CONCAT(LOWER(Name), '@example.com');
ALTER TABLE Students DROP COLUMN Address;

-- Rename Enrollments to Registrations.
RENAME TABLE Enrollments TO Registrations;

-- Add NOT NULL to Name (already NOT NULL; reaffirm the definition).
ALTER TABLE Students MODIFY Name VARCHAR(60) NOT NULL;

-- Add CHECK for valid age.
ALTER TABLE Students ADD CONSTRAINT chk_student_age CHECK (Age >= 18);

-- INNER JOIN: students with enrolled courses.
SELECT s.Name, c.CourseName
FROM Students s
INNER JOIN Registrations r ON s.StudentID = r.StudentID
INNER JOIN Courses c ON r.CourseID = c.CourseID;

-- LEFT JOIN: all students, including those without enrollment.
SELECT s.Name, c.CourseName
FROM Students s
LEFT JOIN Registrations r ON s.StudentID = r.StudentID
LEFT JOIN Courses c ON r.CourseID = c.CourseID;

-- Aggregate queries.
SELECT COUNT(*) AS TotalStudents FROM Students;
SELECT MAX(Credits) AS MaximumCredits, MIN(Credits) AS MinimumCredits FROM Courses;
SELECT COUNT(*) AS ActiveEnrollments FROM Registrations WHERE Status = 'Active';

-- View and stored procedure.
CREATE OR REPLACE VIEW ActiveEnrollmentsView AS
SELECT c.CourseName AS Course, s.Name AS Student, r.EnrollDate
FROM Registrations r
JOIN Courses c ON r.CourseID = c.CourseID
JOIN Students s ON r.StudentID = s.StudentID
WHERE r.Status = 'Active';

SELECT * FROM ActiveEnrollmentsView;

DELIMITER //
CREATE PROCEDURE GetActiveEnrollments()
BEGIN
    SELECT * FROM ActiveEnrollmentsView;
END //
DELIMITER ;

CALL GetActiveEnrollments();

-- Delete one student and one course that have no registrations.
-- Student 5 and course 105 are not referenced by Registrations.
DELETE FROM Students WHERE StudentID = 5;
DELETE FROM Courses WHERE CourseID = 105;

-- TRUNCATE requested registration data at the end because it removes all rows.
TRUNCATE TABLE Registrations;
SELECT * FROM Registrations;
