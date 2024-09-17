CREATE DATABASE d3w2



--SELECT--
-- scenario 1(all columns)
SELECT * FROM students

--scenario 2 (selected columns)
SELECT name,total_grade FROM students;

--select distinct 
SELECT DISTINCT campus_id FROM students

--ALIAS 
--cara 1 
SELECT name AS full_name
	from students;
--cara 2 
SELECT name full_name
		FROM students;
-- memanggil table dengan urutan yang berbeda dengan yang ada pada database
SELECT total_grade grade,
		name 
		FROM students

SELECT * FROM students;
SELECT * FROM campus;


-- CONDITIONAL --
-- WHERE --
-- = ----> equal to
-- != or <> -----> not equal to
-- < ------> less than 
-- > ------> greater than 
-- >= ------> greater than or equal to
-- <= -------> less than or equal to
-- BETWEEN --------> within range 
-- IN --------> match set of values 
-- LIKE -----------> match pattern (case sensitive)
-- ILIKE -----------> match pattern (case insensitive)
	-- wildcards = 
		'_' -----> represent single characther
		'%' ------> represent one or more characther
-- NOT ---------> negates a condition 

-- filter students who got honour award
SELECT 
	name,
	total_grade 
FROM students 
WHERE total_grade > 90;

-- Filter students who got participant award
SELECT 
	name,
	total_grade 
FROM students 
WHERE total_grade BETWEEN 70 AND 80;

-- Filter students who's age in19,20,22
SELECT 
	name,
	age 
FROM students 
WHERE age IN (20,22,19);

-- Filter students who's age NOT in 19,20,22
SELECT 
	name,
	age 
FROM students 
WHERE age NOT IN (20,22,19);

--filter students name that start with "R"
--LIKE
SELECT name as full_name 
FROM students 
WHERE name LIKE 'R%'

--filter students name that start with "R" 
-- ILIKE
SELECT name AS full_name 
FROM students 
WHERE name ILIKE 'r%'

--filter students name that start with "R" and char length is 10
SELECT name AS full_name 
FROM students 
WHERE name LIKE 'R_________'

--filter students name that end with "omo"
SELECT name AS full_name 
FROM students 
WHERE name ILIKE '%omo'

-- filter students name that has second and third char is "an"
SELECT name as full_name 
FROM students 
WHERE name ILIKE '_an%'


--AND / OR
-- and add a conditions and both/all have to be True 

--Filter students grade that greater than 80 and age less than 20
SELECT * 
FROM students
WHERE age <= 20 AND  total_grade > 80
-- Filter students_grade that greater than 70 and oess than or equal to 20
SELECT * 
FROM students
WHERE age <= 20 AND  total_grade > 70
-- or add conditions and at least one of them have to be True
-- filter students name that start with 'D' or 'R'
SELECT *
FROM students 
WHERE name LIKE 'D%' OR name LIKE'R%'

-- filter students name that start with 'D' or'H' in Pondok Indah campus
SELECT * 
FROM students 
WHERE campus_id = 2 and name LIKE 'D%' or name LIKE 'H%'

-- ORDER BY -----------> mengurutkan row berdasarkan <column_name>
SELECT name AS full_name 
FROM students 
ORDER BY name ASC

SELECT name AS full_name 
FROM students 
ORDER BY name DESC

SELECT name,total_grade
FROM students 
ORDER BY total_grade 


-- GROUP BY  & aggregation --

SELECT 
	campus_id,
	COUNT (name) AS student_count, -------> to know how many students in each campus
	SUM(total_grade) AS summary_of_grade, ------ > to know summary of grade in each campus 
	AVG(total_grade) AS average_grade,------ > to know AVG grade in each campus
	MIN(total_grade) AS minimum_grade,------ > to know Minimum grade in each campus 
	MAX(total_grade) AS maximum_grade------ > to know Maximum grade in each campus 
FROM students
GROUP BY campus_id ---> group by campus_id

-- HAVING --
-- can contain aggregation
-- filter average grade just in bsd campus 
SELECT 
	campus_id,
	AVG (total_grade)
FROM students
GROUP BY campus_id
HAVING campus_id = 3





FROM country 
JOIN city ON country_id = city.country_id;
-- full join (menamilkan seluruh data pada semua tabel)
SELECT 
	co.country_name,
	ci.city_name,
	ci.country_id
FROM country AS co
FULL JOIN city AS ci ON co.id = ci.country_id;

SELECT * FROM country;

CREATE TABLE assignment_scores (
    id SERIAL PRIMARY KEY,
    students_id INTEGER,
    assignment_id INTEGER,
    score FLOAT
);

INSERT INTO assignment_scores (students_id, assignment_id, score)
VALUES
    (1, 1, 90.0),
    (1, 2, 85.0),
    (2, 1, 92.5),
    (2, 2, 88.5),
    (3, 1, 80.0),
    (4, 2, 79.5),
    (4, 1, 95.0),
    (4, 2, 90.5),
    (5, 1, 88.0),
    (5, 2, 86.0),
    (6, 2, 86.0);







































