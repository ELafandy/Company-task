CREATE DATABASE CompanyDB;
GO
USE CompanyDB;
GO
CREATE SCHEMA D;
GO

CREATE TABLE  D.Department (
    DNum INT PRIMARY KEY,
    DName VARCHAR(50) NOT NULL UNIQUE,
    Location VARCHAR(50)
);

CREATE TABLE D.Employee (
    SSN INT PRIMARY KEY,
    FName VARCHAR(50) NOT NULL,
    LName VARCHAR(50) NOT NULL,
    Gender VARCHAR(10) CHECK (Gender IN ('Male', 'Female')),
    BirthDate DATE DEFAULT GETDATE(),
    SuperViserSSN INT NULL,
    DNum INT,
    FOREIGN KEY (SuperViserSSN) REFERENCES D.Employee(SSN),
    FOREIGN KEY (DNum) REFERENCES D.Department(DNum)
);

CREATE TABLE D.Dependent (
    SSN INT,
    DName VARCHAR(50),
    Gender VARCHAR(10) CHECK (Gender IN ('Male', 'Female')),
    BirthDate DATE,
    PRIMARY KEY (SSN, DName),
    FOREIGN KEY (SSN) REFERENCES D.Employee(SSN)
);

CREATE TABLE D.Project (
    PNum INT PRIMARY KEY,
    PName VARCHAR(50) UNIQUE,
    City VARCHAR(50) NOT NULL,
    DNum INT,
    FOREIGN KEY (DNum) REFERENCES D.Department(DNum)
);

CREATE TABLE D.EmployeeProject (
    SSN INT,
    PNum INT,
    WorkHours INT,
    PRIMARY KEY (SSN, PNum),
    FOREIGN KEY (SSN) REFERENCES D.Employee(SSN),
    FOREIGN KEY (PNum) REFERENCES D.Project(PNum)
);

CREATE TABLE D.DepartmentManager (
    DNum INT,
    SSN INT,
    HiringDate DATE,
    PRIMARY KEY (DNum, SSN),
    FOREIGN KEY (DNum) REFERENCES D.Department(DNum),
    FOREIGN KEY (SSN) REFERENCES D.Employee(SSN)
);

INSERT INTO D.Department (DNum, DName, Location)
VALUES 
(1, 'HR', 'Cairo'),
(2, 'IT', 'Alexandria'),
(3, 'Finance', 'Giza');

INSERT INTO D.Employee (SSN, FName, LName, Gender, BirthDate, SuperViserSSN, DNum)
VALUES 
(101, 'Ahmed', 'Ali', 'Male', '1990-05-20', NULL, 1),    
(102, 'Sara', 'Mohamed', 'Female', '1992-07-15', 101, 1),  
(103, 'Omar', 'Hassan', 'Male', '1988-03-10', NULL, 2),   
(104, 'Mona', 'Ibrahim', 'Female', '1995-12-01', 103, 2), 
(105, 'Khaled', 'Youssef', 'Male', '1985-11-25', NULL, 3),
(106, 'Laila', 'Mostafa', 'Female', '1993-09-14', 101, 1), 
(107, 'Hassan', 'Omar', 'Male', '1991-02-18', 103, 2),    
(108, 'Nour', 'Said', 'Female', '1996-08-05', 105, 3),     
(109, 'Yousef', 'Adel', 'Male', '1994-04-22', 101, 1),     
(110, 'Salma', 'Fathy', 'Female', '1997-11-30', 103, 2);  

INSERT INTO D.Project (PNum, PName, City, DNum)
VALUES
(1001, 'Amazon', 'Cairo', 1),
(1002, 'Spotify', 'Alexandria', 2),
(1003, 'Accounting App', 'Giza', 3);

INSERT INTO D.EmployeeProject (SSN, PNum, WorkHours)
VALUES
(101, 1001, 20),
(102, 1001, 15),
(103, 1002, 25),
(104, 1002, 30),
(105, 1003, 10);

UPDATE D.Employee
SET DNum = 2
WHERE SSN = 105;

DELETE FROM D.Dependent
WHERE SSN = 101 AND DName = 'Ali';

SELECT *
FROM D.Employee
WHERE DNum = (
    SELECT DNum FROM D.Department WHERE DName = 'IT'
);

SELECT E.FName, E.LName, P.PName, EP.WorkHours
FROM D.EmployeeProject EP
JOIN D.Employee E ON EP.SSN = E.SSN
JOIN D.Project P ON EP.PNum = P.PNum;
