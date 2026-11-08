--Marketing wants to re-engage people who registered but never bought. List the
--customers who have never placed an order. Required output: 
--customer_id, 
--customer_name, 
--signup_date.

SELECT c.customer_id,c.customer_name, c.signup_date 
FROM dim_customer c 
WHERE NOT EXISTS(

                   SELECT 1 FROM fact_orders o
                   WHERE c.customer_id=o.customer_id)


-- Check total customers
SELECT COUNT(*) AS total_customers
FROM dbo.dim_customer;

-- Check distinct customers who placed at least one order
SELECT COUNT(DISTINCT customer_id) AS customers_with_orders
FROM dbo.fact_orders;