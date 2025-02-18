WITH RecentMonth AS (
    SELECT MAX(DATE_TRUNC('month', purchase_date)) AS latest_month FROM receipts
)
SELECT b.name AS brand_name, COUNT(r.receipt_id) AS receipt_count
FROM receipts r
JOIN receipt_items ri ON r.receipt_id = ri.receipt_id
JOIN brands b ON ri.brand_id = b.brand_id
WHERE DATE_TRUNC('month', r.purchase_date) = (SELECT latest_month FROM RecentMonth)
GROUP BY b.name
ORDER BY receipt_count DESC
LIMIT 5;

WITH MonthlyRankings AS (
    SELECT 
        b.name AS brand_name, 
        DATE_TRUNC('month', r.purchase_date) AS purchase_month,
        COUNT(r.receipt_id) AS receipt_count,
        RANK() OVER (PARTITION BY DATE_TRUNC('month', r.purchase_date) ORDER BY COUNT(r.receipt_id) DESC) AS rank
    FROM receipts r
    JOIN receipt_items ri ON r.receipt_id = ri.receipt_id
    JOIN brands b ON ri.brand_id = b.brand_id
    WHERE DATE_TRUNC('month', r.purchase_date) >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
    GROUP BY b.name, purchase_month
)
SELECT 
    m1.brand_name, 
    m1.receipt_count AS recent_month_count, 
    m1.rank AS recent_month_rank,
    m2.receipt_count AS previous_month_count, 
    m2.rank AS previous_month_rank
FROM MonthlyRankings m1
LEFT JOIN MonthlyRankings m2 
    ON m1.brand_name = m2.brand_name 
    AND m1.purchase_month = DATE_TRUNC('month', CURRENT_DATE)
    AND m2.purchase_month = DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
WHERE m1.purchase_month = DATE_TRUNC('month', CURRENT_DATE);

SELECT 
    rewards_receipt_status,
    AVG(total_spent) AS avg_spend
FROM receipts
WHERE rewards_receipt_status IN ('Accepted', 'Rejected')
GROUP BY rewards_receipt_status;

SELECT 
    rewards_receipt_status,
    SUM(purchased_item_count) AS total_items
FROM receipts
WHERE rewards_receipt_status IN ('Accepted', 'Rejected')
GROUP BY rewards_receipt_status;

WITH RecentUsers AS (
    SELECT user_id FROM users
    WHERE created_date >= CURRENT_DATE - INTERVAL '6 months'
)
SELECT b.name AS brand_name, SUM(r.total_spent) AS total_spent
FROM receipts r
JOIN receipt_items ri ON r.receipt_id = ri.receipt_id
JOIN brands b ON ri.brand_id = b.brand_id
WHERE r.user_id IN (SELECT user_id FROM RecentUsers)
GROUP BY b.name
ORDER BY total_spent DESC
LIMIT 1;

WITH RecentUsers AS (
    SELECT user_id FROM users
    WHERE created_date >= CURRENT_DATE - INTERVAL '6 months'
)
SELECT b.name AS brand_name, COUNT(r.receipt_id) AS transaction_count
FROM receipts r
JOIN receipt_items ri ON r.receipt_id = ri.receipt_id
JOIN brands b ON ri.brand_id = b.brand_id
WHERE r.user_id IN (SELECT user_id FROM RecentUsers)
GROUP BY b.name
ORDER BY transaction_count DESC
LIMIT 1;
