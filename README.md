# User Journey & Conversion Funnel (BigQuery SQL)
Advanced BigQuery + Power BI project analyzing user drop-offs across the e-commerce purchase funnel to drive conversion optimization.


## Project Overview
Online retailers often face high drop-off rates between browsing and purchasing. This project analyzes user journeys through the purchase funnel, identifying bottlenecks and conversion opportunities.
Using Google Analytics e-commerce data in BigQuery and Power BI visualizations, I built an end-to-end analysis system highlighting critical drop-off points and their impact on revenue.

## Objective
In this project, I designed and implemented an end-to-end funnel behavior analysis system using SQL and Google BigQuery:
- Extracted eCommerce user interaction data from the Google Analytics sample dataset available in BigQuery.
- Transformed and prepared the dataset with session-level and user-level behavior logic using advanced SQL techniques, including window functions and conditional aggregation.
- Modeled the funnel into five key eCommerce steps (from landing to transaction) and calculated drop-offs and completion rates across both sessions and users.
- Created visual funnel summaries and behavioral breakdowns for further business intelligence analysis in Power BI.
- As this is a business intelligence project, my emphasis is primarily on the data modeling, querying, and behavioral logic design using SQL, with supplementary dashboarding to support analysis.

The sections below will explain additional details on the structure, queries, and visualizations developed.

## Table of Contents

- [Dataset Used](#dataset-used)
- [Technologies](#technologies)
- [Project Stages and Files](#project-stages-and-files)
- [Key Findings](#key-findings)
- [Recommendations](#recommendations)


## Dataset Used
This project uses the Google Analytics 4 BigQuery eCommerce dataset, which captures user interactions on an online merchandise store. The dataset includes detailed fields such as session and user identifiers, event timestamps, page paths, traffic sources, product views, add-to-cart actions, checkout steps, and purchase transactions.

More information about the dataset can be found at the following links:  
- Website: [GA4 BigQuery Export Documentation](https://support.google.com/analytics/answer/7029846)  
- Sample Dataset: [Google Analytics 4 BigQuery Sample Data](https://console.cloud.google.com/marketplace/product/google/analytics-analytics-data)  
- Schema Reference: [GA4 BigQuery Export Schema](https://support.google.com/analytics/answer/3437719)

## Technologies
The following technologies were used to build and deliver this project:
- Languages: SQL  
- Data Exploration & Transformation: Google BigQuery  
- Data Source: Google Analytics 4 BigQuery Export  
- Dashboard Development: Power BI  

This stack was chosen to replicate a real-world business intelligence workflow, leveraging cloud-based querying, analytical processing, and modern data visualization tools.

## Project Stages and Files
This project is structured into key analytical stages, each reflecting a real-world data analysis workflow, entirely performed using SQL in Google BigQuery.  
- [Step 1: Business Understanding and KPI Design](#step-1-business-understanding-and-kpi-design)  
- [Step 2: Data Exploration and Modeling](#step-2-data-exploration-and-modeling)  
- [Step 3: Revenue & Marketing Channel Analysis](#step-3-revenue--marketing-channel-analysis)  
- [Step 4: Customer Segmentation and Behavioral Profiling](#step-4-product-category--customer-segmentation)  
- [Step 5: Funnel Behavior Analysis](#step-5-device--browser-performance-analysis)  
- [Step 6: Visualization and Insights Dashboard](#step-6-funnel-behavior-analysis-session-level-and-user-level)  
- [Step 7: Visualization and Insights Dashboard](#step-7-visualization-and-insights-dashboard)  

---

### Step 1: Business Understanding and KPI Design
Defined the scope of analysis by translating business goals into measurable KPIs. This involved mapping common ecommerce performance metrics—such as session-based revenue contribution, traffic source performance, and customer behavior trends—into query logic. The business understanding was derived from real-world experience in stakeholder reporting and conversion funnel optimization.  

Designed analytical objectives to assess:  
- Daily and monthly revenue trends for growth benchmarking  
- Traffic source quality and conversion contribution  
- Product and category revenue breakdown  
- New vs. returning customer behavior  
- Device and browser performance metrics  
- Multi-step funnel tracking at session and user level  

This stage helped ensure the analytical logic used in subsequent queries aligned closely with real-world ecommerce performance monitoring.

---

### Step 2: Data Exploration and Modeling  
Analyzed the Google Analytics sample dataset in BigQuery to understand its nested structure and key fields. Used `UNNEST` to flatten repeated data and cleaned placeholder values to prepare for accurate KPI calculations. This groundwork enabled precise revenue, segmentation, and funnel analyses.  

![Sample Schema](https://github.com/MoRMatipour/funnel-BI-analysis/raw/main/screenshots/sample%20schema.png)

---

### Step 3: Revenue & Marketing Channel Analysis  
Measured revenue trends over time and assessed the impact of marketing channels on overall performance.

- **Daily & Monthly Revenue Trends** – Converted raw date strings to standard format, aggregated daily totals, and used window functions for monthly rollups. This revealed clear seasonality and performance peaks.  
You can find the query [here](https://github.com/MoRMatipour/funnel-BI-analysis/blob/main/sql/01_%20Daily%20and%20Monthly%20Revenue%20Trends.sql).
![Monthly and daily Revenues](https://github.com/MoRMatipour/funnel-BI-analysis/blob/main/screenshots/Monthly%20and%20daily%20Revenues.png?raw=true)
May and June 2017 revenue stayed steady ($121M) before rising in July ($124M), with strong weekday sales and weak weekends.
Notable spikes on June 12 ($12.49M) and July 18 ($17M) suggest successful campaigns, while July 4 saw a sharp holiday drop.
Focus opportunities: boost weekend sales, replicate high-performing campaigns, and plan around holiday dips.

- **Revenue by Traffic Source** – Grouped revenue by `trafficSource.source` and calculated each channel’s percentage share. This highlighted the highest-converting acquisition channels.  
You can find the query [here](https://github.com/MoRMatipour/funnel-BI-analysis/blob/main/sql/02_%20Revenue%20by%20Traffic%20Source.sql).
![Revenue by Traffic Sources](https://github.com/MoRMatipour/funnel-BI-analysis/blob/main/screenshots/Revenue%20by%20Traffic%20Source.png?raw=true)
Direct traffic dominates revenue (74%), followed by Google search (20%), with all other sources contributing under 4%.
Strong reliance on two channels signals risk—diversifying acquisition could stabilize revenue.
Niche sources (e.g., Bing, Yahoo, Facebook) show potential for targeted growth.

---

### Step 4: Product, Category & Customer Segmentation  
Evaluated product performance, category contribution, and customer types to guide merchandising and marketing strategies.

- **Product & Category Revenue Contribution** – Used `UNNEST` to access product-level data, aggregated revenue, and filtered out missing categories. The results showed top-performing products and profitable categories.  
You can find the query [here](https://github.com/MoRMatipour/funnel-BI-analysis/blob/main/sql/03_%20Product%20%26%20Category%20Revenue%20Contribution.sql).
![Product Analysis](https://github.com/MoRMatipour/funnel-BI-analysis/blob/main/screenshots/Product%20Analysis.png?raw=true)
Apparel dominates revenue ($1.26B), followed by Office supplies and Lifestyle products. Drinkware and Bags also contribute significantly, while most other categories generate under $150M.

- **New vs. Returning Customer Segmentation** – Segmented users via `totals.newVisits` and calculated revenue, bounce rate, time on site, and transactions per group. This exposed behavioral differences that can guide targeted campaigns.  
You can find the query [here](https://github.com/MoRMatipour/funnel-BI-analysis/blob/main/sql/04_%20New%20vs.%20Returning%20Customer%20Segmentation.sql).
![Customer Segmentation](https://github.com/MoRMatipour/funnel-BI-analysis/blob/main/screenshots/Visitor%20Type%20Analysis.png?raw=true)
Returning visitors generate much higher revenue and stay longer on site with lower bounce rates. Focus on loyalty programs to retain them and increase their value. For new visitors, improve onboarding and targeted offers to boost conversion and reduce bounce rates.

---

### Step 5: Device & Browser Performance Analysis  
Analyzed how different devices and browsers impact user engagement and revenue.

- Grouped users by device category (desktop, mobile, tablet) and browser type. Calculated visits, revenue, bounce rate, and conversion rate for each.  
- These metrics highlight which platforms perform best and reveal areas needing UX or technical improvements.  
You can find the query [here](https://github.com/MoRMatipour/funnel-BI-analysis/blob/main/sql/05_%20Device%20%26%20Browser%20Performance.sql).
![Device Analysis](https://github.com/MoRMatipour/funnel-BI-analysis/blob/main/screenshots/Device%20Analysis.png?raw=true)
Desktop drives the majority of visits and revenue with the highest conversion rate and lower bounce rate. Mobile has many visits but very low revenue and conversion, indicating a need for better mobile optimization. Tablet shows moderate performance but also low conversion, suggesting room for improvement across non-desktop devices.
---

### Step 6: Funnel Behavior Analysis (Session-Level and User-Level)  
- **Session-Level Funnel Analysis:** Tracked funnel steps reached within each session and calculated drop-off rates to identify conversion bottlenecks. 
Tracks how far each session progresses through the ecommerce funnel using GA session and hit-level data.  
Key techniques: CTEs, UNNEST(), conditional aggregation, CASE statements, and percentage calculations.You can find the query [here](https://github.com/MoRMatipour/funnel-BI-analysis/blob/main/sql/06_%20Session%20level%20Funnell%20Analysis.sql).
<details>
  <summary>Click to expand SQL code</summary>

```sql
-- SESSION-LEVEL ECOMMERCE FUNNEL ANALYSIS
-- Tracks session progression through the ecommerce funnel.

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

session_flags AS (
  SELECT
    session_id,
    user_id,
    visitStartTime,
    1 AS visited_site_flag,
    MAX(IF(hit_type = 'PAGE' AND page_path IS NOT NULL AND page_path != '', 1, 0)) AS page_view_flag,
    MAX(IF(ecommerce_action_type = 2, 1, 0)) AS checkout_flag,
    MAX(IF(total_transactions IS NOT NULL AND total_transactions > 0, 1, 0)) AS transaction_flag
  FROM base_data
  GROUP BY session_id, user_id, visitStartTime
),

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

funnel_summary AS (
  SELECT
    last_step_reached,
    COUNT(*) AS session_count
  FROM funnel_steps
  GROUP BY last_step_reached
),

total_sessions AS (
  SELECT COUNT(*) AS total FROM session_flags
),

final_summary AS (
  SELECT
    'Step 1: Visited Site (Total Sessions)' AS last_step_reached,
    total AS session_count
  FROM total_sessions

  UNION ALL

  SELECT
    last_step_reached,
    session_count
  FROM funnel_summary
  WHERE last_step_reached != 'Step 1: Visited Site'
)

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
- **User-Level Funnel Completion Analysis:** Aggregated funnel progress across all sessions per user to reveal long-term engagement and conversion trends. You can find the query [here](https://github.com/MoRMatipour/funnel-BI-analysis/blob/main/sql/07_%20User%20Level%20Funell%20Analysis%20.sql).
- 

These combined views help optimize the ecommerce funnel by showing where users convert or drop off.
![Funells](https://github.com/MoRMatipour/funnel-BI-analysis/blob/main/screenshots/Funell%20Analysis.png?raw=true)

The funnel shows a strong initial engagement with about 85% of sessions and users viewing pages after visiting the site. However, there is a sharp drop-off at checkout, with only around 14% reaching that step and just 1.4-1.6% completing transactions. This indicates major friction or barriers in the checkout process. To boost conversions, focus on simplifying checkout, improving UX, and addressing potential payment or trust issues to reduce drop-offs and increase completed transactions.

---

### Step 7: Visualization and Insights Dashboard  
I imported the results from BigQuery queries directly into Power BI, then created clear and interactive visualizations to showcase key metrics and funnel insights. This dashboard helps business decision-makers easily understand complex data and track performance effectively.
[Here is the link to my Power BI file](https://github.com/MoRMatipour/funnel-BI-analysis/tree/main/Dashboard).
![Dashboard](https://github.com/MoRMatipour/funnel-BI-analysis/blob/main/screenshots/Visualization%20Image.png?raw=true)

## **Key Findings**   
- Only **0.02%** of all sessions completed a purchase, with the largest drop-off occurring before “Product View,” indicating users are not engaging with products early in their journey.  
- Checkout abandonment remains high — nearly **70%** of users who reach checkout never complete the transaction.  
- Returning visitors convert at nearly **3×** the rate of first-time visitors, showing strong potential in retargeting efforts.  
- **Desktop** accounts for **96% of revenue**, with mobile and tablet conversions being almost negligible.  
- Direct and Organic Search channels drive most transactions, while Paid Search shows poor ROI.  
- A few high-value product categories contribute disproportionately to sales, suggesting opportunities for cross-selling and better product placement.  

## **Recommendations**  

### **Funnel Optimization**  
- **Improve early engagement**: Redesign homepage and category pages to highlight best-selling products and encourage product views.  
- **Reduce checkout abandonment**: Simplify checkout process, add guest checkout option, and provide clear shipping & return policies.  
- **Leverage returning visitors**: Implement retargeting campaigns and loyalty programs to capitalize on higher conversion rates.  

### **Channel & Device Strategy**  
- **Boost mobile performance**: Optimize site speed and user experience on mobile to tap into potential untapped revenue.  
- **Reallocate marketing budget**: Reduce spending on Paid Search with low ROI and invest more in Direct & Organic channels.  

### **Product Strategy**  
- **Expand top categories**: Introduce related products and bundles for high-value categories.  
- **Enhance cross-selling**: Recommend complementary products during cart and checkout stages.  


---

