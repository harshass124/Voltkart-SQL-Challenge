/*
QUESTION 2: CUSTOMERS WHO NEVER PLACED AN ORDER

Objective:
Identify customers who have never placed an order.

Approach:
1. Used dim_customer as the main table.
2. Used a correlated NOT EXISTS subquery to check whether an order exists for each customer.
3. Returned only customers for whom no matching record was found in fact_orders.
4. Included customer ID, customer name and signup date in the output.

SQL Concepts:
- Correlated Subquery
- NOT EXISTS
*/

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
