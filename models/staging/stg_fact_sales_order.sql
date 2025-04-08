
WITH sales_order_source AS
(
  SELECT
   * 
  FROM
  `vit-lam-data.wide_world_importers.sales__orders` 
),

sales_order_rename_column AS
(
  SELECT 
  order_id AS sales_order_key,
  customer_id AS customer_key
   FROM 
  sales_order_source
),
sales_order_change_type AS
(
SELECT 
CAST(sales_order_key AS NUMERIC) AS sales_order_key,
 CAST(customer_key AS NUMERIC) AS customer_key
FROM 
sales_order_rename_column
)
SELECT 
sales_order_key,
customer_key
FROM 
sales_order_rename_column

