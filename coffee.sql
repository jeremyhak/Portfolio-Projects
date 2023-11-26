https://www.kaggle.com/datasets/michals22/coffee-dataset 

SELECT * FROM coffee.coffee_production;


-- coffee production dataset

-- 1. What are the top 5 producing countries in 1990?

SELECT Country, `1990/91` AS Quantity
FROM coffee.coffee_production
ORDER BY Quantity DESC LIMIT 5;

-- 2. What are the top 5 producing countries in 2020 ? growth since 1990 inc pct?
SELECT Country, `2019/20`/1000000 AS Quantity_2020_M,
CONCAT(ROUND( ((`2019/20`-`1990/91`)/`1990/91` )*100),'%') AS "Growth %"
FROM coffee.coffee_production
ORDER BY Quantity_2020_M DESC LIMIT 5;


-- 3. percentage of of total production of every country during the whole time periode 

SELECT Country, ROUND(((Total_production/SUM(Total_production) OVER ())*100),2) AS pct
FROM coffee.coffee_production
ORDER BY pct DESC;



-- coffee imports dataset

SELECT * FROM coffee.coffee_import;


-- 4. Countries who imports the most between 1990-1998? 1998-2020? all in pct 

-- 1990-1998
ALTER TABLE coffee.coffee_import
ADD COLUMN TOTAL1998 BIGINT;

UPDATE coffee.coffee_import
SET TOTAL1998 = `1990` + `1991` + `1992` + `1993` + `1994` + `1995` + `1996` + `1997` + `1998`
WHERE Country IS NOT NULL;


SELECT TRIM(Country) AS Country , ROUND(TOTAL1998/1000000,2) AS Total_IN_M,
ROUND(((TOTAL1998/(SUM(TOTAL1998) OVER()))*100),3) AS PCT,
ROUND((Total_import-TOTAL1998)/1000000,2) AS Total_IN_M_1998_2020

FROM coffee.coffee_import
ORDER BY Total_IN_M DESC;


-- 5. Countries who imports the most between 1998-2020? all in pct 

WITH NEW_RESULTS  AS (
SELECT Total_import - TOTAL1998 AS Cleantotal,
Country
FROM coffee.coffee_import

)

SELECT  TRIM(Country), ROUND(Cleantotal/1000000,2) AS "Total in millions " , ROUND((Cleantotal/(SUM(Cleantotal) OVER())*100),2) AS  PCT
FROM NEW_RESULTS
ORDER BY PCT DESC;


-- joining impoters consumption and import  

-- 6. Does a country uses all that it imports between 2010-2019? whats the pct?
CREATE TABLE coffee.import_consumption AS
SELECT
    TRIM(c.Country) AS Country,
    c.2010 AS `2010_c`,
    c.2011 AS `2011_c`,
    c.2012 AS `2012_c`,
    c.2013 AS `2013_c`,
    c.2014 AS `2014_c`,
    c.2015 AS `2015_c`,
    c.2016 AS `2016_c`,
    c.2017 AS `2017_c`,
    c.2018 AS `2018_c`,
    c.2019 AS `2019_c`,
    i.2010 AS `2010_i`,
    i.2011 AS `2011_i`,
    i.2012 AS `2012_i`,
    i.2013 AS `2013_i`,
    i.2014 AS `2014_i`,
    i.2015 AS `2015_i`,
    i.2016 AS `2016_i`,
    i.2017 AS `2017_i`,
    i.2018 AS `2018_i`,
    i.2019 AS `2019_i`
FROM
    coffee.coffee_importers_consumption c
JOIN
    coffee.coffee_import i ON TRIM(c.Country) = TRIM(i.Country);
    
    
SELECT * FROM coffee.import_consumption;

SELECT Country, ROUND(((2010_i - 2010_c )/ 2010_i)*100,2) AS PCT
FROM coffee.import_consumption
ORDER BY PCT DESC;


-- 7. What is the consumtion growth from 2010 till 2019 in pct?

SELECT * FROM coffee.import_consumption;

SELECT Country, CONCAT(ROUND(((2019_c - 2010_c)/2019_c)*100,2),'%') PCT
FROM coffee.import_consumption
WHERE ((2019_c - 2010_c)/2019_c)*100 IS NOT NULL
ORDER BY ((2019_c - 2010_c)/2019_c)*100 DESC;
