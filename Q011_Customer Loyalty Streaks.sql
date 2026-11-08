/*
QUESTION 11: CUSTOMER LOYALTY STREAKS

Objective:
Identify the longest consecutive run of calendar months in which each customer placed at least one completed order.

Approach:
1. Identified distinct customer and month combinations from completed orders.
2. Used DATEFROMPARTS() to normalize order dates to the first day of each month.
3. Applied ROW_NUMBER() to assign sequential numbers to each customer's active months.
4. Used DATEDIFF() and ROW_NUMBER() together to identify consecutive month groups using the Gaps and Islands technique.
5. Grouped consecutive months and counted the number of months in each streak.
6. Used MAX() to identify the longest streak for each customer.
7. Joined with dim_customer to retrieve customer names.

SQL Concepts:
- DISTINCT
- DATEFROMPARTS()
- ROW_NUMBER()
- DATEDIFF()
- Window Functions
- Gaps and Islands Technique
- GROUP BY
- MAX()
- Common Table Expressions (CTEs)
*/

WITH CustomerMonths AS
(
    SELECT DISTINCT
        customer_id,
        DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS orderMonth
    FROM fact_orders
    WHERE order_status = 'Completed'
),
NumberedMonths AS
(
    SELECT
        customer_id,
        orderMonth,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY orderMonth
        ) AS month_number
    FROM CustomerMonths
),
MonthGroups AS
(
    SELECT
        customer_id,
        orderMonth,
        DATEDIFF(
            MONTH,
            MIN(orderMonth) OVER (PARTITION BY customer_id),
            orderMonth
        ) - month_number AS group_id
    FROM NumberedMonths
),
StreakLengths AS
(
    SELECT
        customer_id,
        group_id,
        COUNT(*) AS streak_months
    FROM MonthGroups
    GROUP BY customer_id, group_id
),
LongestStreak AS
(
    SELECT
        customer_id,
        MAX(streak_months) AS longest_streak_months
    FROM StreakLengths
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.customer_name,
    ls.longest_streak_months
FROM LongestStreak ls
INNER JOIN dim_customer c
    ON ls.customer_id = c.customer_id
ORDER BY c.customer_id;
