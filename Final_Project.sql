-- Create Database
CREATE DATABASE IF NOT EXISTS UniversityDB;
USE UniversityDB;

-- =============================
-- 1. STUDENTS TABLE
-- =============================
CREATE TABLE IF NOT EXISTS Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    BirthDate DATE,
    EnrollmentDate DATE
);

INSERT INTO Students VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2000-01-15', '2022-08-01'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '1999-05-25', '2021-08-01');

-- =============================
-- 2. DEPARTMENTS TABLE
-- =============================
CREATE TABLE IF NOT EXISTS Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

INSERT INTO Departments VALUES
(1, 'Computer Science'),
(2, 'Mathematics');

-- =============================
-- 3. COURSES TABLE
-- =============================
CREATE TABLE IF NOT EXISTS Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    DepartmentID INT,
    Credits INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Courses VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 2, 4);

-- =============================
-- 4. INSTRUCTORS TABLE
-- =============================
CREATE TABLE IF NOT EXISTS Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Instructors VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@univ.com', 1),
(2, 'Bob', 'Lee', 'bob.lee@univ.com', 2);

-- =============================
-- 5. ENROLLMENTS TABLE
-- =============================
CREATE TABLE IF NOT EXISTS Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Enrollments VALUES
(1, 1, 101, '2022-08-01'),
(2, 2, 102, '2021-08-01');

-- =============================
-- QUERIES
-- =============================

-- 1. CRUD Example
SELECT * FROM Students;
UPDATE Students SET FirstName = 'Johnny' WHERE StudentID = 1;
DELETE FROM Students WHERE StudentID = 2;

-- 2. Students enrolled after 2022
SELECT * FROM Students
WHERE EnrollmentDate > '2022-01-01';

-- 3. Courses from Mathematics dept (limit 5)
SELECT * FROM Courses
WHERE DepartmentID = 2
LIMIT 5;

-- 4. Courses with more than 5 students
SELECT CourseID, COUNT(StudentID) AS TotalStudents
FROM Enrollments
GROUP BY CourseID
HAVING COUNT(StudentID) > 5;

-- 5. Students in BOTH courses
SELECT StudentID
FROM Enrollments
WHERE CourseID IN (101,102)
GROUP BY StudentID
HAVING COUNT(DISTINCT CourseID) = 2;

-- 6. Students in ANY of two courses
SELECT DISTINCT StudentID
FROM Enrollments
WHERE CourseID IN (101,102);

-- 7. Average credits
SELECT AVG(Credits) FROM Courses;

-- 8. Max salary (Note: no salary column → skip OR assume)
-- ALTER if needed

-- 9. Students per department
SELECT d.DepartmentName, COUNT(e.StudentID)
FROM Departments d
JOIN Courses c ON d.DepartmentID = c.DepartmentID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY d.DepartmentName;

-- 10. INNER JOIN
SELECT s.*, c.CourseName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

-- 11. LEFT JOIN
SELECT s.*, c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;

-- 12. Subquery (>10 students)
SELECT StudentID FROM Enrollments
WHERE CourseID IN (
    SELECT CourseID FROM Enrollments
    GROUP BY CourseID
    HAVING COUNT(StudentID) > 10
);

-- 13. Extract year
SELECT StudentID, YEAR(EnrollmentDate) FROM Students;

-- 14. Instructor full name
SELECT CONCAT(FirstName, ' ', LastName) AS FullName
FROM Instructors;

-- 15. Running total students
SELECT CourseID,
       COUNT(StudentID) OVER (ORDER BY CourseID) AS RunningTotal
FROM Enrollments;

-- 16. Senior / Junior
SELECT StudentID,
CASE
    WHEN TIMESTAMPDIFF(YEAR, EnrollmentDate, CURDATE()) > 4 THEN 'Senior'
    ELSE 'Junior'
END AS Status
FROM Students;
