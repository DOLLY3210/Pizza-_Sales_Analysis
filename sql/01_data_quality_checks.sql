-- 01_data_quality_checks.sql
-- Run these after loading the data. Expected results are in the comments.

-- 1) Row count, orders, revenue, pizzas
SELECT COUNT(*)                 AS total_rows,        -- 48647
       COUNT(DISTINCT order_id) AS total_orders,      -- 21360
       SUM(total_price)         AS total_revenue,     -- 818329.80
       SUM(quantity)            AS total_pizzas       -- 49601
FROM hamburg_pizzeria_sales;

-- 2) Empty values (every number must be 0)
SELECT COUNT(*) FILTER (WHERE pizza_name IS NULL)       AS missing_pizza_name,
       COUNT(*) FILTER (WHERE order_date IS NULL)       AS missing_date,
       COUNT(*) FILTER (WHERE order_time IS NULL)       AS missing_time,
       COUNT(*) FILTER (WHERE total_price IS NULL)      AS missing_price
FROM hamburg_pizzeria_sales;

-- 3) Orders with more than one date or time (must return 0 rows)
SELECT order_id
FROM hamburg_pizzeria_sales
GROUP BY order_id
HAVING COUNT(DISTINCT order_date) > 1
    OR COUNT(DISTINCT order_time) > 1;

-- 4) order_day must match order_date (must return 0)
SELECT COUNT(*) AS wrong_weekday
FROM hamburg_pizzeria_sales
WHERE TRIM(TO_CHAR(order_date, 'Day')) <> order_day;

-- 5) Total price = unit price x quantity (must return 0)
SELECT COUNT(*) AS wrong_price
FROM hamburg_pizzeria_sales
WHERE ROUND(unit_price * quantity, 2) <> total_price;
