--creating database
CREATE DATABASE FTDS; 

-- create students table 
CREATE TABLE students(
	id SERIAL PRIMARY KEY,
	name VARCHAR (50),
	age INTEGER,
	campus_id INTEGER,
	total_grade FLOAT
);

CREATE TABLE campus(
	id SERIAL PRIMARY KEY,
	campus_name VARCHAR(50),
	batch VARCHAR (10),
	start_date DATE
);

--check table 
SELECT * FROM students
SELECT * FROM campus 
-- DML 
-- Insert table 

INSERT INTO students(name,age,campus_id,total_grade)
VALUES 
	('Laufin Zulfikar',20,1,85.5),
	('Biaggi Rachman',21,1,91.8),
	('Fajar Nabil',18,2,70),
	('David Yusuf',20,2,75.5),
	('Edwin Erlangga',25,1,80);

-- insert data campus 
INSERT INTO campus (campus_name,batch,start_date)
VALUES 
	('Remote','RMT-1','2023-01-01'),
	('Jakarta','HCK-21','2023-12-01'),
	('BSD','BSD-2','2023-10-01'),
	('Surabaya','SBY-1','2024-02-01'),
	('singapore','SIN-2','2023-01-10');

UPDATE students
SET total_grade = 95.3
WHERE id = 6

-- DELETE, remove a row 
DELETE FROM campus 
WHERE id = 5

INSERT INTO campus (campus_name,batch,start_date)
VALUES 
	('singapore','SIN-2','2023-01-10');

--ALTER 
--ALTER ADD COLUMN 
ALTER TABLE students
ADD COLUMN email VARCHAR(30)

-- ALTER RENAME COLUMN 
ALTER TABLE campus 
RENAME COLUMN campus_name TO name;

--TRUNCATE TABLE (menghapus keseluruhan nilai dalam table #tidak menghapus table nya )
TRUNCATE TABLE campus;

--DROP (Menghapus table)
DROP TABLE campus ;

-- DROP on COLUMN
ALTER TABLE students
DROP COLUMN email;


EXPLAIN SELECT * FROM students
WHERE id IN (1,2,3,4);