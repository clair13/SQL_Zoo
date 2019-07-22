-- 1) Write a query to show the population of Germany

SELECT population FROM world
  WHERE name = 'Germany'

--2) Write a query to show the name and population of Sweden, Norway, and Denmark

SELECT name, population FROM world
  WHERE name IN ('Sweden', 'Norway','Denmark');

--3) Write a query to show country and area for countries with an area between 200,000 and 250,000

SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000;