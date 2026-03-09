select* from olist_customers_dataset;
select * from olist_geolocation_dataset;
select count(*) from olist_customers_dataset;
select count(*) from olist_geolocation_dataset;

drop table olist_customers_dataset;

truncate table customers_dataset;

TRUNCATE TABLE customers_dataset;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv' 
INTO TABLE customers_dataset 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'; -- Try the simplest line ending first

show warnings;

select* from customers_dataset
order by customer_city;

select customer_zip_code_prefix, trim('"' from customer_zip_code_prefix)	
from customers_dataset;

delete from customers_dataset
where customer_id like '"customer%"';


update customers_dataset
set customer_id = trim('"' from customer_id),
customer_unique_id = trim('"' from customer_unique_id),
customer_zip_code_prefix = trim('"' from customer_zip_code_prefix);

delete from customers_dataset
where customer_id is null or customer_unique_id is null or customer_zip_code_prefix is null or customer_city is null or customer_state is null;
select* from customers_dataset
where customer_id is null or customer_unique_id is null or customer_zip_code_prefix is null or customer_city is null or customer_state is null;

select customer_id, length(customer_id) 
from customers_dataset
limit 20;

select customer_id, length(customer_id) 
from customers_dataset
where length(customer_id) > 32;

select customer_unique_id, length(customer_unique_id),  length(customer_zip_code_prefix)
from customers_dataset
limit 20;

select customer_unique_id, length(customer_unique_id),  length(customer_zip_code_prefix)
from customers_dataset
where length(customer_id) > 32 or length(customer_unique_id) > 32 or length(customer_zip_code_prefix) > 5 ;
select * from customers_dataset;

TRUNCATE table customers_geolocation;
CREATE TABLE `customers_geolocation` (
  `geolocation_zip_code_prefix` varchar(45) DEFAULT NULL,
  `geolocation_lat` varchar(45) DEFAULT NULL,
  `geolocation_lng` varchar(50) DEFAULT NULL,
  `geolocation_city` varchar(50) DEFAULT NULL,
  `geolocation_state` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

update customers_geolocation
set row_num = 1;
insert into customers_geolocation(row_num)
values(1);


select * from customers_geolocation;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset.csv' 
INTO TABLE order_reviews
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
ESCAPED BY '"' -- This treats double-quotes as the escape character
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES;

show warnings;
CREATE TABLE `order_reviews` (
  `review_id` varchar(50) DEFAULT NULL,
  `order_id` varchar(50) DEFAULT NULL,
  `review_score` varchar(30) DEFAULT NULL,
  `review_comment_title` varchar(35) DEFAULT NULL,
  `review_comment_message` varchar(300) DEFAULT NULL,
  `review_creation_date` varchar(35) DEFAULT NULL,
  `review_answer_timestamp` varchar(35) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from order_reviews;

select*from order_items;

select * from products;

select product_category_name, review_score from products as prod
join order_items as ordi
on prod.product_id = ordi.product_id
join order_reviews as ordr
on ordi.order_id = ordr.order_id
where review_score = (select min(review_score) from order_reviews);

CREATE TABLE `order_items` (
  `order_id` varchar(36) DEFAULT NULL,
  `order_item_id` varchar(4) DEFAULT NULL,
  `product_id` varchar(38) DEFAULT NULL,
  `seller_id` varchar(38) DEFAULT NULL,
  `shipping_limit_date` varchar(25) DEFAULT NULL,
  `price` varchar(8)DEFAULT NULL,
  `freight_value` varchar(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `order_payments` (
  `order_id` varchar(50) DEFAULT NULL,
  `payment_sequential` varchar(4) DEFAULT NULL,
  `payment_type` varchar(30) DEFAULT NULL,
  `payment_installments` varchar(5) DEFAULT NULL,
  `payment_value` varchar(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
select * from products;
select * from order_payments;
select shipping_limit_date, length(shipping_limit_date), substring(shipping_limit_date, 12, 8) as time from order_items; 

select * from order_items;

alter table order_items
add shipping_limit_time varchar(11) after shipping_limit_date;

update order_items
set shipping_limit_time = substring(shipping_limit_date, 12, 8);

select * from orders;

select year(order_purchase_timestamp), count(order_purchase_timestamp) from orders
group by year(order_purchase_timestamp);
select * from order_items;
SELECT 
YEAR(order_purchase_timestamp) AS year,
COUNT(*) AS total_orders
FROM orders
GROUP BY year
ORDER BY year;

select customer_state, count(ord.order_id), sum(price) from customers_dataset as cust
join orders as ord
on cust.customer_id = ord.customer_id
join order_items  as ordi
on ord.order_id = ordi.order_id
group by customer_state
order by sum(price) asc;

SELECT 
AVG(order_total) AS avg_order_value
FROM (
    SELECT 
        order_id,
        SUM(payment_value) AS order_total
    FROM order_payments
    GROUP BY order_id
) as t;

select sum(payment_value) from order_payments;

select sum(price + freight_value) from order_items;

SELECT SUM(oi.price + oi.freight_value)
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

SELECT SUM(op.payment_value)
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered';

SELECT o.order_status, 
       SUM(op.payment_value) as total_payment
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY o.order_status;

SELECT o.order_status, 
       SUM(oi.price + oi.freight_value) as total_items
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_status;

select order_status, sum(price + freight_value) as total_item_value, sum(payment_value) as total_payment_value,sum(payment_value) -
 sum(price + freight_value) as difference from orders as ord
join order_payments as ordp
on ord.order_id = ordp.order_id
join order_items as ordi
on ordi.order_id = ordp.order_id
group by order_status; 

SELECT 
    o.order_status,
    SUM(oi.item_total) AS total_item_value,
    SUM(op.payment_total) AS total_payment_value,
    SUM(op.payment_total) - SUM(oi.item_total) AS difference
FROM orders o

JOIN (
    SELECT order_id,
           SUM(price + freight_value) AS item_total
    FROM order_items
    GROUP BY order_id
) oi ON o.order_id = oi.order_id

JOIN (
    SELECT order_id,
           SUM(payment_value) AS payment_total
    FROM order_payments
    GROUP BY order_id
) op ON o.order_id = op.order_id

GROUP BY o.order_status;



select cust.customer_id, sum(price) from customers_dataset as cust
join orders as ord
on cust.customer_id = ord.customer_id
join order_items  as ordi
on ord.order_id = ordi.order_id
group by cust.customer_id
order by sum(price) desc
limit 5;


#revenue per month or revenue monthly trend
select year(order_purchase_timestamp) as year, month(order_purchase_timestamp) as month, sum(ordi.total_payments) as total_revenue
from orders as ord
join ( select order_id,
sum(payment_value) as total_payments from order_payments
group by order_id
) as ordi 
on ord.order_id = ordi.order_id
group by year(order_purchase_timestamp), month(order_purchase_timestamp)
order by year;

with rolling as (
select year(order_purchase_timestamp) as year, month(order_purchase_timestamp) as month, sum(total_payments) as total_revenue
from orders as ord
join ( select order_id,
sum(price + freight_value) as total_payments from order_items
group by order_id
) as ordi 
on ord.order_id = ordi.order_id
where order_status = "delivered"
group by year(order_purchase_timestamp), month(order_purchase_timestamp)
order by year),
sum_rolling as(select year, month, total_revenue, sum(total_revenue) over(order by year, month) as rolling_total from rolling)
select year, month, total_revenue, rolling_total, total_revenue - LAG(total_revenue, 1, 0) OVER (ORDER BY year,month) as growth_per_month
from sum_rolling;

SELECT 
    cust.customer_id, 
    COUNT(DISTINCT o.order_id) AS total_orders, 
    SUM(oi.price + oi.freight_value) AS total_revenue
FROM customers_dataset AS cust
INNER JOIN orders AS o 
    ON cust.customer_id = o.customer_id
INNER JOIN order_items AS oi 
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY cust.customer_id
order by 2;

select count(distinct customer_id) from orders
where order_status = "delivered";

select count(distinct customer_id) from orders;

WITH customer_orders AS (
    SELECT 
        customer_id,
        COUNT(order_id) AS total_orders
    FROM orders
    WHERE order_status = 'delivered'
    GROUP BY customer_id
)

SELECT 
    COUNT(CASE WHEN total_orders > 1 THEN 1 END) 
        / COUNT(*) AS repeat_purchase_rate
FROM customer_orders;

select count(*) as all_orders from order_payments;

select avg(payment_value) from order_payments;

select * from order_items;
select product_category_name, count(order_id), sum(price) from products as prod
join order_items as ordi
on prod.product_id = ordi.product_id
group by product_category_name
order by count(order_id) desc
limit 3;

select customer_state from customers_dataset;

select product_category_name, sum(price) from products as prod
join order_items as ordi
on prod.product_id = ordi.product_id
group by product_category_name
order by sum(price) desc
limit 10;


select max(price) from order_items;

select sum(price) as total_revenue from order_items;

select trim(substring(shipping_limit_date, 12, 8) from shipping_limit_date)
from order_items;

update order_items
set shipping_limit_date = trim(substring(shipping_limit_date, 12, 8) from shipping_limit_date);

select count(order_status) as invoiced_orders from orders
where order_status = "invoiced"
group by order_status;

select order_status, count(order_status) as invoiced_orders from orders
where order_status != "invoiced"
group by order_status;

select distinct(order_status), count(order_status) as invoiced_orders from orders
group by order_status;