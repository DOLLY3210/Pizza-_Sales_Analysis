-- 02_business_queries.sql
-- All queries that feed the Excel dashboard. Results match the dashboard.

-- ========== KPIs ==========

-- 1) Total revenue                                   -- 818329.80
SELECT SUM(total_price) AS total_revenue
FROM hamburg_pizzeria_sales;

-- 2) Average order value                             -- 38.31
SELECT ROUND(SUM(total_price) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM hamburg_pizzeria_sales;

-- 3) Total pizzas sold                               -- 49601
SELECT SUM(quantity) AS total_pizzas_sold
FROM hamburg_pizzeria_sales;

-- 4) Total orders                                    -- 21360
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM hamburg_pizzeria_sales;

-- 5) Average pizzas per order                        -- 2.32
SELECT ROUND(SUM(quantity)::NUMERIC / COUNT(DISTINCT order_id), 2) AS average_pizzas_per_order
FROM hamburg_pizzeria_sales;

-- ========== WHEN DO CUSTOMERS ORDER? ==========

-- 6) Orders per weekday                -- Sun 2620 ..Mon 2789 ... Fri 3490, Sat 3244, 
SELECT TO_CHAR(order_date, 'Day') AS order_day,
       COUNT(DISTINCT order_id)         AS total_orders
FROM hamburg_pizzeria_sales
GROUP BY (TO_CHAR(order_date, 'Day')), EXTRACT(DOW FROM order_date)
ORDER BY EXTRACT(DOW FROM order_date);

-- 7) Orders per hour                                 -- peak: 12h = 2582, 13h = 2452, 17h = 2336, 18h = 2399
SELECT EXTRACT(HOUR FROM order_time)::INT AS order_hour,
       COUNT(DISTINCT order_id)           AS total_orders
FROM hamburg_pizzeria_sales
GROUP BY EXTRACT(HOUR FROM order_time)
ORDER BY order_hour;

-- ========== WHAT SELLS? ==========

-- 8) Revenue and % of sales by category              -- Classic 26.90 | Supreme 25.45 | Chicken 23.96 | Veggie 23.69
SELECT pizza_category,
       ROUND(SUM(total_price)::NUMERIC, 2) AS total_revenue,
       ROUND((SUM(total_price) / (SELECT SUM(total_price) FROM hamburg_pizzeria_sales) * 100)::NUMERIC, 2) AS pct_contribution
FROM hamburg_pizzeria_sales
GROUP BY pizza_category
ORDER BY pct_contribution DESC;

-- 9) Revenue and % of sales by size                  -- L 45.91 | M 30.47 | S 21.78 | XL 1.72 | XXL 0.12
SELECT pizza_size,
       ROUND(SUM(total_price)::NUMERIC, 2) AS total_revenue,
       ROUND((SUM(total_price) / (SELECT SUM(total_price) FROM hamburg_pizzeria_sales) * 100)::NUMERIC, 2) AS pct_contribution
FROM hamburg_pizzeria_sales
GROUP BY pizza_size
ORDER BY pct_contribution DESC;

-- 10) Pizzas sold by size                            -- L 18973 | M 15635 | S 14413 | XL 552 | XXL 28
SELECT pizza_size, SUM(quantity) AS total_pizzas_sold
FROM hamburg_pizzeria_sales
GROUP BY pizza_size
ORDER BY total_pizzas_sold DESC;

-- 11) Pizzas sold by category                        -- Classic 14895 | Supreme 11990 | Veggie 11658 | Chicken 11058
SELECT pizza_category, SUM(quantity) AS total_pizzas_sold
FROM hamburg_pizzeria_sales
GROUP BY pizza_category
ORDER BY total_pizzas_sold DESC;

-- 12) Top 5 pizzas by quantity                       -- 2453, 2432, 2422, 2418, 2378
SELECT pizza_name, SUM(quantity) AS total_pizzas_sold
FROM hamburg_pizzeria_sales
GROUP BY pizza_name
ORDER BY total_pizzas_sold DESC
LIMIT 5;

-- 13) Bottom 5 pizzas by quantity                    -- 490, 934, 937, 950, 961
SELECT pizza_name, SUM(quantity) AS total_pizzas_sold
FROM hamburg_pizzeria_sales
GROUP BY pizza_name
ORDER BY total_pizzas_sold ASC
LIMIT 5;

-- 14) Top 5 pizzas by revenue                        -- Thai Chicken 43434.25 | Barbecue Chicken 42768.00 | California Chicken 41575.50 | Classic Deluxe 38180.50 | Spicy Italian 34831.25
SELECT pizza_name, ROUND(SUM(total_price)::NUMERIC, 2) AS total_revenue
FROM hamburg_pizzeria_sales
GROUP BY pizza_name
ORDER BY total_revenue DESC
LIMIT 5;

-- 15) Lowest pizza by revenue                        -- Brie Carre 11588.50
SELECT pizza_name, ROUND(SUM(total_price)::NUMERIC, 2) AS total_revenue
FROM hamburg_pizzeria_sales
GROUP BY pizza_name
ORDER BY total_revenue ASC
LIMIT 1;

