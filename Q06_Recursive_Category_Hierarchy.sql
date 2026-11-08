/*
QUESTION 6: RECURSIVE CATEGORY HIERARCHY

Objective:
Retrieve all categories and subcategories under the Computers category, including their depth level and hierarchical path.

Approach:
1. Used a recursive Common Table Expression (CTE).
2. Defined the anchor member to identify the Computers category.
3. Used the recursive member to retrieve child categories through the parent_category_id relationship.
4. Incremented the depth level at every recursion.
5. Built a readable category path using string concatenation.
6. Retrieved the complete category hierarchy under Computers.

SQL Concepts:
- Recursive CTE
- UNION ALL
- Self-Referencing JOIN
- String Concatenation
- DATED/Hierarchy Tracking
*/

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

