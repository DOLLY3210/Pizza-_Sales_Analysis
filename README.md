Pizza Sales Analysis: SQL & Interactive Dashboard
An end-to-end data analysis project focusing on operational efficiency and sales trends for a busy pizzeria. This project bridges database query optimization with executive-facing business intelligence by combining a PostgreSQL relational database backend with a fully dynamic Excel/PowerBI Interactive Dashboard.
---
Executive Summary & KPIs
The project parses complex transactional pizza orders across key business constraints as per (category, sizing, time parameters, and order frequencies). The primary operational metrics calculated are:
Total Revenue: €818,329.80
Total Orders Placed: 21,360 orders
Total Pizzas Sold: 49,601 pizzas
Average Order Value: €38.31 per order
Average Pizzas Per Order: 2.32 pizzas
---
Tech Stack & Skills Demonstrated
Database Management: PostgreSQL / pgAdmin 4
Data Analysis Expressions: Complex SQL Aggregations (`SUM`, `COUNT DISTINCT`), Date/Time functions (`EXTRACT`, `TO_CHAR`), and Data Type Casting (`::numeric`).
Visualization & BI: Dynamic Multi-page Dashboard design, Interactive Slicers (Yearly filter matrices), Conditional Metric Bar Charts, and Radial Donut Percentages.
---
📑 SQL Script (Cleaned & Production-Ready)
Below are the production-optimized PostgreSQL queries utilized to seed the data engine. Note: Syntax errors such as accidental double commas and deprecated casting wrappers have been corrected from initial testing logs.
```sql
-- 1. TOTAL REVENUE
SELECT round(sum(total_price)::numeric, 2) AS total_revenue 
FROM dd_pizza_sales;

-- 2. AVERAGE ORDER VALUE
SELECT round((sum(total_price) / count(distinct order_id))::numeric, 2) AS average_order_value 
FROM dd_pizza_sales;

-- 3. TOTAL PIZZAS SOLD
SELECT sum(quantity) AS total_pizzas_sold 
FROM dd_pizza_sales;

-- 4. TOTAL ORDERS PLACED
SELECT count(distinct order_id) AS total_orders 
FROM dd_pizza_sales;

-- 5. AVERAGE PIZZAS PER ORDER
SELECT round((sum(quantity)::numeric / count(distinct order_id)), 2) AS average_pizzas_per_order 
FROM dd_pizza_sales;

-- 6. TOTAL PIZZAS SOLD BY PIZZA SIZE
SELECT pizza_size, sum(quantity) AS total_pizzas_sold 
FROM dd_pizza_sales
GROUP BY pizza_size
ORDER BY total_pizzas_sold DESC;

-- 7. DAILY TREND FOR TOTAL ORDERS
SELECT 
    to_char(order_date, 'day') AS order_day,
    count(distinct order_id) AS total_orders 
FROM dd_pizza_sales
GROUP BY to_char(order_date, 'day'), extract(dow from order_date)
ORDER BY extract(dow from order_date);

-- 8. HOURLY TREND FOR ORDERS
SELECT 
    extract(hour FROM order_time) AS order_hours,
    count(distinct order_id) AS total_orders 
FROM dd_pizza_sales
GROUP BY extract(hour FROM order_time)
ORDER BY order_hours;

-- 9. PERCENTAGE OF SALES BY PIZZA CATEGORY
SELECT 
    pizza_category, 
    round(sum(total_price)::numeric, 2) AS total_revenue,
    round((sum(total_price) / (SELECT sum(total_price) FROM dd_pizza_sales) * 100)::numeric, 2) AS pct_contribution
FROM dd_pizza_sales
GROUP BY pizza_category
ORDER BY pct_contribution DESC;

-- 10. TOP 5 BEST SELLERS BY TOTAL PIZZAS SOLD
SELECT pizza_name, sum(quantity) AS total_pizza_sold 
FROM dd_pizza_sales
GROUP BY pizza_name
ORDER BY total_pizza_sold DESC 
LIMIT 5;

-- 11. BOTTOM 5 WORST SELLERS BY TOTAL PIZZAS SOLD
SELECT pizza_name, sum(quantity) AS total_pizza_sold 
FROM dd_pizza_sales
GROUP BY pizza_name
ORDER BY total_pizza_sold ASC 
LIMIT 5;
```
---
Strategic Insights Discovered
The Friday Rush: Order volume climbs systematically over the workweek, peaking on Fridays (3,538 total orders) and Saturdays (3,162 total orders).
Lunch vs. Dinner Spikes: Peak entry hours are between mid-day lunch breaks (12:00 PM – 1:00 PM) and evening dinner selections (4:00 PM – 8:00 PM).
Core Volume Profiles: Large-size (`L`) pizzas rule individual item counts (18,952 units sold), accounting for 45.91% of overall proportional size splits.
Product Range Divergence: The Classic Deluxe Pizza remains the highest moving inventory driver (2,453 sold), while The Brie Carre Pizza captures the trailing bottom metric footprint with only 490 total units sold.
---
