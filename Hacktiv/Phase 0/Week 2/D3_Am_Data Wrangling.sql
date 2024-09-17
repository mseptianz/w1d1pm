----------------------------
--- DATA WRANGLING IN SQL---
----------------------------

--ALTER 
-- CHANGE TABEL NAME 
ALTER TABLE crunchbase_companies_clean_data 
	RENAME TO companies;

ALTER TABLE dc_bikeshare_q1_2012
	RENAME TO bikeshare;

-- CONVERT 

-- MENGUBAH TIPE DATA KOLOM 'founded_at' menjadi 'datetime'
ALTER TABLE companies
	ALTER COLUMN founded_at TYPE DATE 
	USING founded_at :: DATE;
-- if error 
UPDATE companies
	SET founded_at = TO_DATE(founded_at,'MM/DD/YY');

--CARA 1 MENGGUNAKAN CAST
SELECT 
	id,
	funding_total_usd,
	CAST(funding_total_usd AS FLOAT),
	CAST(funding_total_usd AS INTEGER),
	CAST(funding_total_usd AS TEXT)
FROM companies;

--CARA 2 MENGGUNAKAN ::
SELECT 
	id,
	funding_total_usd ,
	funding_total_usd :: FLOAT,
	funding_total_usd :: INTEGER,
	funding_total_usd :: TEXT
FROM companies

-- EXTRACT -- 
-- from date/timestamp type 
SELECT 
	id,
	founded_at,
	EXTRACT (YEAR FROM founded_at) AS year_founded,
	EXTRACT (MONTH FROM founded_at) AS month_founded,
	EXTRACT (DAY FROM founded_at) AS date_founded,
	EXTRACT (QUARTER FROM founded_at) AS quarter_founded
FROM companies

-- CURRENT TIME --
SELECT 
	CURRENT_DATE AS date,
	CURRENT_TIME AS time,
	CURRENT_TIMESTAMP AS timestap,
	LOCALTIME AS local_time,
	LOCALTIMESTAMP AS local_time_stamp,
	NOW() AS now

-- Time different with the data
SELECT 
	id,
	founded_at,
	CURRENT_DATE as todays_date,
	CURRENT_DATE - founded_at AS founded_time_ago
FROM companies ;

-- Time different with the data & data interval
SELECT 
	id,
	founded_at,
	CURRENT_DATE as todays_date,
	CURRENT_DATE - founded_at AS founded_time_ago,
	founded_at + INTERVAL '10 DAY' AS plus_10_day_after_founded
FROM companies ;

--HANDLING MISSING VALUE 
SELECT 
	id, 
	founded_at_clean, 
	COALESCE(founded_at_clean, 'No Date')

FROM companies;


-- left,right, & substring
-- Extract year from founded_at string 
SELECT 
	id,
	founded_at_clean,
	LEFT(founded_at_clean,4) Year_founded,
	-- CONVERT to INTEGER
	CAST(LEFT(founded_at_clean,4)AS INTEGER) Year_founded,
	-- Extract date from founded at string
	CAST(RIGHT(founded_at_clean,2)AS INTEGER) Date_founded,
	-- Extract month from founded at string 
	CAST(SUBSTRING(founded_at_clean,6,2)AS INTEGER) Month_founded
FROM companies;

-- Extract company name from it;s permalink 
SELECT 
	id,
	permalink,
	name,
	SUBSTRING (permalink,10,20) AS name_from_link
FROM companies ;

-- Extract time information from timestamp type using LEFT,IGHT,& SUBSTRING 
SELECT 
	id,
	start_time,
	--convert timestamp to string 
	start_time::TEXT ,
	--Extract year from start_time
	LEFT (start_time::TEXT , 4) Year_rented,
	-- convert to INT 
	LEFT (start_time::TEXT , 4):: INTEGER Year_rented,
	-- Extract minutes from start_time 
	SUBSTRING(start_time::TEXT , 15,2) minutes_rented
FROM bikeshare;

--TRIM--
-- to clean whitespace or characthers 

SELECT 
	('                          yosef                            '),
	TRIM (LEADING FROM '                   Yosef                        '),
	TRIM (TRAILING FROM '                    yosef                     '),
	TRIM (BOTH FROM '                       yosef                      ');
	
SELECT 
	id,
	permalink,
	name,
	SUBSTRING(permalink,10,100) AS name_from_link,
	-- TRIM trailing / right from output 
	TRIM (TRAILING FROM SUBSTRING(permalink,10,100)) AS name_trimmed
From companies;

SELECT 
	id,
	bike_number,
	-- change case to upper 
	LOWER (bike_number ) bike_number_lowered,
	TRIM(LEADING 'w0' FROM LOWER(bike_number)) AS bike_number_trimmed
FROM bikeshare;

-- changing case -- 
SELECT 
	id,
	start_station,
	LOWER (start_station) as start_station_lowered,
	UPPER (start_station) as start_station_uppered
FROM bikeshare;

-- Position -- 
SELECT 
	id,
	bike_number, 
	POSITION ('1' IN bike_number) AS posisi_angka_1
FROM bikeshare;
--Add condition to filter bike number that hace 1 in it
WHERE POSITION ('1' IN bike_number) <> 0;


-- CONCAT --
SELECT 
	id, 
	end_terminal,
	end_station,
	CONCAT(end_terminal,' - ',end_station) AS station_id_name
FROM bikeshare;

-- case -- 
SELECT 
	id,
	name AS company_name,
	category_code,
	funding_total_usd,
	CASE 
		WHEN funding_total_usd > 1000000 THEN 'High Funding'
		WHEN funding_total_usd > 100000 THEN 'Medium Funding'
		ELSE 'Low Funding'
	END as funding_categories
FROM companies;

-- categorize company location 
-- SGP,ARE
-- ASIA = SGP,IND,CHN
-- Europe : ARE, BEL , FRA , CZE, ROM,DNK, RUS,  SWE, DEU
-- America : USA , CAN , BRA , ARG
-- Australia: AUS
-- Hell : ISR
SELECT 
	id, 
	name company_name,
	category_code,
	country_code,
	CASE 
		WHEN country_code IN ('SGP','IND','CHN') THEN 'Asia'
		WHEN country_code IN ('ARE', 'BEL' , 'FRA' , 'CZE', 'ROM','DNK', 'RUS',  'SWE', 'DEU') THEN 'Europe'
		WHEN country_code IN ('USA' , 'CAN' , 'BRA' , 'ARG') THEN 'America'
		WHEN country_code = 'AUS' THEN 'Australia'
		ELSE 'HELL'
	END AS company_continent
FROM companies;



----------------------------------
-- intermediate SQL : Sub query -- 
----------------------------------
-- 1. Ambil daftar start_station beserta jumlah perjalanannya masing-masing, 
-- diurutkan berdasarkan jumlah perjalanan dari tertinggi

SELECT 
	start_station,
	COUNT (*) AS trip_count
FROM bikeshare
GROUP BY start_station

-- Tanpa subquery
SELECT 
	start_station,
	COUNT (*) AS trip_count
FROM bikeshare
GROUP BY start_station
ORDER BY trip_count DESC

-- Dengan subquery
SELECT 
	subquery.start_station,
	subquery.trip_count
FROM 
	(SELECT 
		start_station,
		COUNT (*) AS trip_count
	FROM bikeshare
	GROUP BY start_station) AS subquery
ORDER BY subquery.trip_count DESC


--2. AMbil daftar perusahaan dengan pendanaan terbesar disetiap wilayah
-- yang total pendanaannya lebih dari 1_000_000
SELECT 
	MAX (funding_total_usd) AS max_funding 
FROM companies
GROUP BY region 
HAVING MAX (funding_total_usd)> 1_000_000;


-- Subquery
SELECT
	name AS company_name,
	status,
	region,
	founded_at,
	funding_total_usd
FROM companies 
WHERE funding_total_usd IN
	(SELECT 
		MAX (funding_total_usd) AS max_funding 
	FROM companies
	GROUP BY region 
	HAVING MAX (funding_total_usd)> 1_000_000)
	AND founded_at IS NOT NULL












































SELECT 
	MIN (duration_seconds)
FROM bikeshare;
SELECT *FROM companies;
SELECT * FROM bikeshare;