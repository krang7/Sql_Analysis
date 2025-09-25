-- calculate the total sales per month
-- running of total of sales over time

--window function
select 
order_date,
total_sales,
sum(total_sales) over (order by order_date) as running_total_sales,
avg(avg_price) over (order by order_date) as running_avg_price
from
(select 
datetrunc(year, order_date) as order_date,
sum(sales_amount) as total_sales,
avg(price) as avg_price
from gold.fact_sales
where order_date is not null
group by datetrunc(year, order_date)
)sub_query
