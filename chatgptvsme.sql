SELECT * FROM sales.customers;

ALTER TABLE sales.customers
CHANGE COLUMN `Total Spend` TotalSpend varchar(255);

-- 1. What are the top 5 customer segments based on total spend?


ALTER TABLE sales.customers
CHANGE COLUMN `Membership Type` MembershipType varchar(255);

SELECT MembershipType, CONCAT(ROUND(SUM(TotalSpend),2),'$') AS Total
FROM sales.customers
GROUP BY MembershipType
ORDER BY Total DESC;

-- chatgpt:
SELECT `Membership Type`, SUM(`Total Spend`) AS TotalSpend
FROM sales.customersgpt
GROUP BY `Membership Type`
ORDER BY TotalSpend DESC
LIMIT 5;





-- 2. How many customers have made a purchase in the last month?


ALTER TABLE sales.customers
CHANGE COLUMN `Days Since Last Purchase` LastPurchase varchar(255);

ALTER TABLE sales.customers
CHANGE COLUMN `Customer ID` ID varchar(255);

SELECT COUNT(ID) AS "Number Of Customers",  LastPurchase
FROM sales.customers
WHERE LastPurchase < 30
GROUP BY LastPurchase
ORDER BY LastPurchase ASC LIMIT 10;



-- chatgpt:


SELECT `Days Since Last Purchase`, COUNT(*) AS NumberOfCustomers
FROM sales.customersgpt
GROUP BY `Days Since Last Purchase`
HAVING `Days Since Last Purchase` <= 30;






-- 3. What is the average age of customers in each city?

SELECT City,ROUND(AVG(AGE)) AS AVG_AGE FROM sales.customers
GROUP BY City
ORDER BY AVG_AGE;

-- chatgpt:

SELECT City, AVG(Age) AS AverageAge
FROM sales.customersgpt
GROUP BY City;





-- 4.Which cities have the lowest total spending in the last three months?

SELECT City, CONCAT(ROUND(SUM(TotalSpend)),'$') AS Total FROM sales.customers
GROUP BY City
ORDER BY Total ASC LIMIT 5;

-- chatgpt:
SELECT City, SUM(`Total Spend`) AS TotalSpending
FROM sales.customersgpt
WHERE `Days Since Last Purchase` <= 90
GROUP BY City
ORDER BY TotalSpending ASC
LIMIT 5;




-- 5.What is the total profite for each membership type?
SELECT * FROM sales.customers;

ALTER TABLE sales.customers
ADD Totalcost INT;

UPDATE sales.customers
SET Totalcost = ROUND()*TotalSpend
WHERE Totalcost IS NULL;


SELECT MembershipType, CONCAT(ROUND(SUM(TotalSpend)-SUM(Totalcost),2),'$') AS Revenue
FROM sales.customers
GROUP BY MembershipType
ORDER BY Revenue DESC;

-- chatgpt:

ALTER TABLE sales.customersgpt
ADD COLUMN `Total Cost` NUMERIC(10, 2);

-- Update Total Cost with random values less than Total Spend
UPDATE sales.customersgpt
SET `Total Cost` = ROUND(RAND() * `Total Spend`, 2);

-- Select Membership Type and Total Profit (Total Spend - Total Cost)
SELECT
    `Membership Type`,
    SUM(`Total Spend` - COALESCE(`Total Cost`, 0)) AS TotalProfit
FROM
    sales.customersgpt
GROUP BY
    `Membership Type`;





-- 6.Who are the top 3 customers with the highest average satisfaction level?

SELECT * FROM sales.customers;

ALTER TABLE sales.customers
CHANGE COLUMN `Average Rating` AverageRating float;

SELECT ID, ROUND(AVG(AverageRating),2) AS AVG_Rating FROM sales.customers
GROUP BY ID
ORDER BY AVG_Rating DESC LIMIT 5;

-- chatgpt:


SELECT
    `Customer ID`,
    AVG(CAST(`Satisfaction Level` AS DECIMAL(3, 2))) AS AvgSatisfactionLevel
FROM
    sales.customersgpt
GROUP BY
    `Customer ID`
ORDER BY
    AvgSatisfactionLevel DESC
LIMIT 3;



SELECT
    `Customer ID`,
    AVG(CAST(`Average Rating` AS DECIMAL(3, 2))) AS AvgRating
FROM
    sales.customersgpt
GROUP BY
    `Customer ID`
ORDER BY
    AvgRating DESC
LIMIT 5;




-- 7.What is the average number of days between purchases for each gender?

SELECT * FROM sales.customers;


SELECT Gender,ROUND(AVG(LastPurchase),2) AS " Average Last Purchase"
FROM sales.customers
GROUP BY Gender;



-- chatgpt:

SELECT
    Gender,
    AVG(`Days Since Last Purchase`) AS AvgDaysBetweenPurchases
FROM
    sales.customersgpt
GROUP BY
    Gender;
