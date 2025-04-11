
WITH customer_category_source as
(
SELECT * FROM `vit-lam-data.wide_world_importers.sales__customer_categories` 
),
customer_category_rename_column as
(
  SELECT 
  customer_category_id as customer_category_key,
  customer_category_name
  FROM
  customer_category_source
),
customer_category_change_type as
(SELECT
  CAST(customer_category_key AS INTEGER) AS customer_category_key,
  CAST(customer_category_name AS STRING) AS customer_category_name
  FROM 
  customer_category_rename_column
),
customer_category_add_undefined AS 
(
  SELECT 
  customer_category_key,
  customer_category_name
  FROM 
  customer_category_change_type
UNION ALL
  SELECT 
  0 AS customer_category_key,
  'Undefined' AS customer_category_name
  UNION ALL
  SELECT
  -1 AS customer_category_key,  
  'Invalid' AS customer_category_name
)

SELECT 
customer_category_key,
customer_category_name
FROM 
customer_category_add_undefined