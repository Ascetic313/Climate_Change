SELECT *
FROM state_climate
WHERE state = 'Alabama'
LIMIT 5;



-- How the average temperature changes over time in each state.
SELECT
  state,
  year,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1,
  ROUND(AVG(tempc) OVER (
    PARTITION BY state
    ORDER BY year
  ),2) AS 'running_avg_temp'
FROM state_climate
WHERE state = 'Alabama'
LIMIT 5;




-- Lowest temp in each state
SELECT
  state,
  year,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1,
  ROUND(FIRST_VALUE(tempc) OVER(
    PARTITION BY state
    ORDER BY tempc
  ),2) AS lowest_temp
FROM state_climate;



-- Highest temp in each state
SELECT
  state,
  year,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1,
  ROUND(LAST_VALUE(tempc) OVER(
    PARTITION BY state
    ORDER BY tempc
    RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ),2) AS highest_temp
FROM state_climate;



-- Temp change each year in each state, and the largest change, no null
SELECT
  state,
  year,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1,
  ROUND(LAG(tempc,1,0) OVER (
    PARTITION BY state
    ORDER BY year
  ),2) AS change_in_temp
FROM state_climate
ORDER BY change_in_temp DESC;




-- Rank of the coldest temp, not attention on which state, which year
SELECT
  RANK() OVER (
    ORDER BY tempc
  ) AS rank,
  state,
  year,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1
FROM state_climate;




-- Rank of the warmest temp by state
SELECT
  RANK() OVER (
    PARTITION BY state
    ORDER BY tempc DESC
  ) AS rank,
  state,
  year,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1
FROM state_climate;




-- Quartile the tempc by each state, 1st quartile is the coldest years
SELECT
  NTILE(4) OVER (
    PARTITION BY state
    ORDER BY tempc
  ) AS quartile,
  state,
  year,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1
FROM state_climate;




-- Quintile the tempc by each year, 1st quintile is the coldest years overall
SELECT
  NTILE(5) OVER (
    ORDER BY tempc
  ) AS quintile,
  year,
  state,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1
FROM state_climate;