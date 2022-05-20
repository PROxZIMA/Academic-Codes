-- 2021-11-05 17:42:19.558104
use dbmsl;

-- 2021-11-05 17:42:54.409250
SELECT * FROM areas;

-- 2021-11-05 17:45:33.212607
use dbmsl;

-- 2021-11-05 17:45:35.940914
SELECT * FROM areas;

-- 2021-11-05 17:46:15.446043
use SELECT * FROM areas;

-- 2021-11-05 17:46:26.657465
use dbmsl; SELECT * FROM areas;

CREATE TABLE employee (empID INTEGER PRIMARY KEY, empName VARCHAR(255) UNIQUE, department VARCHAR(255), empExp FLOAT,   salary FLOAT NOT NULL );

-- 2021-11-05 22:10:39.626478
SHOW GLOBAL VARIABLES LIKE 'PORT';

-- 2021-11-05 22:36:16.628367
SHOW DATABASES;

-- 2021-11-06 14:18:21.371018
use dbmsl; SELECT * FROM areas;

-- 2021-11-06 16:15:57.871391
use dbmsl;

-- 2021-11-06 16:32:56.677576
CREATE TABLE employee (e_no int NOT NULL primary key comment 'primary key',     e_name VARCHAR(255) UNIQUE COMMENT 'employee name',     address VARCHAR(255) COMMENT 'employee address',     basic_salary FLOAT NOT NULL comment 'employee salary',     job_status VARCHAR(255) COMMENT 'job status' ) default charset utf8 comment '';

-- 2021-11-06 16:33:59.371271
DROP TABLE employee;

-- 2021-11-06 16:37:47.231557
use dbmsl;

-- 2021-11-06 16:39:05.304635
CREATE TABLE library (ISBN VARCHAR(50) PRIMARY KEY, name VARCHAR(255), author VARCHAR(255), publisher VARCHAR(255), yearOfPublication INTEGER, cost FLOAT NOT NULL );

-- 2021-11-06 16:40:05.905034
DROP TABLE library;

-- 2021-11-06 16:41:16.276506
use dbmsl;

-- 2021-11-06 16:41:20.657659
CREATE TABLE library (ISBN VARCHAR(50) PRIMARY KEY, name VARCHAR(255), author VARCHAR(255), publisher VARCHAR(255), yearOfPublication INTEGER, cost FLOAT NOT NULL );

-- 2021-11-06 16:41:27.727487
INSERT INTO library VALUES ('9874133548', 'Only Time Will Tell', 'Jeffery Archer', 'PAN', 2011, 562.45), ('9784157165', 'Midnights Children', 'Salman Rushdie', 'VINTAGE', 2013, 452.25), ('9457154812', 'Revolution 2020', 'Jeffery Archer', 'RUPA', 2011, 842.75);

-- 2021-11-06 16:41:38.710701
INSERT INTO library VALUES ('9421548465', 'The Old Man And His God', 'Sudha Murty', 'PENGUIN', 2006, 170.45);

-- 2021-11-06 16:41:58.934749
SELECT * from library;

-- 2021-11-06 16:42:23.483870
ALTER TABLE library ADD Department VARCHAR(255);

-- 2021-11-06 16:42:29.283572
SELECT * from library;

-- 2021-11-06 16:44:30.738753
ALTER TABLE library DROP COLUMN Department;

-- 2021-11-06 16:44:35.096477
SELECT * from library;

-- 2021-11-06 16:44:45.209262
UPDATE library SET cost=325.25 where cost=452.25;

-- 2021-11-06 16:44:54.493339
SELECT distinct cost from library;

-- 2021-11-06 16:45:22.587967
SELECT * FROM library ORDER BY name;

-- 2021-11-06 16:45:29.275746
SELECT * FROM library ORDER BY name DESC;

-- 2021-11-06 16:45:39.012102
SELECT * FROM library WHERE name LIKE 'Onl%';

-- 2021-11-06 16:47:32.653516
UPDATE library SET author='Chetan Bhagat' where name='Revolution 2020';

-- 2021-11-06 16:47:39.248374
SELECT * FROM library;

-- 2021-11-06 16:48:05.503440
SELECT * FROM library WHERE cost BETWEEN 200 and 700;

-- 2021-11-06 16:53:56.251336
/* PART : 2
1> Set Operations
2> SQL Operators
3> Aggeregate Functions */
;

-- 2021-11-06 16:54:06.190463
CREATE TABLE employee (e_no int NOT NULL primary key comment 'primary key', e_name VARCHAR(255) UNIQUE COMMENT 'employee name', address VARCHAR(255) COMMENT 'employee address', basic_salary FLOAT NOT NULL comment 'employee salary', job_status VARCHAR(255) COMMENT 'job status') default charset utf8 comment '';

-- 2021-11-06 16:54:22.478141
INSERT INTO employee VALUES (5, 'A. Ghosh', 'Kharagpur', 4200.00, 'Professor'), (10, 'G. Bhakta', 'Midnapur', 2700.00, 'Research fellow'), (1, 'P. Sen', 'Calcutta', 5000.00, 'Professor'), (7, 'D. Kundu', 'Kharagpur', 8000.00, 'Director'), (3, 'S. Prasad', 'Calcutta', 5300.00, 'Professor'), (4, 'P. Gupta', 'Midnapur', 3000.00, 'Research fellow'), (11, 'G.S. Bose', 'Kharagpur', 2000.00, 'Office Asst'), (12, 'L. sen', 'Calcutta', 1500.00, 'Office Asst'), (13, 'K. Singh', 'Midnapur', 1700.00, 'Office Asst');

-- 2021-11-06 16:54:39.604426
SELECT * FROM employee;

-- 2021-11-06 16:55:23.846130
CREATE TABLE project (p_no VARCHAR(12) NOT NULL primary key comment 'primary key', p_name VARCHAR(255) COMMENT 'project name', nos_of_staff INTEGER COMMENT 'number of staff' ) default charset utf8 comment '';

-- 2021-11-06 16:55:34.601658
INSERT INTO project VALUES ('CS110', 'DBMS', 4), ('CS220', 'DDBMS', 3), ('MS005', 'MIS', 5), ('MS001', 'CAD/VLSI', 4);

-- 2021-11-06 16:55:40.187404
SELECT * FROM project;

-- 2021-11-06 16:55:47.593567
SELECT e_name FROM employee WHERE basic_salary > 4000;

-- 2021-11-06 16:55:54.696938
SELECT e_name FROM employee WHERE basic_salary > 4000 AND job_status = 'Professor';

-- 2021-11-06 16:56:04.707304
SELECT e_name, e_no FROM employee ORDER BY e_no DESC;

-- 2021-11-06 16:56:11.479396
SELECT e_name FROM employee WHERE job_status LIKE 'Research%';

-- 2021-11-06 16:56:18.501853
SELECT e_name FROM employee WHERE MOD(e_no, 2) = 1;

-- 2021-11-06 16:56:23.969608
SELECT SUM(basic_salary) AS "Total Salary" FROM employee;

-- 2021-11-06 16:56:29.774725
SELECT SUM(basic_salary) AS "Total Salary" FROM employee WHERE job_status = 'Office Asst';

-- 2021-11-06 16:56:35.620271
SELECT job_status, COUNT(*) As "No of employees" FROM employee GROUP BY job_status;

-- 2021-11-06 16:56:42.671237
SELECT AVG(basic_salary) As "Average Salary" FROM employee WHERE job_status in ('Professor', 'Research fellow');

-- 2021-11-06 16:57:30.069443
SELECT e_name FROM employee WHERE job_status in (SELECT job_status FROM employee WHERE e_name = 'P. Gupta');

-- 2021-11-06 17:21:35.106439
SHOW DATABASES;

-- 2021-11-06 17:21:52.347412
SHOW TABLES;

-- 2021-11-06 17:22:02.878388
USE dbmsl;

-- 2021-11-06 17:22:04.836581
SHOW TABLES;

-- 2021-11-06 17:22:24.189959
USE dbmsl;

-- 2021-11-06 17:22:55.407374
CREATE TABLE dept(deptno int NOT NULL primary key, dname VARCHAR(20) NOT NULL, location VARCHAR(20) NOT NULL ) default charset utf8 comment '';

-- 2021-11-06 17:23:04.962208
INSERT INTO dept VALUES (1, 'HR', 'Mumbai'), (2, 'Management', 'Mumbai'), (3, 'Core', 'Pune');

-- 2021-11-06 17:23:22.275180
SELECT * FROM dept;

-- 2021-11-06 17:23:34.107723
CREATE TABLE emp(empno int NOT NULL primary key, ename VARCHAR(20) NOT NULL, job VARCHAR(20) NOT NULL, hiredate DATETIME NOT NULL, sal int, deptno int) default charset utf8 comment '';

-- 2021-11-06 17:23:40.520838
ALTER TABLE emp ADD FOREIGN KEY (deptno) REFERENCES dept(deptno);

-- 2021-11-06 17:23:50.848418
DESC emp;

-- 2021-11-06 17:24:10.849667
ALTER Table emp ADD mobileno int;

-- 2021-11-06 17:25:18.801490
INSERT INTO emp VALUES (1, 'Alex', 'Manager', '2010-04-11', 10000, 1, 99842744), (2, 'Bruce', 'Employee', '2012-06-12', 5500, 2, 546486156), (3, 'Alpha', 'Employee', '2016-06-23', 7500, 3, 18645184), (5, 'Loro', 'Manager', '2019-09-30', 4000, 2, 875138453);

-- 2021-11-06 17:25:32.614158
INSERT INTO emp VALUES (7369, 'Sam', 'Employee', '2012-06-15', 60000, 1, 55421666);

-- 2021-11-06 17:25:45.048893
SELECT * FROM emp;

-- 2021-11-06 17:25:54.795776
DELETE FROM emp WHERE empno = 7369;

-- 2021-11-06 17:26:00.721964
SELECT * FROM emp;

-- 2021-11-06 17:26:11.223424
SELECT * from emp join dept WHERE emp.deptno=dept.deptno;

-- 2021-11-06 17:26:20.032972
SELECT * from emp inner join dept on emp.deptno=dept.deptno;

-- 2021-11-06 17:26:27.459397
SELECT * from emp left join dept on emp.deptno=dept.deptno;

-- 2021-11-06 17:26:38.722046
SELECT * from emp right join dept on emp.deptno=dept.deptno;

-- 2021-11-06 17:32:25.326492
CREATE VIEW Details AS SELECT emp.empno, emp.ename, emp.hiredate, dept.dname, dept.location FROM emp, dept WHERE emp.deptno=dept.deptno;

-- 2021-11-06 17:32:41.481151
SELECT * FROM `Details`;

-- 2021-11-06 17:34:52.571044
CREATE OR REPLACE VIEW Details AS SELECT emp.empno, emp.ename, emp.hiredate, emp.mobileno, dept.dname, dept.location FROM emp, dept WHERE emp.deptno=dept.deptno;

-- 2021-11-06 17:34:57.319110
SELECT * FROM `Details`;

-- 2021-11-06 17:35:13.394013
DROP VIEW `Details`;

-- 2021-11-06 19:33:01.427302
\. /home/proxzima/file.sql;

DROP TABLE areas;

-- 2021-11-06 19:37:30.759330
DROP TABLE circleArea;

-- 2021-11-06 19:39:47.691329
USE dbmsl;

-- 2021-11-06 19:39:58.739824
CREATE TABLE circleArea (radius INT, area FLOAT);

-- 2021-11-06 19:40:08.768860
DROP PROCEDURE IF EXISTS calcCircleArea;
DELIMITER $$
CREATE PROCEDURE calcCircleArea(
    IN radius INT
)
BEGIN
    DECLARE area FLOAT(5);
    DECLARE pi FLOAT(2) DEFAULT 3.14;

    IF 5<=radius AND radius<=9 THEN
        SET area:=pi*POWER(radius, 2);
        INSERT INTO circleArea VALUES(radius, area);
    ELSE
        SELECT CONCAT('Enter valid radius: ', radius) AS 'ERROR';
    END IF;
END$$

DELIMITER ;

-- 2021-11-06 19:40:22.429942
CALL calcCircleArea(5);

-- 2021-11-06 19:40:27.670513
CALL calcCircleArea(7);

-- 2021-11-06 19:40:31.170477
CALL calcCircleArea(9);

-- 2021-11-06 19:40:40.514240
SELECT * FROM circleArea;

-- 2021-11-06 19:40:54.278551
CALL calcCircleArea(4);

-- 2021-11-06 19:41:01.487250
CALL calcCircleArea(10);

-- 2021-11-06 21:41:39.017222
USE dbmsl;

-- 2021-11-06 21:41:52.575932
CREATE TABLE Borrower(Roll_no INT PRIMARY KEY NOT NULL, Name VARCHAR(20), DateofIssue DATE, NameofBook VARCHAR(50), Status VARCHAR(10));

-- 2021-11-06 21:42:03.814998
INSERT INTO Borrower VALUES (1, 'Pratik', '2021-11-01', 'Revolution 2020', 'I'), (2, 'Alex', '2021-10-28', 'Midnights Children', 'I'), (3, 'Jhon', '2021-09-03', 'Only Time Will Tell', 'I');

-- 2021-11-06 21:42:07.167295
SELECT * FROM Borrower;

-- 2021-11-06 21:42:17.859411
CREATE TABLE Fine (Roll_no INT PRIMARY KEY NOT NULL, Date DATE, Amt INT);

-- 2021-11-06 21:45:07.767463
UPDATE Borrower SET DateofIssue='2021-10-12' WHERE Roll_no=2;

-- 2021-11-06 21:45:11.788996
SELECT * FROM Borrower;

-- 2021-11-06 21:45:43.312682
DROP PROCEDURE IF EXISTS LIBRARY;
DELIMITER $$
CREATE PROCEDURE LIBRARY(
    roll int,
    name_of_book varchar(50)
)
BEGIN
    DECLARE diff_date INT;
    DECLARE p_date DATE;
    DECLARE i_date DATE;
    DECLARE fine_amt FLOAT(5);
 
    SET p_date:=SYSDATE();
    SELECT DateofIssue INTO i_date FROM Borrower WHERE Roll_no=roll;
    SET diff_date:=DATEDIFF(p_date, i_date);
    
    SELECT Roll_no AS 'Roll no', Name AS 'Name', DateofIssue AS 'Date of Issue', NameofBook AS 'Name of Book', diff_date AS 'Days since last issued' FROM Borrower WHERE Roll_no=roll;

    IF (15<=diff_date AND diff_date<=30) THEN 
        SET fine_amt:=diff_date*5;
    ELSE
        SET fine_amt:=(diff_date-30)*50 + 15*5;
    END IF;

    UPDATE Borrower SET status:='R' WHERE Roll_no=roll;

    IF (fine_amt>0) THEN
        INSERT INTO Fine VALUES (roll, p_date, fine_amt);
    END IF;

    SELECT * FROM Fine;
END$$

DELIMITER ;

-- 2021-11-06 21:45:53.154554
CALL LIBRARY(1, 'Revolution 2020');

-- 2021-11-06 21:46:03.884612
CALL LIBRARY(2, 'Midnights Children');

-- 2021-11-06 21:46:18.984763
CALL LIBRARY(3, 'Only Time Will Tell');

-- 2021-11-06 21:46:36.395666
SELECT * FROM Borrower;

-- 2021-11-15 00:13:21.216104
USE dbmsl;

-- 2021-11-15 00:13:43.886654
CREATE TABLE Stud_Marks (Roll INT PRIMARY KEY NOT NULL, name VARCHAR(255), total_marks INT);

-- 2021-11-15 00:13:51.191763
INSERT INTO Stud_Marks VALUES (101, 'Alex', -46), (102, 'Pratik', 1300), (103, 'John', 683), (104, 'Varun', 342), (105, 'Sam', 927), (106, 'Mohan', 767), (107, 'Rohan', 1847), (108, 'Andrew', 850);

-- 2021-11-15 00:13:58.230889
CREATE TABLE Result (Roll INT PRIMARY KEY NOT NULL, name VARCHAR(255), class VARCHAR(50));

-- 2021-11-15 00:14:04.399198
SELECT * FROM `Stud_Marks`;

-- 2021-11-15 00:17:09.287582
DROP FUNCTION IF EXISTS final_Result;
DELIMITER $$
CREATE FUNCTION final_Result(
    marks INT
)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE class VARCHAR(255);

    IF    (990 < marks and marks < 1500) THEN
        SET class:='Distincton';
    ELSEIF (890 < marks AND marks < 989) THEN
        SET class:='First Class';
    ELSEIF (825 < marks AND marks < 889) THEN
        SET class:='Higher Second Class';
    ELSEIF (750 < marks AND marks < 824) THEN
        SET class:='Second Class';
    ELSEIF (650 < marks AND marks < 749) THEN
        SET class:='Passed';
    ELSEIF   (0 < marks AND marks < 649) THEN
        SET class:='Fail';
    ELSE
        SET class:='Incorrect Marks';
    END IF;

    RETURN (class);
END$$

DELIMITER ;

-- 2021-11-15 00:17:43.355930
DROP PROCEDURE IF EXISTS proc_Grade;
DELIMITER $$
CREATE PROCEDURE proc_Grade(
    roll INT
)
BEGIN
    DECLARE studName VARCHAR(50);
    DECLARE marks INT;
    DECLARE class VARCHAR(255);

    DECLARE EXIT HANDLER FOR NOT FOUND
    BEGIN
        SELECT CONCAT('An error has occurred. Roll No ', roll, ' not found.') AS 'Error';
    END;

    SELECT sm.name, sm.total_marks INTO studName, marks FROM Stud_Marks sm WHERE sm.Roll=roll;

    SET class:=final_Result(marks);

    INSERT INTO Result VALUES (roll, studName, class);

    SELECT sm.Roll AS 'Roll no', sm.name AS 'Name', class AS 'Class' FROM Stud_Marks sm WHERE sm.Roll=roll;
END$$
DELIMITER ;

-- 2021-11-15 00:18:11.936382
CALL proc_Grade(101);

-- 2021-11-15 00:18:19.636822
CALL proc_Grade(102);

-- 2021-11-15 00:18:26.480141
CALL proc_Grade(103);

-- 2021-11-15 00:18:30.026080
CALL proc_Grade(104);

-- 2021-11-15 00:18:48.808712
CALL proc_Grade(105);

-- 2021-11-15 00:18:51.889493
CALL proc_Grade(106);

-- 2021-11-15 00:18:56.112304
CALL proc_Grade(107);

-- 2021-11-15 00:19:02.144234
CALL proc_Grade(108);

-- 2021-11-15 00:19:07.771287
CALL proc_Grade(109);

-- 2021-11-15 00:19:16.457199
SELECT * FROM `Result`;

-- 2021-12-02 17:53:21.717760
USE dbmsl;

-- 2021-12-02 19:49:23.178842
CREATE TABLE old_class(roll INT PRIMARY KEY, name VARCHAR(50));

-- 2021-12-02 19:49:34.330576
INSERT INTO old_class VALUES (101, 'Alex'), (102, 'Pratik'), (103, 'John'), (104, 'Varun'), (105, 'Sam'), (106, 'Mohan'), (107, 'Rohan'), (108, 'Andrew');

-- 2021-12-02 19:49:50.286481
CREATE TABLE new_class(roll INT PRIMARY KEY, name VARCHAR(50));

-- 2021-12-02 19:49:58.849030
INSERT INTO new_class VALUES (101, 'Alex'), (103, 'John'), (107, 'Rohan');

-- 2021-12-02 19:50:06.441398
DROP PROCEDURE IF EXISTS copyTableOldInNew;

-- 2021-12-02 19:50:12.351261
DELIMITER $$

-- 2021-12-02 19:50:26.984593
CREATE PROCEDURE copyTableOldInNew()
BEGIN
  DECLARE o_roll INT DEFAULT 0;
  DECLARE o_name varchar(50);
  DECLARE done INT DEFAULT FALSE;

  DECLARE tcursor cursor for SELECT roll, name FROM old_class;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN tcursor;
  read_loop: LOOP
    FETCH tcursor into o_roll, o_name;
    if done then
      LEAVE read_loop;
    END IF;
    IF (SELECT 1 from new_class WHERE roll=o_roll) THEN
        SELECT CONCAT('Name: ', o_name) AS 'EXISTS IN DATABASE!! SKIPPING!!';
    ELSE
        INSERT INTO new_class(roll, name) values(o_roll, o_name);
    END IF;
  END LOOP;
  CLOSE tcursor;
END$$

-- 2021-12-02 19:50:30.530380
DELIMITER ;

-- 2021-12-02 19:50:34.043898
CALL copyTableOldInNew();

-- 2021-12-02 19:50:42.167732
SELECT * FROM old_class;

-- 2021-12-02 19:50:50.169389
SELECT * FROM new_class;

-- 2021-12-02 20:01:52.236629
USE dbmsl;

-- 2021-12-02 20:01:55.846457
SHOW TABLES;

-- 2021-12-02 20:02:05.749015
SELECT * FROM library;

-- 2021-12-02 20:17:30.867155
SELECT * FROM `Borrower`;

-- 2021-12-02 22:20:22.477758
USE dbmsl;

-- 2021-12-02 22:20:26.285682
SELECT * FROM library;

-- 2021-12-02 22:22:24.078813
DROP TABLE library;

-- 2021-12-02 22:25:48.331859
CREATE TABLE library (ISBN VARCHAR(50) PRIMARY KEY, name VARCHAR(255), author VARCHAR(255), publisher VARCHAR(255), yearOfPublication INTEGER, cost FLOAT NOT NULL );

-- 2021-12-02 22:26:05.907749
INSERT INTO library VALUES ('9874133548', 'Only Time Will Tell', 'Jeffery Archer', 'PAN', 2011, 562.45), ('9784157165', 'Midnights Children', 'Salman Rushdie', 'VINTAGE', 2013, 452.25), ('9457154812', 'Revolution 2020', 'Jeffery Archer', 'RUPA', 2011, 842.75);

-- 2021-12-02 22:26:13.481971
SELECT * FROM library;

-- 2021-12-02 22:30:20.204024
USE dbmsl;

-- 2021-12-02 22:30:21.720113
SELECT * FROM library;

-- 2021-12-02 22:30:33.046400
USE dbmsl;

-- 2021-12-02 22:30:36.932441
DROP TABLE library;

-- 2021-12-02 22:30:40.594355
CREATE TABLE library (ISBN VARCHAR(50) PRIMARY KEY, name VARCHAR(255), author VARCHAR(255), publisher VARCHAR(255), yearOfPublication INTEGER, cost FLOAT NOT NULL );

-- 2021-12-02 22:30:49.270958
INSERT INTO library VALUES ('9874133548', 'Only Time Will Tell', 'Jeffery Archer', 'PAN', 2011, 562.45), ('9784157165', 'Midnights Children', 'Salman Rushdie', 'VINTAGE', 2013, 452.25), ('9457154812', 'Revolution 2020', 'Jeffery Archer', 'RUPA', 2011, 842.75);

-- 2021-12-02 22:30:55.678477
SELECT * FROM library;

-- 2021-12-02 22:32:31.649524
CREATE TABLE library_audit (ISBN VARCHAR(50) PRIMARY KEY, name VARCHAR(255), author VARCHAR(255), publisher VARCHAR(255), yearOfPublication INTEGER, cost FLOAT NOT NULL, trigger_type VARCHAR(50));

-- 2021-12-02 22:32:57.855010
DELIMITER $$

-- 2021-12-02 22:37:24.882008
CREATE TRIGGER update_library
BEFORE UPDATE ON library
FOR EACH ROW
BEGIN
    INSERT INTO library_audit VALUES (library.ISBN, library.name, library.author, library.publishe    r, library.yearOfPublication, library.cost, 'UPDATED');
END$$

-- 2021-12-02 22:39:20.240328
CREATE TRIGGER update_library
    BEFORE UPDATE ON library
    FOR EACH ROW
BEGIN
    INSERT INTO library_audit VALUES (library.ISBN, library.name, library.author, library.publishe    r, library.yearOfPublication, library.cost, 'UPDATED');
END $$

-- 2021-12-02 22:39:48.735028
CREATE TRIGGER update_library
    BEFORE UPDATE ON library
    FOR EACH ROW
BEGIN
    INSERT INTO library_audit VALUES (library.ISBN, library.name, library.author, library.publisher, library.yearOfPublication, library.cost, 'UPDATED');
END $$

-- 2021-12-02 22:40:34.683833
CREATE TRIGGER update_library
    BEFORE DELETE ON library
    FOR EACH ROW
BEGIN
    INSERT INTO library_audit VALUES (library.ISBN, library.name, library.author, library.publisher, library.yearOfPublication, library.cost, 'DELETED');
END $$

-- 2021-12-02 22:40:50.356192
CREATE TRIGGER delete_library
    BEFORE DELETE ON library
    FOR EACH ROW
BEGIN
    INSERT INTO library_audit VALUES (library.ISBN, library.name, library.author, library.publisher, library.yearOfPublication, library.cost, 'DELETED');
END $$

-- 2021-12-02 22:41:20.775729
DELIMITER ;

-- 2021-12-02 22:41:29.974700
SELECT * FROM library_audit;

-- 2021-12-02 22:42:52.513520
UPDATE library SET cost=325.25 where ISBN=9457154812;

-- 2021-12-02 22:46:01.848797
DROP TRIGGER IF EXISTS update_library;

-- 2021-12-02 22:49:19.921509
DELIMITER $$

-- 2021-12-02 22:49:26.480010
CREATE TRIGGER update_library
    BEFORE UPDATE ON library
    FOR EACH ROW
BEGIN
    INSERT INTO library_audit VALUES (old.ISBN, old.name, old.author, old.publisher, old.yearOfPublication, old.cost, CONCAT('UPDATED: ', old.cost, ' -> ', new.cost));
END $$

-- 2021-12-02 22:50:46.650572
CREATE TRIGGER delete_library
    BEFORE DELETE ON library
    FOR EACH ROW
BEGIN
    INSERT INTO library_audit VALUES (old.ISBN, old.name, old.author, old.publisher, old.yearOfPublication, old.cost, 'DELETED');
END $$

-- 2021-12-02 22:51:23.585551
DELIMITER ;

-- 2021-12-02 22:51:35.183676
DROP TRIGGER IF EXISTS delete_library;

-- 2021-12-02 22:51:40.299816
DELIMITER $$

-- 2021-12-02 22:51:42.993078
CREATE TRIGGER delete_library
    BEFORE DELETE ON library
    FOR EACH ROW
BEGIN
    INSERT INTO library_audit VALUES (old.ISBN, old.name, old.author, old.publisher, old.yearOfPublication, old.cost, 'DELETED');
END $$

-- 2021-12-02 22:51:47.363045
DELIMITER ;

-- 2021-12-02 22:51:59.845252
SELECT * FROM library;

-- 2021-12-02 22:52:15.219412
UPDATE library SET cost=325.25 where ISBN=9457154812;

-- 2021-12-02 22:52:20.728638
SELECT * FROM library;

-- 2021-12-02 22:52:26.101926
SELECT * FROM library_audit;

-- 2021-12-02 22:53:09.721473
DELETE FROM library WHERE ISBN=9874133548;

-- 2021-12-02 22:53:13.038560
SELECT * FROM library;

-- 2021-12-02 22:53:20.849697
SELECT * FROM library_audit;

-- 2021-12-03 08:15:39.264981
SHOW DATABASES;

-- 2021-12-03 08:23:24.386141
USE dbmsl;

-- 2021-12-03 08:23:38.253450
DROP TABLE library;

-- 2021-12-03 08:24:29.896513
USE dbmsl;

-- 2021-12-03 08:33:01.301287
DESC library;

-- 2021-12-03 08:50:50.342052
SHOW DATABASES;

-- 2021-12-03 09:05:10.396284
DROP TABLE library;

-- 2021-12-03 09:05:45.682043
USE dbmsl;

-- 2021-12-03 09:05:48.436286
DESC library;

-- 2021-12-03 09:06:02.335787
CREATE TABLE library (ISBN VARCHAR(50) PRIMARY KEY, name VARCHAR(255), author VARCHAR(255), publisher VARCHAR(255), yearOfPublication INTEGER, cost FLOAT NOT NULL );

-- 2021-12-03 09:06:05.842965
DESC library;

-- 2021-12-17 11:00:39.199513
USE dbmsl;

-- 2021-12-24 17:18:50.509821
DESC library;

-- 2022-05-10 21:56:03.748211
CREATE DATABASE 'Bookstore';
USE Bookstore;
 
CREATE TABLE `book` (
  `book_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `author` varchar(45) NOT NULL,
  `price` float NOT NULL,
  PRIMARY KEY (`book_id`),
  UNIQUE KEY `book_id_UNIQUE` (`book_id`),
  UNIQUE KEY `title_UNIQUE` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

-- 2022-05-10 21:56:16.982815
CREATE DATABASE Bookstore;
USE Bookstore;
 
CREATE TABLE `book` (
  `book_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `author` varchar(45) NOT NULL,
  `price` float NOT NULL,
  PRIMARY KEY (`book_id`),
  UNIQUE KEY `book_id_UNIQUE` (`book_id`),
  UNIQUE KEY `title_UNIQUE` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

-- 2022-05-10 22:10:59.323605
show DATABASES;

-- 2022-05-10 22:11:12.655960
use Bookstore;

-- 2022-05-10 22:11:27.928044
show TABLES;

-- 2022-05-10 22:11:37.959859
desc book;

-- 2022-05-11 00:16:44.026248
show DATABASES;

-- 2022-05-11 00:20:07.925130
CREATE DATABASE Employee;
USE Employee;
 
CREATE TABLE `employee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200),
  `password` varchar(200),
  `email` varchar(200),
  `country` varchar(200),
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

-- 2022-05-11 09:59:13.629706
use dbmsl;

-- 2022-05-11 09:59:32.033846
show TABLES;

-- 2022-05-11 09:59:50.560903
use dbmsl;

-- 2022-05-11 09:59:52.992135
CREATE TABLE `students` (
  `id` int(6) NOT NULL,
  `firstname` varchar(30) NOT NULL,
  `lastname` varchar(30) NOT NULL,
  `email` varchar(70) NOT NULL,
  `course` varchar(30) NOT NULL,
  `batch` int(4) NOT NULL,
  `city` varchar(30) NOT NULL,
  `state` varchar(30) NOT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
