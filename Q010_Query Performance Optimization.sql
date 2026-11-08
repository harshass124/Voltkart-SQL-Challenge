/* 10. A report is slow. Here is the query analysts are running:
    SELECT o.customer_id, COUNT(*) AS orders_2024,
           (SELECT SUM(oi.line_amount)
              FROM fact_order_items oi
              JOIN fact_orders o2 ON o2.order_id = oi.order_id
             WHERE o2.customer_id = o.customer_id) AS lifetime_value
    FROM fact_orders o
    WHERE YEAR(o.order_date) = 2024
    GROUP BY o.customer_id;
Turn on 
SET STATISTICS IO, TIME ON and "Include Actual Execution Plan", run it, then make 
it fast: explain what the plan is doing, rewrite the query, and add an index that helps. Required 
output: the rewritten query, the 
CREATE INDEX statement(s), and a short note giving the 
logical reads before versus after and why the plan changed.*/


SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT o.customer_id, COUNT(*) AS orders_2024,
           (SELECT SUM(oi.line_amount)
              FROM fact_order_items oi
              JOIN fact_orders o2 ON o2.order_id = oi.order_id
             WHERE o2.customer_id = o.customer_id) AS lifetime_value
    FROM fact_orders o
    WHERE o.order_date >= '20240101'
  AND o.order_date < '20250101'
    GROUP BY o.customer_id;

   CREATE NONCLUSTERED INDEX IX_fact_orders_order_date
ON dbo.fact_orders (order_date)
INCLUDE (customer_id, order_id);

EXEC sp_helpindex 'dbo.fact_order_items';

CREATE NONCLUSTERED INDEX IX_fact_order_items_order_id
ON dbo.fact_order_items (order_id)
INCLUDE (line_amount);



WITH Orders2024 AS
(
SELECT customer_id,count(*) as orders_2024 FROM fact_orders 
Where order_date>= '20240101'
  AND order_date < '20250101'
  GROUP BY customer_id
),
LifetimeValue AS
(
    SELECT 
           customer_id,
           SUM(line_amount) AS Lifetime_value 
  FROM fact_orders o LEFT JOIN fact_order_items fo ON o.order_id=fo.order_id
  GROUP BY customer_id 

)
 SELECT a.customer_id,b.Lifetime_Value
 FROM Orders2024 a LEFT JOIN LifetimeValue b ON a.customer_id=b.customer_id