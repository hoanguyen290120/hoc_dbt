
WITH dim_stage_province_source AS
(
SELECT
*
 FROM `vit-lam-data.wide_world_importers.application__state_provinces`
),
dim_stage_province_rename_column AS 
(
  SELECT 
  state_province_id AS delivery_stage_province_key,
  state_province_name AS delivery_stage_province_name,
  state_province_code AS delivery_stage_province_code,
  country_id AS delivery_country_key
  FROM 
  dim_stage_province_source
),
dim_stage_province_change_type AS 
(
SELECT 
CAST(delivery_stage_province_key AS INTEGER) AS delivery_stage_province_key,
CAST(delivery_stage_province_name AS STRING) AS delivery_stage_province_name,
CAST(delivery_stage_province_code AS STRING) AS delivery_stage_province_code,
CAST(delivery_country_key AS INTEGER) AS delivery_country_key
FROM 
dim_stage_province_rename_column
),
dim_stage_province_add_undefined AS 
(
SELECT 
delivery_stage_province_key,
delivery_stage_province_name,
delivery_stage_province_code,
delivery_country_key
FROM 
dim_stage_province_change_type
UNION ALL
SELECT
0 AS delivery_stage_province_key,
'Undefined' AS delivery_stage_province_name,
'Undefined' AS delivery_stage_province_code,
0 AS delivery_country_key
UNION ALL
SELECT
-1 as delivery_stage_province_key,
'Invalid' AS delivery_stage_province_name,
'Invalid' AS delivery_stage_province_code,
-1 AS delivery_country_key
)
SELECT
dim_stage_province.delivery_stage_province_key,
dim_stage_province.delivery_stage_province_name,
dim_stage_province.delivery_stage_province_code,
dim_stage_province.delivery_country_key,
dim_country.delivery_country_name
FROM 
dim_stage_province_add_undefined as dim_stage_province
LEFT JOIN {{ ref('stg_dim_country') }} as dim_country 
ON dim_stage_province.delivery_country_key = dim_country.delivery_country_key

