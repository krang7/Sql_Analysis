/* segment products into cost ranges and
count how  many products fall into each segment*/
with product_segments as(
select
product_key,product_name,cost,
case
	when cost < 100 then 'below 100'
	when cost between 100 and 500 then '100-500'
	when cost between 500 and 1000 then '500-1000'
	when cost between 1000 and 1500 then '1000-1500'
	when cost > 1500 then 'above 1500'
	else 'too cheap'
end product_cost_range
from gold.dim_products)
select 
product_cost_range,
count(product_key) as total_product
from product_segments
group by product_cost_range
order by total_product desc