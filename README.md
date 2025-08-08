# User Journey & Conversion Funnel (BigQuery SQL)

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
  - [Step 1: Business Understanding and KPI Design](#step-1-business-understanding-and-kpi-design)
  - [Step 2: Data Exploration and Modeling](#step-2-data-exploration-and-modeling)
  - [Step 3: Revenue & Marketing Channel Analysis](#step-3-revenue--marketing-channel-analysis)
  - [Step 4: Product, Category & Customer Segmentation](#step-4-product-category--customer-segmentation)
  - [Step 5: Device & Browser Performance Analysis](#step-5-device--browser-performance-analysis)
  - [Step 6: Funnel Behavior Analysis (Session-Level and User-Level)](#step-6-funnel-behavior-analysis-session-level-and-user-level)
  - [Step 7: Visualization and Insights Dashboard](#step-7-visualization-and-insights-dashboard)

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

- **Revenue by Traffic Source** – Grouped revenue by `trafficSource.source` and calculated each channel’s percentage share. This highlighted the highest-converting acquisition channels.  
You can find the query [here].

---

### Step 4: Product, Category & Customer Segmentation  
Evaluated product performance, category contribution, and customer types to guide merchandising and marketing strategies.

- **Product & Category Revenue Contribution** – Used `UNNEST` to access product-level data, aggregated revenue, and filtered out missing categories. The results showed top-performing products and profitable categories.  
You can find the query [here].

- **New vs. Returning Customer Segmentation** – Segmented users via `totals.newVisits` and calculated revenue, bounce rate, time on site, and transactions per group. This exposed behavioral differences that can guide targeted campaigns.  
You can find the query [here].

---

### Step 5: Device & Browser Performance Analysis  
Analyzed how different devices and browsers impact user engagement and revenue.

- Grouped users by device category (desktop, mobile, tablet) and browser type. Calculated visits, revenue, bounce rate, and conversion rate for each.  
- These metrics highlight which platforms perform best and reveal areas needing UX or technical improvements.  
You can find the query [here].

---

### Step 6: Funnel Behavior Analysis (Session-Level and User-Level)  
- **Session-Level Funnel Analysis:** Tracked funnel steps reached within each session and calculated drop-off rates to identify conversion bottlenecks. You can find the query [here].  
- **User-Level Funnel Completion Analysis:** Aggregated funnel progress across all sessions per user to reveal long-term engagement and conversion trends. You can find the query [here].  

These combined views help optimize the ecommerce funnel by showing where users convert or drop off.

---

### Step 7: Visualization and Insights Dashboard  
Built a Power BI dashboard to clearly present key metrics and funnel insights, making complex data accessible for business decision-makers.

---

