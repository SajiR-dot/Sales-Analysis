SELECT * FROM superstore

--TOTAL SALES
SELECT SUM(sales) FROM superstore

--Top 5 states by sales

SELECT state, sum(sales) as Total_sales
FROM superstore
GROUP BY state
ORDER BY sum(sales) DESC
LIMIT 5;

-- Top  5 states by profit
SELECT state, sum(profit) as Total_profit
FROM superstore
GROUP BY state
ORDER BY sum(profit) DESC
LIMIT 5;

-- Top 5  products by profit
SELECT product_name,sum(profit) AS total_profit
FROM superstore
GROUP BY product_name
ORDER BY sum(profit) DESC
LIMIT 5;

--products with heavy loss

SELECT product_name, sum(profit) AS total_profit
FROM superstore
GROUP BY product_name
HAVING SUM(profit)<0
ORDER BY total_profit 
LIMIT 10;

-- Monthly trends for total sales
SELECT TO_CHAR(DATE_TRUNC('month',order_date),'YYYY-MM') as month,
sum(sales) as total_sales
from superstore
group by month
order by month

--Average shipping delay

SELECT AVG(ship_date - order_date) AS avg_shipping_delay
FROM superstore;

-- Most profitable categories
SELECT category,SUM(profit) as total_profit
FROM superstore
GROUP BY category
ORDER BY total_profit DESC

-- sales and profit for each month

SELECT TO_CHAR(order_date,'Mon') AS month,
EXTRACT (MONTH FROM order_date) AS month_number,
ROUND(SUM(sales),2) as total_sales,
ROUND(SUM(profit),2) as total_profit
FROM superstore
GROUP BY month,month_number
ORDER by month_number

--WHICH Quarter has highest revenue
SELECT EXTRACT(QUARTER FROM Order_date) AS quarter,
SUM(sales) as total_sales
FROM superstore
GROUP BY quarter
ORDER BY total_sales DESC

--Which year had the highest sales and profit
SELECT EXTRACT(YEAR FROM Order_date) AS year,
SUM(sales) as total_sales,
SUM(profit) as total_profit
FROM superstore
GROUP BY year
ORDER BY total_sales DESC

--Does shipping time vary by region or ship mode

SELECT region,ship_mode,AVG(ship_date-order_date) AS avg_shipping_days
FROM superstore
GROUP BY region,ship_mode
ORDER BY region,ship_mode

--Which shipping method is most used and most profitable?

SELECT ship_mode,SUM(profit) as total_profit
FROM superstore
GROUP BY ship_mode
ORDER BY total_profit DESC

--correlation between profit and discount
SELECT corr(discount,profit) AS discount_profit_correlation
FROM superstore

--Are higher discounts leading to losses?

SELECT AVG(discount) AS avg_discount_on_losses
FROM superstore
WHERE profit < 0;

SELECT AVG(discount) AS avg_discount_on_profits
FROM superstore
WHERE profit >= 0;

--Average quantity sold per product

SELECT product_name,ROUND(AVG(quantity),2) AS avg_quantity
FROM superstore
GROUP BY product_name
ORDER BY avg_quantity DESC
LIMIT 5
 

--Are there products with high sales but low quantity (expensive items)?

SELECT product_name,SUM(sales) AS total_sales,SUM(quantity) as total_quantity
FROM superstore
GROUP BY product_name
HAVING SUM(quantity)<(SELECT AVG(Quantity) FROM superstore) AND SUM(sales)>(SELECT AVG(Sales) FROM superstore)
ORDER BY total_sales DESC

-- Classifying products whether expensive or cheap
SELECT product_name,category,sub_catgory,SUM(sales) as total_sales,SUM(quantity) AS total_quantity,SUM(profit) AS total_profit,

CASE 
WHEN SUM(sales)>(SELECT AVG(sales) FROM superstore)
		AND SUM(quantity)<(SELECT AVG(quantity) FROM superstore) THEN 'Expensive'

WHEN SUM(sales)>(SELECT AVG(sales) FROM superstore)
AND SUM(quantity)<=(SELECT AVG(quantity) FROM superstore) THEN 'Popular'
ELSE 'Cheap'
END AS product_type
FROM superstore
GROUP BY product_name,category,sub_catgory
ORDER BY total_profit DESC

--Profit Margin
SELECT product_name,
SUM(sales) as total_sales,
SUM(profit) as total_profit,
ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100,2) as profit_margin_percent
FROM superstore
GROUP BY product_name
ORDER BY profit_margin_percent DESC

		

