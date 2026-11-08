-- Warmup-Question1: Return the top 20 completed orders by value,
-- including the customer name and the sales rep name.
-- Required output: order_id, order_date, customer_name,
--                  sales_rep_name, order_total

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