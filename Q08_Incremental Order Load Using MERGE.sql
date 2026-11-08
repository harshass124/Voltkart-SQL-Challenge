/*
QUESTION 8: INCREMENTAL ORDER LOAD USING MERGE

Objective:
Perform an incremental load from stg_orders_incr into fact_orders by updating existing orders and inserting new orders.

Approach:
1. Used fact_orders as the target table.
2. Used stg_orders_incr as the source table.
3. Matched records using order_id.
4. Updated the order_status and order_total for existing orders.
5. Inserted new orders that were not present in the target table.
6. Used MERGE OUTPUT to capture affected records and identify INSERT and UPDATE actions.
7. Verified the load by comparing the row counts before and after execution.

SQL Concepts:
- MERGE Statement
- INSERT
- UPDATE
- OUTPUT Clause
- Table Variables
- Data Verification
*/

-- Step 1: Capture row count BEFORE MERGE
DECLARE @RowsBefore BIGINT;

SELECT @RowsBefore = COUNT_BIG(*)
FROM dbo.fact_orders;


-- Step 2: Store the details of inserted and updated rows
DECLARE @MergeActions TABLE
(
    ActionType NVARCHAR(10),
    order_id BIGINT,
    order_status NVARCHAR(50),
    order_total DECIMAL(18,2)
);


-- Step 3: Perform incremental load
MERGE dbo.fact_orders AS T
USING dbo.stg_orders_incr AS S

ON T.order_id = S.order_id

-- If order already exists, update its status and total
WHEN MATCHED THEN
    UPDATE SET
        T.order_status = S.order_status,
        T.order_total = S.order_total

-- If order does not exist, insert it
WHEN NOT MATCHED BY TARGET THEN
    INSERT
    (
        order_id,
        order_date,
        customer_id,
        sales_rep_id,
        order_status,
        order_total
    )
    VALUES
    (
        S.order_id,
        S.order_date,
        S.customer_id,
        S.sales_rep_id,
        S.order_status,
        S.order_total
    )

-- Capture the action performed by MERGE
OUTPUT
    $action,
    inserted.order_id,
    inserted.order_status,
    inserted.order_total
INTO @MergeActions;

-- Step 4: Capture row count AFTER MERGE
DECLARE @RowsAfter BIGINT;

SELECT @RowsAfter = COUNT_BIG(*)
FROM dbo.fact_orders;


-- Step 5: Verify row count before versus after
SELECT
    @RowsBefore AS row_count_before,
    @RowsAfter AS row_count_after,
    @RowsAfter - @RowsBefore AS net_rows_added;


-- Step 6: View sample of updated rows
SELECT TOP 10
    order_id,
    order_status,
    order_total
FROM @MergeActions
WHERE ActionType = 'UPDATE'
ORDER BY order_id;


-- Optional: Check how many records were inserted versus updated
SELECT
    ActionType,
    COUNT(*) AS records_processed
FROM @MergeActions
GROUP BY ActionType;
