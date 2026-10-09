-- 00_create_table.sql
-- Creates the table and shows how to load the CSV from the data/ folder.

DROP TABLE IF EXISTS hamburg_pizzeria_sales;

CREATE TABLE hamburg_pizzeria_sales (
    pizza_id           INT PRIMARY KEY,
    order_id           INT,
    total_order        FLOAT,
    pizza_name_id      VARCHAR(30),
    quantity           SMALLINT,
    order_date         DATE,
    order_day          VARCHAR(10),
    order_time         TIME,
    unit_price         NUMERIC(6,2),
    total_price        NUMERIC(8,2),
    pizza_size         VARCHAR(5),
    pizza_category     VARCHAR(20),
    pizza_ingredients  TEXT,
    pizza_name         VARCHAR(60)
);

-- Load the data (run in psql, use your own path):
-- \copy hamburg_pizzeria_sales FROM 'data/hamburg_pizzeria_sales.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ENCODING 'UTF8')
--
-- In pgAdmin: right-click the table > Import/Export Data > Import
-- Format csv | Header ON | Delimiter , | Quote " | Escape " | Encoding UTF8

