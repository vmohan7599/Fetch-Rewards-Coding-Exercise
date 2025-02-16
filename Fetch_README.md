# Fetch Rewards Coding Exercise - Analytics Engineer
This repository contains my solution for the Fetch Rewards Analytics Engineer coding exercise.
It includes:
- A structured relational database model derived from the provided JSON data.
- SQL queries to answer key business questions.
- Data quality analysis to identify potential issues.
- A stakeholder communication message summarizing findings.

## Folder Structure
- `Fetch_Rewards_Solution.docx` - The complete solution document.
- `ER_Diagram.png` - The database schema diagram.
- `queries.sql` - SQL scripts for the business questions.
- `data_quality_analysis.py` - Python script used for data validation.

## SQL Queries
The following business questions are answered using SQL:
1. Top 5 brands by receipts scanned for the most recent month.
2. Comparison of top brands from the recent month vs. previous month.
3. Comparison of average spend on `Accepted` vs. `Rejected` receipts.
4. Brand with the highest spend among users created in the last 6 months.

## Data Quality Issues
During analysis, the following data inconsistencies were found:
- **Missing values** in `purchaseDate` and `totalSpent`.
- **Orphaned foreign keys** where receipts reference non-existing users.
- **Duplicate user records** that may impact analytics.
- **Future-dated transactions**, indicating potential ingestion errors.

## How to Run
To run the SQL queries, use PostgreSQL or any compatible SQL engine.
For data validation, run the Python script:
```sh
python data_quality_analysis.py

