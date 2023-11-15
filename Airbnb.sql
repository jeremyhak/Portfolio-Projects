/* 

Traveling to Europe anytime soon? The Airbnb project might be just for you.

Welcome to another beginner friendly sql project which is a part of my sql series for beginners - just like me.
Who doesn’t love the feeling for planning our next vacation or quick get away trip.
✈️ step 1 : Choosing the destination and booking the flights.
🏠 step 2 : Finding a wonderful place to stay at.
We will be looking for  a modern or charming place, central or in the rural era so we can enjoy the gift of nature.It really depends if your goal is to explore or to relax.
To find the place that suits our needs and to understand better the airbnb dataset ,we’ll ask some questions that hopefully we’ll be able to answer with sql!


*/
-- DATASET: https://www.kaggle.com/datasets/dipeshkhemani/airbnb-cleaned-europe-dataset/data

SELECT * FROM airbnb.aemf1;


-- 1. how many properties are there in each city? whats their average price?

SELECT City, COUNT(City) AS total , CONCAT(ROUND(AVG(Price)),'$') AS AVG_night_Price
FROM airbnb.aemf1
GROUP BY City
ORDER BY AVG_night_Price DESC;


-- 2. How many room types are there? their total? whats their average price per category ?

ALTER TABLE airbnb.aemf1
CHANGE COLUMN `Private Room` PrivateRoom VARCHAR(255);

ALTER TABLE airbnb.aemf1
CHANGE COLUMN `Room Type` RoomType VARCHAR(255);

SELECT RoomType, COUNT(RoomType) AS RoomCount, ROUND(AVG(Price)) AS AveragePrice
FROM airbnb.aemf1
GROUP BY RoomType
ORDER BY RoomCount DESC;

-- 3. How many apartments are just 2km from the center and have an above 90 guest satisfaction in Amsterdam?
ALTER TABLE airbnb.aemf1
CHANGE COLUMN `City Center (km)` CityCenter VARCHAR(255);

ALTER TABLE airbnb.aemf1
CHANGE COLUMN `Guest Satisfaction` GuestSatisfaction VARCHAR(255);
 
SELECT City, COUNT(City) AS Total ,ROUND(CityCenter) AS "KM From Center" ,CONCAT(GuestSatisfaction,'%') AS "Guest Satisfaction" 
FROM airbnb.aemf1
WHERE City = "Amsterdam" AND ROUND(CityCenter) <2 AND  GuestSatisfaction > 90
GROUP BY City, ROUND(CityCenter), GuestSatisfaction
ORDER BY Total DESC LIMIT 5;


 -- 4.which city has a highest avg of guest satisfaction? whats the pct of superhost? 

SELECT City, SUM(CASE WHEN PrivateRoom lIKE "%TRUE%" THEN 1 ELSE 0 END) AS total_privateroom,
CONCAT(ROUND((SUM(CASE WHEN PrivateRoom lIKE "%TRUE%" THEN 1 ELSE 0 END)/COUNT(RoomType)*100),1),'%') AS PCT,
CONCAT(ROUND(AVG(GuestSatisfaction),1),'%') AS "Guest Satisfaction"  
FROM airbnb.aemf1
GROUP BY City;



 -- 5. Whats the percentage of Person capacity per room in Rome?
ALTER TABLE airbnb.aemf1
CHANGE COLUMN `Person Capacity` PersonCap INT;
 
 SELECT City, COUNT(City), PersonCap, CONCAT(ROUND(AVG(Price), 2),'$') AS AVG_PRICE
 FROM airbnb.aemf1
 WHERE City = "Rome"
 GROUP BY City,PersonCap
 ORDER BY AVG_PRICE ASC;
 
