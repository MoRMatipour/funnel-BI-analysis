--  Funnel Analysis: User-Level Funnel Completion Across Sessions
-- This query identifies the highest funnel step each user reached, then aggregates totals per step.
-- Funnel Steps:
--   Step 1: Visited Site (all users)
--   Step 2: Viewed Any Page
--   Step 3: Reached Checkout
--   Step 4: Transaction Completed

--  STEP 1: Load and prepare hit-level data
WITH base_data AS (
  SELECT
    visitId AS session_id,
    fullVisitorId AS user_id,
    visitStartTime,
    PARSE_DATE('%Y%m%d', date) AS session_date,
    totals.transactions AS total_transactions,
    totals.transactionRevenue AS total_revenue,
    hits.type AS hit_type,
    hits.page.pagePath AS page_path,
    CAST(hits.eCommerceAction.action_type AS INT64) AS ecommerce_action_type
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
    UNNEST(hits) AS hits
  WHERE
    _TABLE_SUFFIX BETWEEN '20170701' AND '20170731'
),

--  STEP 2: Flag funnel actions at the session level
session_flags AS (
  SELECT
    user_id,
    session_id,

    -- Step 2: Page Viewed in Session
    MAX(IF(hit_type = 'PAGE' AND page_path IS NOT NULL AND page_path != '', 1, 0)) AS page_view_flag,

    -- Step 3: Checkout Reached
    MAX(IF(ecommerce_action_type = 2, 1, 0)) AS checkout_flag,

    -- Step 4: Transaction Completed
    MAX(IF(total_transactions IS NOT NULL AND total_transactions > 0, 1, 0)) AS transaction_flag

  FROM base_data
  GROUP BY user_id, session_id
),

--  STEP 3: Aggregate funnel steps at the user level
user_flags AS (
  SELECT
    user_id,
    MAX(page_view_flag) AS page_view_flag,
    MAX(checkout_flag) AS checkout_flag,
    MAX(transaction_flag) AS transaction_flag
  FROM session_flags
  GROUP BY user_id
),

--  STEP 4: Assign highest funnel step reached by each user
funnel_steps AS (
  SELECT
    user_id,
    CASE
      WHEN transaction_flag = 1 THEN 'Step 4: Transaction Completed'
      WHEN checkout_flag = 1 THEN 'Step 3: Reached Checkout'
      WHEN page_view_flag = 1 THEN 'Step 2: Viewed Any Page'
      ELSE 'Step 1: Visited Site'
    END AS last_step_reached
  FROM user_flags
),

--  STEP 5: Count users per last step reached
funnel_summary AS (
  SELECT
    last_step_reached,
    COUNT(*) AS user_count
  FROM funnel_steps
  GROUP BY last_step_reached
),

-- STEP 6: Count total users (Step 1)
total_users AS (
  SELECT COUNT(*) AS total FROM user_flags
),

--  STEP 7: Combine total users with funnel breakdown
final_summary AS (
  SELECT
    'Step 1: Visited Site (Total Users)' AS last_step_reached,
    total AS user_count
  FROM total_users

  UNION ALL

  SELECT
    last_step_reached,
    user_count
  FROM funnel_summary
  WHERE last_step_reached != 'Step 1: Visited Site'
)

--  STEP 8: Final output with percentage of total users per step
SELECT
  last_step_reached,
  user_count,
  ROUND(100.0 * user_count / (SELECT user_count FROM final_summary WHERE last_step_reached = 'Step 1: Visited Site (Total Users)'), 2) AS percentage_of_total_users
FROM final_summary
ORDER BY
  CASE
    WHEN last_step_reached = 'Step 1: Visited Site (Total Users)' THEN 1
    WHEN last_step_reached = 'Step 2: Viewed Any Page' THEN 2
    WHEN last_step_reached = 'Step 3: Reached Checkout' THEN 3
    WHEN last_step_reached = 'Step 4: Transaction Completed' THEN 4
    ELSE 5
  END;
