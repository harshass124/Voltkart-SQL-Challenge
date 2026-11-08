/*
QUESTION 3: TOP 3 PRODUCTS BY REVENUE IN EACH CATEGORY

Objective:
Identify the top three revenue-generating products within each product category based on completed orders.

Approach:
1. Joined fact_order_items with fact_orders to identify completed orders.
2. Joined dim_product and dim_category to retrieve product and category details.
3. Calculated total revenue for each product using SUM(line_amount).
4. Used DENSE_RANK() with PARTITION BY category to rank products within each category.
5. Filtered the results to include the top three ranks.

SQL Concepts:
- Multiple JOINs
- GROUP BY
- SUM()
- DENSE_RANK()
- Common Table Expressions (CTEs)
- Window Functions
*/

WITH ProductRevenue AS
(
    -- Join the four tables
    -- Filter completed orders
    -- Calculate SUM(line_amount)
    -- GROUP BY category and product
    
 SELECT 
        c.category_name,
        p.product_name,
        SUM(o.line_amount) AS Total_revenue
       
FROM 
    fact_order_items o 
              LEFT JOIN fact_orders f ON o.order_id=f.order_id
              LEFT JOIN dim_product p ON o.product_id=p.product_id
              LEFT JOIN dim_category c ON p.category_id=c.category_id
             WHERE f.order_status='Completed'
Group BY c.category_name,
        p.product_name
       

),
RankedProducts AS
(
    -- Apply DENSE_RANK()
    -- PARTITION BY category
    -- ORDER BY total_revenue DESC

    SELECT *,DENSE_RANK() OVER( Partition By category_name order by Total_revenue DESC) as revenue_rank
    FROM ProductRevenue
)

-- Select the required columns
-- Filter revenue_rank <= 3
SELECT * FROM RankedProducts
WHERE revenue_rank<=3;

