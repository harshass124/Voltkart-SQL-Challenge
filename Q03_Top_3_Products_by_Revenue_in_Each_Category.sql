 -- 3.Merchandising wants the stars of each category. For every category, return the
 -- top 3 products by completed revenue. Required output: 
 -- total_revenue, 
 -- revenue_rank.
 -- Core
 -- category_name, 
 -- product_name

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

