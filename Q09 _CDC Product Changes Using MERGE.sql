/*
QUESTION 9: CDC PRODUCT CHANGES USING MERGE

Objective:
Apply product changes from the CDC change feed (cdc_product_changes) to dim_product using a single MERGE statement.

Approach:
1. Used dim_product as the target table.
2. Used cdc_product_changes as the source table.
3. Matched records using product_id.
4. Applied UPDATE operations for records marked with operation 'U'.
5. Applied DELETE operations for records marked with operation 'D'.
6. Inserted new products for records marked with operation 'I' that were not present in the target table.
7. Used the MERGE OUTPUT clause to capture affected product records and identify the action performed.
8. Verified the INSERT, UPDATE and DELETE actions.

SQL Concepts:
- MERGE Statement
- Change Data Capture (CDC)
- Conditional UPDATE and DELETE
- INSERT
- OUTPUT Clause
- COALESCE()
*/



DECLARE @MergeActions TABLE
(
    ActionType NVARCHAR(10),
    product_id BIGINT,
    product_name NVARCHAR(255))


MERGE dim_product AS T
USING cdc_product_changes AS S
ON T.product_id=S.product_id


WHEN MATCHED AND S.operation = 'U' THEN 
UPDATE 
SET
    T.product_name = S.product_name,
    T.category_id = S.category_id,
    T.unit_price = S.unit_price,
    T.unit_cost = S.unit_cost,
    T.launch_date = S.launch_date

WHEN MATCHED AND S.operation='D' THEN DELETE
WHEN NOT MATCHED AND S.operation='I' THEN
INSERT(product_id,product_name,category_id,unit_price,unit_cost,launch_date)
VALUES(S.product_id,S.product_name,S.category_id,S.unit_price,S.unit_cost,S.launch_date)


OUTPUT 
    $action,
    COALESCE(inserted.product_id, deleted.product_id),
    COALESCE(inserted.product_name, deleted.product_name)
INTO @MergeActions;
Select * from @MergeActions
      
 SELECT
    ActionType,
    COUNT(*) AS total_products
FROM @MergeActions
GROUP BY ActionType;

