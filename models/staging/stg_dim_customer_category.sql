
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
)
SELECT 
customer_category_key,
customer_category_name
FROM 
customer_category_change_type