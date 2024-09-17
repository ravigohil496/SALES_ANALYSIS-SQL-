-- SQL sales Analysis--

use retail_sales
DROP table if exists sales;
create table sales (
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,	
	customer_id	INT,
	gender VARCHAR(15),
	age	INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT

					);

-- DATA CLEANING--
SELECT *   FROM [retail_sales].[dbo].[SQL - Retail Sales Analysis_utf ];

SELECT count(*) FROM [retail_sales].[dbo].[SQL - Retail Sales Analysis_utf ];

SELECT *   FROM [retail_sales].[dbo].[SQL - Retail Sales Analysis_utf ]
WHERE 
transactions_id IS NULL 
OR 
sale_date IS NULL
OR 
sale_time IS NULL
OR 
customer_id IS NULL
OR 
gender IS NULL
OR 
category IS NULL
OR 
quantiy IS NULL
OR 
cogs IS NULL
OR
total_sale IS NULL
;

DELETE FROM [retail_sales].[dbo].[SQL - Retail Sales Analysis_utf ]
WHERE 
transactions_id IS NULL 
OR 
sale_date IS NULL
OR 
sale_time IS NULL
OR 
customer_id IS NULL
OR 
gender IS NULL
OR 
category IS NULL
OR 
quantiy IS NULL
OR 
cogs IS NULL
OR
total_sale IS NULL
;

--DATA EXPLORATION--

--How many sales we have>--

select count(transactions_id) AS total_sales
FROM [retail_sales].[dbo].[SQL - Retail Sales Analysis_utf ];

-- How many unique customers do we have?--

SELECT count(DISTINCT customer_id) AS total_customer
FROM [retail_sales].[dbo].[SQL - Retail Sales Analysis_utf ];


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * from [retail_sales].[dbo].[SQL - Retail Sales Analysis_utf ]
where sale_date ='2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

SELECT 
  *
FROM  [retail_sales].[dbo].[SQL - Retail Sales Analysis_utf ]
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantiy >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,sum(total_sale) AS total_sale
from  [retail_sales].[dbo].[SQL - Retail Sales Analysis_utf ]
group by category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category,avg(age) AS avg_age
from [retail_sales].[dbo].[SQL - Retail Sales Analysis_utf ]
where category ='Beauty'
group by category;


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select transactions_id,total_sale
from [retail_sales].[dbo].[SQL - Retail Sales Analysis_utf ]
where total_sale>1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT gender,category,count(transactions_id)
FROM [retail_sales].[dbo].[SQL - Retail Sales Analysis_utf ]
group by gender,category
order by gender;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
	SELECT 
       year,
       month,
       avg_sale
FROM 
(    
SELECT 
    YEAR(sale_date) as year,
    MONTH(sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM [retail_sales].[dbo].[SQL - Retail Sales Analysis_utf ]
GROUP BY YEAR(sale_date), MONTH(sale_date)
) as t1
WHERE rank = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT TOP 5 ( customer_id),sum(total_sale) AS total_sale
FROM [retail_sales].[dbo].[SQL - Retail Sales Analysis_utf ]
group by customer_id
order by total_sale DESC;



-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM [retail_sales].[dbo].[SQL - Retail Sales Analysis_utf ]
GROUP BY category


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale AS
(
    SELECT *,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END as shift
    FROM [retail_sales].[dbo].[SQL - Retail Sales Analysis_utf ]
)
SELECT 
    shift,
    COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift;
