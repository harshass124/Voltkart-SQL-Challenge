# Voltkart SQL Challenge

## Project Overview

This repository contains my solutions to the Voltkart SQL Challenge, completed using Microsoft SQL Server.

The objective of this project was to solve practical SQL problems involving data retrieval, analysis, hierarchical relationships, data loading, and query performance optimization.

## Tools Used

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- GitHub

## SQL Concepts Covered

| Topic | Concepts |
|---|---|
| Data Retrieval | SELECT, WHERE, ORDER BY, TOP |
| Joins | INNER JOIN, LEFT JOIN, ANTI JOIN |
| Subqueries | Correlated subqueries, NOT EXISTS |
| Aggregations | SUM, COUNT, AVG, GROUP BY |
| Window Functions | ROW_NUMBER, DENSE_RANK, NTILE, LAG |
| CTEs | Common Table Expressions |
| Recursive CTEs | Category hierarchy and employee reporting structure |
| Data Loading | MERGE for incremental loads |
| Change Data Capture | INSERT, UPDATE and DELETE operations |
| Performance Optimization | Indexing, SARGable predicates, logical reads and execution plans |
| Date Analysis | Monthly revenue, running totals and consecutive-month streaks |

## Project Structure

- `SQL_Answers/` – SQL solutions for all 11 questions.
- `Screenshots/` – Query outputs and execution evidence.

## Performance Optimization

For the performance tuning task, I compared the original query with an optimized version.

The optimization involved:
- Replacing `YEAR(order_date) = 2024` with a date range predicate.
- Creating nonclustered indexes.
- Rewriting the correlated subquery using CTEs and grouped aggregations.
- Comparing logical reads and execution plans.

### Logical Reads Comparison

| Table | Before | After |
|---|---:|---:|
| fact_orders | 384 | 142 |
| fact_order_items | 267 | 187 |
| **Total** | **651** | **329** |

The optimized query reduced total logical reads by approximately **49.5%**.

## Learning Outcomes

Through this challenge, I gained practical experience in writing SQL queries, working with hierarchical data, implementing incremental data loads, handling CDC operations, and analyzing query performance.

## Author

SQL Server Practice Project – Voltkart SQL Challenge
