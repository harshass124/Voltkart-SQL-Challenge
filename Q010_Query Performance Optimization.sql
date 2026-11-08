/*
QUESTION 10: QUERY PERFORMANCE OPTIMIZATION

Objective:
Improve the performance of a slow customer order and lifetime revenue query by rewriting the SQL and creating appropriate indexes.

Approach:
1. Analysed the original query using SET STATISTICS IO and SET STATISTICS TIME.
2. Examined the actual execution plan to identify expensive table scans and operations.
3. Replaced YEAR(order_date) = 2024 with a SARGable date-range filter.
4. Rewrote the correlated subquery using Common Table Expressions (CTEs) to separate the 2024 order aggregation and lifetime revenue calculation.
5. Created a nonclustered index on fact_orders(order_date), including customer_id and order_id.
6. Created a nonclustered index on fact_order_items(order_id), including line_amount.
7. Compared logical reads before and after optimization.

Performance Results:
- Original total logical reads: 651
- Optimized total logical reads: 329
- Reduction in logical reads: Approximately 49.5%

SQL Concepts:
- Query Optimization
- SARGable Predicates
- Common Table Expressions (CTEs)
- Nonclustered Indexes
- Included Columns
- Execution Plan Analysis
- SET STATISTICS IO and TIME
*/


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
