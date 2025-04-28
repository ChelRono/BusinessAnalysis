select *
from practise.customers;

select *
from practise.inventory;

select *
from practise.products;

select *
from practise.sales;


--CUSTOMER ANALYSIS

--Find the total number of customers and categorize them based on their membership status.
select membership_status, count(*) as num_of_customers
from practise.customers
group by membership_status ;

--Calculate the average amount spent by each customer in the last 6 months.
select customer_id, sale_date , avg(total_amount) as avg_per_customer
from practise.sales 
where sale_date >= '2021-06-01'
group  by customer_id, sale_date  ;

--List the top 5 customers who have spent the most in the past year.
select customers.customer_id,first_name , last_name , sale_date ,avg(total_amount) as avg_per_customer
from practise.customers
inner join practise.sales
	on customers.customer_id = sales.customer_id
where sale_date >= '2021-01-01'
group  by customers.customer_id, sale_date 
order by avg_per_customer desc
limit 5;


--PRODUCT PERFORMANCE

--Find the most sold product by quantity in the last month.
select  products.product_id ,product_name , sum(quantity_sold) as total_quantity_sold
from practise.sales
inner join practise.products
	on sales.product_id = products.product_id
where sale_date >= '2022-01-01'	
group by  products.product_id, product_name   
order by total_quantity_sold   desc
limit 1;

--Find the least sold product by quantity in the last month.
select sales.product_id, product_name , sum(quantity_sold) as total_quantity_sold
from practise.sales
inner join practise.products
	on sales.product_id = products.product_id
group by sales.product_id, product_name
order by total_quantity_sold   asc
limit 1;

--Calculate the total sales per product (revenue) in the last quarter.
select sales.product_id, product_name  , sum(total_amount) as total_sales
from practise.sales
inner join practise.products
	on sales.product_id = products.product_id
group by sales.product_id , product_name 
order by sales.product_id ;

select products.product_id, products.product_name, sum( sales .total_amount) as total_items_sold_
from products
left join sales 
	on  sales .product_id = products.product_id
group by products.product_id, products.product_name;

--SALES ANALYSIS

--Calculate the total sales revenue generated in the last month.
select sum(total_amount) as total_sales_revenue
from practise.sales;

--Identify the peak sales days of the week and suggest which days are best for promotions.
select to_char(sale_date, 'Day') as day_of_the_week, sum(quantity_sold) as total_day_sales, sum(total_amount)as total_sales_amount
from practise.sales
group by day_of_the_week   
order by total_day_sales desc;  -- Wednesday and Friday are the peak sales day

--Find the products that generated the highest revenue in the last 3 months.
select sales.product_id, product_name  , sum(total_amount) as total_sales
from practise.sales
inner join practise.products
	on sales.product_id = products.product_id
group by sales.product_id , product_name 
order by total_sales desc ;


--INVENTORY ANALYSIS

--Identify products that need reordering based on sales trends (if stock level is below a threshold).
select inventory.product_id,product_name  ,inventory.stock_quantity, sum(quantity_sold) as total_quantity_sold
from practise.inventory
inner join practise.sales
	on inventory.product_id = sales.product_id
inner join practise.products
	on sales.product_id = products.product_id
group by inventory.product_id, product_name 
order by inventory.product_id asc;

--Track the product stock changes over the past 6 months.
select products.product_id, products.stock_quantity, sum(quantity_sold) as total_sold, (products.stock_quantity  - sum(quantity_sold)) as remaining_stock 
from practise.products
inner join practise.sales
	on products.product_id = sales.product_id
group by products.product_id 
order by products.product_id ;

--Create a report showing products with stock levels and how many days of sales the current inventory can cover.