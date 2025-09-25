select 
year(order_date) as order_year , 
Sum(sales_amount) as Total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales 
where order_date is not null
group by year(order_date) 
order by year(order_date) 


select 
datetrunc(month,order_date) as order_date , 
Sum(sales_amount) as Total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales 
where order_date is not null
group by datetrunc(month,order_date) 
order by datetrunc(month,order_date)