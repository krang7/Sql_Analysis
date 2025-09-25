/* Customer Report

	Purpose:- this report consolidates key customer metrics and behaviour

Highlights:-
	1. gathers essential feilds such as names, ages, and transaction details.
	2. segment customer into categories(vip,regular,new) and age group.
	3. aggregates customer-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- life span (in months)
	4. Calculate KPIs:
		- recency(months since last order)
		- average order value
		- average monthly spend 
*/

create view gold_report_customers as
with base_query as(
/*1. Base query: retrieves core columns from tables*/
select
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
concat(first_name, ' ', last_name) as Full_name,
datediff(year,c.birthdate, getdate()) as Age
from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key = f.customer_key
where order_date is not null )

, customer_segments as (
/* Customer Aggregations: summarizes key metrics at the customer level*/
select
	customer_key,
	customer_number,
	Full_name,
	Age,
	count(distinct order_number) as total_orders,
	sum(sales_amount) as total_sales,
	sum(quantity ) as total_quantity,
	count(distinct product_key) as total_products,
	max(order_date) as last_order_date,
	datediff(month,min(order_date),max(order_date)) as lifespan
from base_query
group by
	customer_key,
	customer_number,
	Full_name,
	Age)

select
	customer_key,
	customer_number,
	Full_name,
	Age,
	case 
		when age < 20 then 'below-20'
		when age between 20 and 29 then '20-29'
		when age between 30 and 39 then '30-39'
		when age between 40 and 49 then '40-49'
		else '50-above'
	end as Age_range,
	case 
		when lifespan >= 12 and total_sales >5000 then 'VIP'
		when lifespan >= 12 and total_sales <5000 then 'regular'
		else 'New'
	end as customer_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	last_order_date,
	datediff(month,last_order_date,getdate()) as recency,
	lifespan,
	--compute average order value
	case
		when total_orders = 0  then 0
		else total_sales/total_orders 
	end as average_order_value,
	-- average monthly spend
	case
		when lifespan= 0 then total_sales
		else total_sales/lifespan
	end as avg_monthly_spends
from customer_segments



select*from gold_report_customers