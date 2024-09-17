SELECT
	full_school_name,
	AVG(weight) FROM players
GROUP BY full_school_name


SELECT
	full_school_name,
	player_name,
	SUM(weight) 
	OVER(
	PARTITION BY full_school_name
	ORDER BY player_name)
FROM players

SELECT start_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER
         (PARTITION BY start_terminal) AS running_total,
       COUNT(duration_seconds) OVER
         (PARTITION BY start_terminal) AS running_count,
       AVG(duration_seconds) OVER
         (PARTITION BY start_terminal) AS running_avg
  FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'



SELECT start_terminal,
       duration_seconds,
	   start_time,
       RANK() OVER (PARTITION BY start_terminal
                    ORDER BY start_time DESC),
       DENSE_RANK() OVER (PARTITION BY start_terminal
                    ORDER BY start_time DESC)
              AS ranking
  FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'


SELECT start_terminal,
       duration_seconds,
       LAG(duration_seconds, 1) OVER -- memberikan nilai dari baris sebelumnya, parameternya merupakan pemilihan nilai yang ingin diambil
         (PARTITION BY start_terminal ORDER BY duration_seconds) AS lag,
       LEAD(duration_seconds, 1) OVER -- memberikan nilai dari baris setelahnya
         (PARTITION BY start_terminal ORDER BY duration_seconds) AS lead
  FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY start_terminal, duration_seconds
-- biasanya digunakan untuk mencari selisih 
--misal :
SELECT start_terminal,
       duration_seconds,
	   duration_seconds - LAG(duration_seconds, 1) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS lag-- memberikan nilai dari baris sebelumnya, parameternya merupakan pemilihan nilai yang ingin diambil
      -- LEAD(duration_seconds, 1) OVER -- memberikan nilai dari baris setelahnya
         --(PARTITION BY start_terminal ORDER BY duration_seconds) AS lead
  FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY start_terminal, duration_seconds


--NTAIL
SELECT 
	   start_terminal,
       duration_seconds,
       NTILE(4) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds)
         AS quartile,
       NTILE(5) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds)
         AS quintile,
       NTILE(100) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds)
         AS percentile
  FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY start_terminal, duration_seconds


 -- PIVOT TABLE
 SELECT *
  FROM (
        SELECT teams.conference AS conference,
               players.year,
               COUNT(1) AS players
            FROM players players
            JOIN teams
            ON teams.school_name = players.school_name
         GROUP BY 1,2 --(1,2 ---> shortcut memanggil table sesuai dengan pemanggilan table )
		 ORDER BY 1,2
       ) sub

SELECT conference,
       SUM(players) AS total_players,
       SUM(CASE WHEN year = 'FR' THEN players ELSE NULL END) AS fr,
       SUM(CASE WHEN year = 'SO' THEN players ELSE NULL END) AS so,
       SUM(CASE WHEN year = 'JR' THEN players ELSE NULL END) AS jr,
       SUM(CASE WHEN year = 'SR' THEN players ELSE NULL END) AS sr
  FROM (
        SELECT teams.conference AS conference,
               players.year,
               COUNT(1) AS players
          FROM players
          JOIN teams
            ON teams.school_name = players.school_name
         GROUP BY 1,2
       ) sub
 GROUP BY 1
 ORDER BY 2 DESC