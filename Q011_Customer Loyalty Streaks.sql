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