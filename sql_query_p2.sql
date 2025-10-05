CREATE TABLE RETAIL_SALES(
  transactions_id INT PRIMARY KEY,
  sale_date DATE,
  sale_time TIME,
  customer_id INT,
  gender VARCHAR(10),
  age INT,
  category VARCHAR(50),
  quantiy INT,
  price_per_unit FLOAT,
  cogs FLOAT,
  total_sale FLOAT
);


SELECT COUNT(*) FROM RETAIL_SALES;
--Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
SELECT * FROM  RETAIL_SALES WHERE 
sale_date = '2022-11-05';
--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select * from RETAIL_SALES where category = 'Clothing'
and quantiy >= 4
and to_char(sale_date, 'YYYY-MM') = '2022-11';

--------Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT CATEGORY, 
SUM(total_sale) as net_sale,
count(*)  as total_order FROM RETAIL_SALES
group by CATEGORY
----Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
 select avg(age) FROM RETAIL_SALES where 
 category = 'Beauty' ;

 -------------Write a SQL query to find all transactions where the total_sale is greater than 1000.
 select * from RETAIL_SALES where total_sale > 1000

 --------Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
 select count(transactions_id),gender ,category from RETAIL_SALES
 group by gender , category

 ---------------------Write a SQL query to calculate the average sale for each month. 
 --Find out best selling month in each year

 select year ,month ,avg_sale from 
 (
 select  extract(Year from sale_date) as year,
 extract(Month from sale_date) as month,
 avg(total_sale) as avg_sale,
 rank() OVER(partition by extract (Year from sale_date) order by avg(total_sale) desc) as rank
 from RETAIL_SALES
 group by 1 ,2) as t1
 where rank = 1;

 -----Write a SQL query to find the top 5 customers based on the highest total sales
SELECT CUSTOMER_ID , SUM(TOTAL_SALE)AS TOTAL_SALE FROM RETAIL_SALES
GROUP BY CUSTOMER_ID
ORDER BY TOTAL_SALE DESC
LIMIT 5;

------------Write a SQL query to find the number of unique customers who purchased items from each category
 
SELECT CATEGORY, 
       COUNT(DISTINCT CUSTOMER_ID)
FROM RETAIL_SALES
GROUP BY CATEGORY

---------------Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift