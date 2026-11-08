/*
QUESTION 4: MONTHLY REVENUE ANALYSIS

Objective:
Analyse monthly completed-order revenue, calculate cumulative revenue and measure month-over-month revenue growth.

Approach:
1. Joined fact_orders with fact_order_items.
2. Filtered only completed orders.
3. Grouped transactions by month and calculated monthly revenue using SUM(line_amount).
4. Used SUM() OVER() to calculate the running total of revenue.
5. Used LAG() to retrieve the previous month's revenue.
6. Calculated the month-over-month percentage change using the current and previous month's revenue.

SQL Concepts:
- Date Functions
- GROUP BY
- SUM()
- Window Functions
- LAG()
- NULLIF()
- Common Table Expressions (CTEs)
*/
  
WITH Monthly_Revenue AS
(
  SELECT FORMAT(o.order_date, 'yyyy-MM') AS MonthYear ,Round(sum(line_amount),2) as Total_revenue 
  FROM fact_order_items f Left join fact_orders o on f.order_id=o.order_id
  WHERE order_status='Completed'
  GROUP BY FORMAT(o.order_date, 'yyyy-MM')
), 
running_total as
(
 Select *, 
         SUM(Total_revenue) Over(ORDER BY MonthYear ROWS between UNBOUNDED Preceding and current Row) AS running_Rev ,
         LAG(Total_revenue) OVER(ORDER BY MonthYear) AS Previous_year_Revenue
         FROM Monthly_Revenue
)
SELECT *,
    ROUND(
        ((Total_revenue - Previous_year_Revenue)
        / NULLIF(Previous_year_Revenue, 0)) * 100.0,
        2
    ) AS [MOM%]
FROM running_total
ORDER BY MonthYear;


