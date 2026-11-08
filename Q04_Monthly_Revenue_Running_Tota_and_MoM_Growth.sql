-- 4. Finance wants the revenue trend with momentum. Produce
-- monthly completed revenue with a cumulative running total and the month-over-month % 
-- change. Required output: 
-- order_month (YYYY-MM), 
-- monthly_revenue, 
-- running_total, 
-- mom_pct_chang
-- First CTE: Calculate monthly revenue.
-- Second CTE: Calculate running total and previous month's revenue.
-- Final SELECT: Calculate MoM percentage.
  
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


