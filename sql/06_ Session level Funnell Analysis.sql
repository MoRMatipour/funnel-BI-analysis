-- SESSION-LEVEL ECOMMERCE FUNNEL ANALYSIS
-- This analysis tracks how far each session progresses through the ecommerce funnel.
-- Funnel Stages:
--   Step 1: Visited Site (all sessions)
--   Step 2: Viewed Any Page
--   Step 3: Reached Checkout
--   Step 4: Transaction Completed

-- ✅ Step 1: Extract and flatten raw GA session + hit-level data
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

-- ✅ Step 2: Create funnel flags per session
-- For each session, mark whether it reached each funnel milestone.
session_flags AS (
  SELECT
    session_id,
    user_id,
    visitStartTime,

    1 AS visited_site_flag,  -- All sessions start at Step 1

    -- Step 2: Any non-empty page view
    MAX(IF(hit_type = 'PAGE' AND page_path IS NOT NULL AND page_path != '', 1, 0)) AS page_view_flag,

    -- Step 3: Reached checkout (action_type = 2)
    MAX(IF(ecommerce_action_type = 2, 1, 0)) AS checkout_flag,

    -- Step 4: Transaction occurred
    MAX(IF(total_transactions IS NOT NULL AND total_transactions > 0, 1, 0)) AS transaction_flag

  FROM base_data
  GROUP BY session_id, user_id, visitStartTime
),

-- ✅ Step 3: Assign each session to the final (deepest) funnel step it reached
funnel_steps AS (
  SELECT
    session_id,
    user_id,
    CASE
      WHEN transaction_flag = 1 THEN 'Step 4: Transaction Completed'
      WHEN checkout_flag = 1 THEN 'Step 3: Reached Checkout'
      WHEN page_view_flag = 1 THEN 'Step 2: Viewed Any Page'
      ELSE 'Step 1: Visited Site'
    END AS last_step_reached
  FROM session_flags
),

-- ✅ Step 4: Count sessions at each last step
funnel_summary AS (
  SELECT
    last_step_reached,
    COUNT(*) AS session_count
  FROM funnel_steps
  GROUP BY last_step_reached
),

-- ✅ Step 5: Get total number of sessions
total_sessions AS (
  SELECT COUNT(*) AS total FROM session_flags
),

-- ✅ Step 6: Combine all steps with total sessions included as Step 1 baseline
final_summary AS (
  -- Include Step 1 with total sessions
  SELECT
    'Step 1: Visited Site (Total Sessions)' AS last_step_reached,
    total AS session_count
  FROM total_sessions

  UNION ALL

  -- Add the remaining funnel milestones
  SELECT
    last_step_reached,
    session_count
  FROM funnel_summary
  WHERE last_step_reached != 'Step 1: Visited Site'
)

-- ✅ Step 7: Final output with % share of total sessions per step
SELECT
  last_step_reached,
  session_count,
  ROUND(100.0 * session_count /
        (SELECT session_count
         FROM final_summary
         WHERE last_step_reached = 'Step 1: Visited Site (Total Sessions)'), 2)
         AS percentage_of_total_sessions
FROM final_summary
ORDER BY
  CASE
    WHEN last_step_reached = 'Step 1: Visited Site (Total Sessions)' THEN 1
    WHEN last_step_reached = 'Step 2: Viewed Any Page' THEN 2
    WHEN last_step_reached = 'Step 3: Reached Checkout' THEN 3
    WHEN last_step_reached = 'Step 4: Transaction Completed' THEN 4
    ELSE 5
  END;
