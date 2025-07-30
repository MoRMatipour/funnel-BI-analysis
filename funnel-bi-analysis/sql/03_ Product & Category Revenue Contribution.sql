-- Step 1: Analyze total revenue and quantity by product category
SELECT
  product.v2ProductCategory AS product_category,  -- Product category (e.g., Apparel, Accessories)
  SUM(product.productQuantity) AS total_quantity_sold,  -- Total number of units sold
  SUM(IFNULL(hit.transaction.transactionRevenue, 0)) / 1000000 AS total_revenue_usd_millions  -- Revenue in millions (USD)
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
  UNNEST(hits) AS hit,
  UNNEST(hit.product) AS product
WHERE _TABLE_SUFFIX BETWEEN '20170501' AND '20170731'  -- Filter: May to July 2017
  AND product.v2ProductCategory IS NOT NULL
  AND product.v2ProductCategory != '(not set)'  -- Remove uncategorized products
GROUP BY product.v2ProductCategory
ORDER BY total_revenue_usd_millions DESC;  -- Sort by highest revenue categories

-- Step 2: Analyze top products by quantity and revenue
SELECT
  product.v2ProductName AS product_Name,  -- Product name (e.g., T-Shirt, Notebook)
  SUM(SAFE_CAST(product.productQuantity AS INT64)) AS total_quantity_sold,  -- Total quantity sold
  SUM(IFNULL(hit.transaction.transactionRevenue, 0)) / 1000000 AS total_revenue_usd_millions  -- Revenue in millions (USD)
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
  UNNEST(hits) AS hit,
  UNNEST(hit.product) AS product
WHERE _TABLE_SUFFIX BETWEEN '20170501' AND '20170731'  -- Filter: May to July 2017
  AND product.v2ProductName IS NOT NULL
  AND product.v2ProductName != '(not set)'  -- Exclude untracked items
GROUP BY product.v2ProductName
HAVING total_quantity_sold > 0 AND total_revenue_usd_millions > 0  -- Keep only active products
ORDER BY total_revenue_usd_millions DESC;  -- Sort by highest revenue products
