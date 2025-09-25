/* Group customers into three segments based on their spending behaviour:
  1. vip - customer with atleast 12 months of history and spending more than $5000.
  2. regular - customers with at least 12 months of history but spending $5000 or less.
  3. new - customers with a lifespan less than 12 months.
  and find the total number of customers by each group
  */
with spending_power as (
	  select 
	  c.customer_key,
	  sum(sales_amount) as total_spending,
	  min(order_date) as first_date,
	  max(order_date) as last_date,
	  datediff(month,min(order_date),max(order_date)) as lifespan
	  from gold.fact_sales f
	  left join gold.dim_customers c
	  on f.customer_key = c.customer_key
	  group by c.customer_key)

select
customer_segments,
count(customer_key) as total_customers
from(
	select 
	customer_key,
	case 
		when lifespan >=12 and total_spending >5000 then 'vip'
		when lifespan >=12 and total_spending <=5000 then 'Regular'
		else 'new'
	end as customer_segments
	from spending_power) t
group by customer_segments
order by total_customers desc


