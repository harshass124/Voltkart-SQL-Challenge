-- 5. The CRM team wants to size up the customer base by value. Split customers into
-- four quartiles by lifetime completed spend, and for each quartile report how many 
-- customers fall in it and their average spend. Required output: 
-- customer_count, 
-- avg_lifetime_spend

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


