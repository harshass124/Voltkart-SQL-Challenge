/*
QUESTION 5: CUSTOMER SPENDING QUARTILES

Objective:
Segment customers into four quartiles based on their lifetime completed-order spending.

Approach:
1. Joined dim_customer with fact_orders.
2. Calculated each customer's lifetime completed-order spending using SUM(order_total).
3. Used NTILE(4) to divide customers into four approximately equal-sized groups based on spending.
4. Grouped customers by quartile.
5. Calculated the customer count and average lifetime spending for each quartile.

SQL Concepts:
- JOIN
- GROUP BY
- SUM()
- NTILE()
- Window Functions
- Common Table Expressions (CTEs)
*/

WITH Life_time_spend AS
(
SELECT c.customer_id, c.customer_name,SUM(o.order_total) AS Total_order

  FROM 
       dim_customer c 
     LEFT JOIN
       fact_orders o 
 ON c.customer_id=o.customer_id
 Where o.order_status='Completed'
 Group by c.customer_id, c.customer_name
 ),
 Quartile_CTE AS
 (
 SELECT *,NTILE(4) OVER(ORDER BY Total_order ) AS Qtl FROM Life_time_spend
 )
SELECT
    Qtl,
    COUNT(*) AS customer_count,
    ROUND (AVG(Total_order) ,2)AS avg_lifetime_spend
FROM Quartile_CTE
GROUP BY Qtl
ORDER BY Qtl;


