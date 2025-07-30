-- CTE: Calculate daily transaction revenue from GA data
WITH Revenues AS (
  SELECT
    PARSE_DATE('%Y%m%d', date) AS raw_date,  -- Convert raw date string to DATE
    SUM(totals.transactionRevenue) AS daily_revenue  -- Sum revenue in micros per day
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  WHERE totals.transactions IS NOT NULL  -- Filter sessions with transactions
    AND _TABLE_SUFFIX BETWEEN '20170501' AND '20170731'  -- Limit to 3 months
    AND PARSE_DATE('%Y%m%d', date) BETWEEN DATE('2017-05-01') AND DATE('2017-07-31')  -- Extra safety
  GROUP BY raw_date
)

-- Final SELECT: Daily and Monthly revenue metrics with formatted labels
SELECT
  daily_revenue / 1000 AS daily_revenue_k,  -- Convert to thousands for readability
  SUM(daily_revenue) OVER (PARTITION BY FORMAT_DATE('%b %Y', raw_date)) / 1000 AS monthly_revenue_k,  -- Monthly total
  FORMAT_DATE('%d %b %Y', raw_date) AS day_label,  -- Label for charts
  FORMAT_DATE('%b %Y', raw_date) AS month_label
FROM Revenues
ORDER BY raw_date;
