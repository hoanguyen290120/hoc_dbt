
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
  order_date,
  order_id AS sales_order_key,
  customer_id AS customer_key,
  picked_by_person_id AS picked_by_person_key,
   FROM 
  sales_order_source
),
sales_order_change_type AS
(
SELECT 
CAST(order_date AS DATE) AS order_date,
CAST(sales_order_key AS NUMERIC) AS sales_order_key,
 CAST(customer_key AS NUMERIC) AS customer_key,
 CAST(picked_by_person_key AS NUMERIC) AS picked_by_person_key
FROM 
sales_order_rename_column
)
SELECT 
order_date,
sales_order_key,
customer_key,
COALESCE(picked_by_person_key,0) AS picked_by_person_key
FROM 
sales_order_rename_column

