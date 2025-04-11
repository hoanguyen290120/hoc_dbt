
WITH dim_country_source AS
(
SELECT
*
 FROM `vit-lam-data.wide_world_importers.application__countries`
),
dim_country_rename_column AS 
(
  SELECT 
  country_id AS delivery_country_key,
  country_name AS delivery_country_name
  FROM 
  dim_country_source
),
dim_country_change_type AS 
(
SELECT 
CAST(delivery_country_key AS INTEGER) AS delivery_country_key,
CAST(delivery_country_name AS STRING) AS delivery_country_name
FROM 
dim_country_rename_column
),
dim_country_add_undefined AS 
(
SELECT 
delivery_country_key,
delivery_country_name
FROM 
dim_country_change_type
UNION ALL
SELECT
0 AS delivery_country_key,
'Undefined' AS delivery_country_name
UNION ALL
SELECT
-1 as delivery_country_key,
'Invalid' AS delivery_country_name
)
SELECT
delivery_country_key,
delivery_country_name
FROM 
dim_country_add_undefined
