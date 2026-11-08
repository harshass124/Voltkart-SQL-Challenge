-- 9. The catalogue source now emits a change feed (
-- operation codes. Apply it to 
-- cdc_product_changes) with
-- dim_product in a single MERGE that honours the codes: I inserts 
-- a new product, U updates an existing one, D deletes it. Acceptance criteria: one MERGE 
-- handling all three operations; include a verification query showing inserted, updated, and 
-- deleted products.



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

