
-- PROBLEM 1:
-- How many olympics games have been held?

SELECT COUNT(DISTINCT(games)) AS total_olympic_games
FROM OLYMPICS_HISTORY;

--PROBLEM 2:
--List down all Olympics games held so far.

SELECT DISTINCT year, season, city 
FROM OLYMPICS_HISTORY
GROUP BY year, season, city
ORDER BY year;

-- PROBLEM 3:
-- SQL query to fetch total no of countries participated in each olympic games

SELECT games, COUNT(DISTINCT region)
FROM OLYMPICS_HISTORY oh
JOIN OLYMPICS_HISTORY_NOC_REGIONS o 
ON o.NOC = oh.NOC 
GROUP BY games
ORDER BY games;

--PROBLEM 4:
--Which year saw the highest and lowest no of countries participating in olympics?

WITH num_of_pc AS 
(SELECT year, COUNT(region) AS num_regions
FROM
(SELECT year, region
FROM OLYMPICS_HISTORY oh
JOIN OLYMPICS_HISTORY_NOC_REGIONS o 
ON o.NOC = oh.NOC 
GROUP BY year, region) xx
GROUP BY year)
SELECT 
DISTINCT 
CONCAT('Year:', FIRST_VALUE(year) OVER(ORDER BY num_regions),' - ', FIRST_VALUE(num_regions) OVER(ORDER BY num_regions), ' Countries') AS lowest_participating,
CONCAT('Year:', FIRST_VALUE(year) OVER(ORDER BY num_regions DESC),' - ', FIRST_VALUE(num_regions) OVER(ORDER BY num_regions DESC), ' Countries') AS highest_participating
FROM num_of_pc;

--PROBLEM 5: 
--Which nation has participated in all of the olympic games?

SELECT region, COUNT(DISTINCT games)
FROM OLYMPICS_HISTORY oh
JOIN OLYMPICS_HISTORY_NOC_REGIONS o 
ON o.NOC = oh.NOC 
GROUP BY region
HAVING COUNT (DISTINCT games) IN
(SELECT COUNT(DISTINCT games)
FROM OLYMPICS_HISTORY)
ORDER BY region;


-- PROBLEM 6:
--Identify the sport which was played in all summer olympics.

-- number of summer olympics
SELECT COUNT(DISTINCT(games))
FROM OLYMPICS_HISTORY
WHERE season = 'Summer';

-- sports
SELECT sport, games
FROM OLYMPICS_HISTORY
WHERE season = 'Summer'
GROUP BY sport, games
ORDER BY games;

-- game_count_per_sport
SELECT s.sport, COUNT(games) AS num_of_games_per_sport
FROM (SELECT sport, games
FROM OLYMPICS_HISTORY
WHERE season = 'Summer'
GROUP BY sport, games) AS s
GROUP BY sport;

-- final query 
WITH sport (sport, games) AS
(SELECT sport, games
FROM OLYMPICS_HISTORY
WHERE season = 'Summer'
GROUP BY sport, games), 
game_count_per_sport (sport, num_of_games_per_sport) AS
(SELECT s.sport, COUNT(s.games) AS num_of_games_per_sport
FROM sport as s
GROUP BY sport),
num_of_summer_oly (game_num) AS
(SELECT COUNT(DISTINCT(games)) AS game_num
FROM OLYMPICS_HISTORY
WHERE season = 'Summer')
SELECT gc.sport, gc.num_of_games_per_sport AS no_of_games
FROM game_count_per_sport as gc 
JOIN num_of_summer_oly as so
ON gc.num_of_games_per_sport = so.game_num;


-- PROBLEM 7: 
--Which Sports were just played only once in the olympics?

SELECT sport, COUNT(DISTINCT games) AS no_of_games
FROM OLYMPICS_HISTORY
GROUP BY sport
HAVING COUNT(DISTINCT games) = 1;


--PROBLEM 8:
--Fetch the total number of sports played in each olympic games.

SELECT DISTINCT games, COUNT(DISTINCT sport) AS total_num_of_sports
FROM OLYMPICS_HISTORY
GROUP BY games
ORDER BY COUNT(DISTINCT sport) DESC;


--PROBLEM 9: 
--Fetch details of the oldest athletes to win a gold medal.

SELECT name, sex, age, team, games, city, sport, event
FROM OLYMPICS_HISTORY
WHERE medal = 'Gold' AND 
age IN
(SELECT MAX(age)
FROM OLYMPICS_HISTORY
WHERE medal = 'Gold');

--PROBLEM 10: 
--Find the ratio of male and female athletes participated in all olympic games.

WITH sex_counts (games, mc, fcc) AS 
(SELECT games, COUNT(sex) AS mc, COALESCE((SELECT COUNT(sex) AS fc
FROM OLYMPICS_HISTORY oh
WHERE sex = 'F' AND oh.games = o.games
GROUP BY games),0) AS fcc
FROM OLYMPICS_HISTORY o
WHERE sex = 'M'
GROUP BY games)
SELECT CONCAT('1:',CAST (SUM(mc)*1.00/SUM(fcc)*1.00 AS DECIMAL(3,2))) AS mf_ratio
FROM sex_counts;


--PROBLEM 11: 
--Fetch the top 5 athletes who have won the most gold medals.

SELECT xr.name, xr.gold_medal_count
FROM 
(SELECT *, DENSE_RANK() OVER (ORDER BY xx.gold_medal_count DESC) AS standing
FROM 
(SELECT DISTINCT name, COUNT(medal) OVER (PARTITION BY name) AS gold_medal_count
FROM OLYMPICS_HISTORY
WHERE medal = 'Gold') AS xx) AS xr
WHERE xr.standing <= 5;


--PROBLEM 12: 
--Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

SELECT xx.name, xx.count_ 
FROM 
(SELECT name, COUNT(medal) AS count_, RANK() OVER(ORDER BY COUNT(medal) DESC) AS rnk
FROM OLYMPICS_HISTORY
WHERE medal <> 'NULL'
GROUP BY name) AS xx
WHERE xx.rnk <= 5;

--PROBLEM 13: 
--Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.

SELECT * 
FROM 
(SELECT o.region, SUM(CASE WHEN medal = 'NULL' THEN 0 ELSE 1 END) AS medal_c, RANK() OVER(ORDER BY SUM(CASE WHEN medal = 'NULL' THEN 0 ELSE 1 END) DESC) AS rnk
FROM OLYMPICS_HISTORY oh
JOIN OLYMPICS_HISTORY_NOC_REGIONS o 
ON o.NOC = oh.NOC
GROUP BY region) AS xx
WHERE rnk<= 5;


--PROBLEM 14: 
--List down total gold, silver and broze medals won by each country.

SELECT o.region, SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS gold_count,
SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver_count,
SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_count
FROM OLYMPICS_HISTORY oh
JOIN OLYMPICS_HISTORY_NOC_REGIONS o 
ON o.NOC = oh.NOC
GROUP BY region
ORDER BY gold_count DESC, silver_count DESC, bronze_count DESC;

--PROBLEM 15:
-- List down total gold, silver and broze medals won by each country corresponding to each olympic games.

SELECT games, o.region, SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS gold_count,
SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver_count,
SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_count
FROM OLYMPICS_HISTORY oh
JOIN OLYMPICS_HISTORY_NOC_REGIONS o 
ON o.NOC = oh.NOC
GROUP BY region, games 
ORDER BY games, gold_count DESC, silver_count DESC, bronze_count DESC;

--PROBLEM 16:
-- Identify which country won the most gold, most silver and most bronze medals in each olympic games.

WITH main_table AS
(SELECT games, o.region, SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS gold_count,
SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver_count,
SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_count
FROM OLYMPICS_HISTORY oh
JOIN OLYMPICS_HISTORY_NOC_REGIONS o 
ON o.NOC = oh.NOC
GROUP BY region, games),
non_distinct_final AS 
(SELECT games, CONCAT(FIRST_VALUE(region) OVER(PARTITION BY games ORDER BY gold_count DESC),'-', FIRST_VALUE(gold_count) OVER(PARTITION BY games ORDER BY gold_count DESC)) AS gold,
CONCAT(FIRST_VALUE(region) OVER(PARTITION BY games ORDER BY silver_count DESC),'-', FIRST_VALUE(silver_count) OVER(PARTITION BY games ORDER BY silver_count DESC)) AS silver,
CONCAT(FIRST_VALUE(region) OVER(PARTITION BY games ORDER BY bronze_count DESC),'-', FIRST_VALUE(bronze_count) OVER(PARTITION BY games ORDER BY bronze_count DESC)) AS bronze
FROM main_table)
SELECT DISTINCT games, gold ,silver, bronze
FROM non_distinct_final
ORDER BY games;

--PROBLEM 17:
-- Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.

WITH main_table AS
(SELECT games, o.region, SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS gold_count,
SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver_count,
SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_count,  SUM(CASE WHEN medal = 'NULL' THEN 0 ELSE 1 END) AS max_medal
FROM OLYMPICS_HISTORY oh
JOIN OLYMPICS_HISTORY_NOC_REGIONS o 
ON o.NOC = oh.NOC
GROUP BY games, o.region),
non_distinct_final AS 
(SELECT games, CONCAT(FIRST_VALUE(region) OVER(PARTITION BY games ORDER BY gold_count DESC),'-', FIRST_VALUE(gold_count) OVER(PARTITION BY games ORDER BY gold_count DESC)) AS max_gold,
CONCAT(FIRST_VALUE(region) OVER(PARTITION BY games ORDER BY silver_count DESC),'-', FIRST_VALUE(silver_count) OVER(PARTITION BY games ORDER BY silver_count DESC)) AS max_silver,
CONCAT(FIRST_VALUE(region) OVER(PARTITION BY games ORDER BY bronze_count DESC),'-', FIRST_VALUE(bronze_count) OVER(PARTITION BY games ORDER BY bronze_count DESC)) AS max_bronze,
CONCAT(FIRST_VALUE(region) OVER(PARTITION BY games ORDER BY max_medal DESC),'-', FIRST_VALUE(max_medal) OVER(PARTITION BY games ORDER BY max_medal DESC)) AS max_medal
FROM main_table)
SELECT DISTINCT *
FROM non_distinct_final
ORDER BY games;


--PROBLEM 18:
-- Which countries have never won gold medal but have won silver or bronze medals?

WITH no_gold AS 
(SELECT region, 
SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS gold_count,
SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver_count,
SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_count
FROM OLYMPICS_HISTORY oh
JOIN OLYMPICS_HISTORY_NOC_REGIONS o 
ON o.NOC = oh.NOC
GROUP BY region
HAVING SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) = 0)
SELECT *
FROM no_gold 
WHERE silver_count >=1 OR bronze_count >= 1
ORDER BY silver_count DESC, bronze_count DESC;


--PROBLEM 19:
-- In which Sport/event, India has won highest medals.

SELECT sport, total_medals
FROM
(SELECT sport, SUM(CASE WHEN medal = 'NULL' THEN 0 ELSE 1 END) AS total_medals, RANK() OVER  (ORDER BY SUM(CASE WHEN medal = 'NULL' THEN 0 ELSE 1 END) DESC) AS rnk
FROM OLYMPICS_HISTORY oh
JOIN OLYMPICS_HISTORY_NOC_REGIONS o 
ON o.NOC = oh.NOC
WHERE region = 'India'
GROUP BY sport) AS  xx 
WHERE rnk = 1;


--PROBLEM 20:
-- Break down all olympic games where india won medal for Hockey and how many medals in each olympic games. 

SELECT region, games, sport, SUM(CASE WHEN medal = 'NULL' THEN 0 ELSE 1 END) AS total_medals
FROM OLYMPICS_HISTORY oh
JOIN OLYMPICS_HISTORY_NOC_REGIONS o 
ON o.NOC = oh.NOC
WHERE sport = 'Hockey' AND region = 'India'
GROUP BY region,games, sport
ORDER BY  total_medals DESC;

-- DDL
--OLYMPICS_HISTORY table 

CREATE TABLE OLYMPICS_HISTORY
(
    id          INT,
    name        VARCHAR(500),
    sex         VARCHAR(500),
    age         VARCHAR(500),
    height      VARCHAR(500),
    weight      VARCHAR(500),
    team        VARCHAR(500),
    noc         VARCHAR(500),
    games       VARCHAR(500),
    year        INT,
    season      VARCHAR(500),
    city        VARCHAR(500),
    sport       VARCHAR(500),
    event       VARCHAR(500),
    medal       VARCHAR(500)
);

-- OLYMPICS_HISTORY_NOC_REGIONS Table 

CREATE TABLE OLYMPICS_HISTORY_NOC_REGIONS
(
    noc         VARCHAR(500),
    region      VARCHAR(500),
    notes       VARCHAR(500)
);


-- Importing Data

-- OLYMPICS_HISTORY Table
COPY OLYMPICS_HISTORY 
FROM '/Users/dustintucker/Downloads/Olympics_data (1)/athlete_events.csv' WITH CSV HEADER;

-- OLYMPICS_HISTORY_NOC_REGIONS

COPY OLYMPICS_HISTORY_NOC_REGIONS
FROM '/Users/dustintucker/Downloads/Olympics_data (1)/noc_regions.csv' WITH CSV HEADER;




