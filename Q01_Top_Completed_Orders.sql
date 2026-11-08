/*
QUESTION 1: TOP 20 COMPLETED ORDERS

Objective:
Retrieve the top 20 highest-value completed orders along with customer and sales representative details.

Approach:
1. Used fact_orders as the primary table.
2. Joined dim_customer to retrieve customer names.
3. Joined dim_employee to retrieve sales representative names.
4. Filtered records to include only completed orders.
5. Used ORDER BY in descending order of order_total and TOP 20 to identify the highest-value orders.

SQL Concepts:
- INNER/LEFT JOIN
- WHERE clause
- ORDER BY
- TOP
*/


SELECT TOP 20
       f.order_id,
       f.order_date,
       c.customer_name,
       e.employee_name,
       f.order_total 
FROM fact_orders f 
   LEFT JOIN dim_customer c ON f.customer_id=c.customer_id 
   LEFT JOIN dim_employee e ON f.sales_rep_id=e.employee_id
WHERE f.order_status= 'Completed'
Order By f.order_total DESC
