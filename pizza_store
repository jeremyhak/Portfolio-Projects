/*  In this project, I am conducting an analysis of complete orders from a pizza store. 
Throughout the project, I have developed a total of 12 queries, encompassing various levels of complexity.
I have presented the data gatherd from queries on Tablau. */


*/

-- 1. finding the total revenu of all pizza orders 

SELECT ROUND(SUM(total_price)) AS Total_Revenu FROM pizza.pizza_sales;

-- 2. average order value 
SELECT SUM(total_price) / COUNT(DISTINCT order_id)  AS AVG_Order_val FROM pizza.pizza_sales;

-- 3. total pizza sold 
SELECT SUM(quantity) AS total_pizza_sold FROM pizza.pizza_sales;


-- 4. total orders made
SELECT COUNT( DISTINCT order_id) AS toal_orders FROM pizza.pizza_sales;

-- 5. average pizzas per order
SELECT SUM(quantity)/ COUNT(DISTINCT order_id) AS AVG_Pizzas_per_order FROM pizza.pizza_sales;


-- 6. Hourly trend for total pizzas sold 

SELECT extract(HOUR FROM order_time) as order_hour, SUM(quantity) AS  Total_pizzas_sold 
FROM pizza.pizza_sales
GROUP BY extract(HOUR FROM order_time) 
ORDER BY extract(HOUR FROM order_time);


-- 7. Weekly trend for total pizzas sold 

SELECT WEEK(STR_TO_DATE(order_date, '%d-%m-%Y'), 3) AS week_number,YEAR(STR_TO_DATE(order_date, '%d-%m-%Y')) AS Order_year, COUNT(DISTINCT order_id) AS Total_orders
FROM pizza.pizza_sales
GROUP BY  WEEK(STR_TO_DATE(order_date, '%d-%m-%Y'), 3), YEAR(STR_TO_DATE(order_date, '%d-%m-%Y'))
ORDER BY WEEK(STR_TO_DATE(order_date, '%d-%m-%Y'), 3), YEAR(STR_TO_DATE(order_date, '%d-%m-%Y')); 


-- 8. percentage and amount of sales per category per month
SELECT pizza_category,SUM(total_price) AS Total_Sales ,SUM(total_price)*100 / 
(SELECT SUM(total_price) FROM pizza.pizza_sales WHERE MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) =1 ) AS pct
FROM pizza.pizza_sales 
WHERE MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) =1
GROUP BY pizza_category;

-- 9. percentage and amount of sales per size per month

SELECT pizza_size,CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Sales  ,CAST(SUM(total_price)*100 / 
(SELECT SUM(total_price) FROM pizza.pizza_sales WHERE quarter(STR_TO_DATE(order_date, '%d-%m-%Y')) = 1) AS DECIMAL(10,2)) AS pct
FROM pizza.pizza_sales 
WHERE quarter(STR_TO_DATE(order_date, '%d-%m-%Y')) =1
GROUP BY pizza_size
ORDER BY pct DESC;

-- 10. TOP 5 number of sales per category of pizza name

SELECT pizza_name ,CAST(sum(total_price) AS DECIMAL(10,2)) AS total_sold FROM pizza.pizza_sales 
GROUP BY pizza_name
ORDER BY total_sold DESC LIMIT 5;

-- 11. BOTTOM 5 number of sales per category of pizza name

SELECT pizza_name ,CAST(sum(total_price) AS DECIMAL(10,2)) AS total_sold FROM pizza.pizza_sales 
GROUP BY pizza_name
ORDER BY total_sold ASC LIMIT 5;


-- 12. T0P 5 number of pizzas per category of pizza name

SELECT pizza_name ,sum(quantity) AS total_quantity FROM pizza.pizza_sales 
GROUP BY pizza_name
ORDER BY total_quantity DESC LIMIT 5;
