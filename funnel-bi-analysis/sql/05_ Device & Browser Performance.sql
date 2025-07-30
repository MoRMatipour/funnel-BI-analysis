-- Device Category Performance Summary
SELECT
  device.deviceCategory,  -- Device type (desktop, mobile, tablet)

  COUNT(*) AS total_visits,  -- Total number of sessions from this device

  ROUND(SUM(IFNULL(totals.transactionRevenue, 0)) / 1000000, 2) AS total_revenue_million_usd,  -- Revenue in millions (USD)

  ROUND(SUM(IFNULL(totals.transactions, 0)) / COUNT(*), 2) AS average_transactions,  -- Average transactions per session

  ROUND(SUM(IFNULL(totals.bounces, 0)) / COUNT(*) * 100, 2) AS bounce_rate_percent,  -- Bounce rate %

  ROUND(SUM(IFNULL(totals.transactions, 0)) / NULLIF(SUM(IFNULL(totals.visits, 0)), 0), 2) AS conversion_rate  -- Conversion rate

FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20170501' AND '20170731'
  AND device.deviceCategory IS NOT NULL
GROUP BY device.deviceCategory
ORDER BY total_revenue_million_usd DESC;

-- Browser-Level Ecommerce Metrics
SELECT
  device.browser,  -- Browser name (e.g., Chrome, Safari)

  COUNT(*) AS total_visits,  -- Number of sessions

  ROUND(SUM(IFNULL(totals.transactionRevenue, 0)) / 1000000, 2) AS total_revenue_million_usd,  -- Revenue in millions (USD)

  ROUND(SUM(IFNULL(totals.transactions, 0)) / COUNT(*), 2) AS average_transactions,  -- Average transactions per session

  ROUND(SUM(IFNULL(totals.bounces, 0)) / COUNT(*) * 100, 2) AS bounce_rate_percent,  -- Bounce rate %

  ROUND(SUM(IFNULL(totals.transactions, 0)) / NULLIF(SUM(IFNULL(totals.visits, 0)), 0), 2) AS conversion_rate  -- Conversion rate

FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20170501' AND '20170731'
  AND device.browser IS NOT NULL
GROUP BY device.browser
ORDER BY total_revenue_million_usd DESC;
