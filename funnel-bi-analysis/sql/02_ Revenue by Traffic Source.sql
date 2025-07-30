-- Step 1: Aggregate total revenue by traffic source
WITH Source_Revenue AS (
  SELECT
    trafficSource.source AS source,  -- Identify the traffic source (e.g., google, direct)
    SUM(IFNULL(totals.transactionRevenue, 0)) AS revenue  -- Sum revenue per source (handle nulls as 0)
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  WHERE _TABLE_SUFFIX BETWEEN '20170501' AND '20170731'  -- Filter data for May to July 2017
    AND totals.transactionRevenue IS NOT NULL  -- Only include sessions with recorded revenue
  GROUP BY source
)

-- Step 2: Calculate revenue share percentage by source
SELECT
  source,
  revenue,
  ROUND(revenue * 100 / SUM(revenue) OVER (), 2) AS revenue_share_percentage  -- % contribution of each source
FROM Source_Revenue
WHERE revenue > 0  -- Exclude sources with zero revenue
ORDER BY revenue DESC;  -- Sort by highest earning sources

