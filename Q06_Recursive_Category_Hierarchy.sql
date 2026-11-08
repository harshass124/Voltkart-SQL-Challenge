-- 6. The catalogue team needs to see everything under a part of the tree. Using a
-- recursive query, list all categories in the subtree rooted at 'Computers' at any depth, with 
-- how deep each sits and a readable path from Computers. Required output: 
-- category_id, 
-- category_name, 
-- depth_level, 
-- category_path.

WITH OrgCTE AS
(
  SELECT category_id,
         category_name,
         0 AS depth_level,
         CAST(category_name AS VARCHAR(MAX)) AS category_path
 FROM dim_category c
 WHERE category_name='Computers'

 UNION ALL
 
  SELECT c.category_id,
         c.category_name,
        cte.depth_level+1,
         CAST(cte.category_path+'->'+ c.category_name AS VARCHAR(MAX))
 FROM dim_category c
 INNER JOIN OrgCTE cte ON c.parent_category_id=cte.category_id



)
SELECT 
         category_id,
         category_name,
         depth_level,
         category_path 
from OrgCTE 
order by depth_level,category_id

