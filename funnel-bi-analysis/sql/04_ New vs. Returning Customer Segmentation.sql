-- Step 1: Aggregate user-level metrics across sessions
WITH user_level_data AS (
  SELECT
    fullVisitorId,  -- Unique user identifier
    CASE
      WHEN totals.newVisits IS NULL THEN 'Returning Visitor'  -- Repeat user
      WHEN totals.newVisits = 1 THEN 'New Visitor'            -- First-time visitor
      ELSE 'Unknown'
    END AS visitor_type,

    -- Aggregate metrics for each user
    SUM(IFNULL(totals.transactionRevenue, 0)) AS total_revenue,      -- Total revenue per user (in micros)
    COUNT(*) AS session_count,                                       -- Number of sessions per user
    SUM(IFNULL(totals.bounces, 0)) AS total_bounces,                 -- Total bounce events
    SUM(IFNULL(totals.transactions, 0)) AS total_transactions,       -- Number of transactions
    SUM(IFNULL(totals.timeOnSite, 0)) AS total_time_on_site          -- Total time spent on site (in seconds)
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  WHERE _TABLE_SUFFIX BETWEEN '20170501' AND '20170731'  -- Analyze sessions from May to July 2017
  GROUP BY fullVisitorId, visitor_type
)

-- Step 2: Summarize metrics at the visitor type level
SELECT
  visitor_type,  -- 'New Visitor' or 'Returning Visitor'
  COUNT(fullVisitorId) AS number_of_users,  -- Total users per type
  ROUND(AVG(total_revenue) / 1000000, 2) AS avg_revenue_per_user_usd_million,  -- Average revenue per user (USD, in millions)
  ROUND(SUM(total_revenue) / 1000000, 2) AS total_revenue_usd_million,         -- Total revenue by visitor type (USD)
  SUM(total_transactions) AS total_transactions,                               -- Total transactions by visitor type
  ROUND(SUM(total_time_on_site) / SUM(session_count), 2) AS avg_time_on_site_per_session_sec,  -- Avg. session duration
  ROUND(SUM(total_bounces) / SUM(session_count) * 100, 2) AS bounce_rate_percent               -- Bounce rate %
FROM user_level_data
GROUP BY visitor_type
ORDER BY total_revenue_usd_million DESC;  -- Rank visitor types by total revenue
