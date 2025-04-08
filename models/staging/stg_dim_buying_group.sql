WITH dim_buying_group AS 
(
  SELECT * FROM `vit-lam-data.wide_world_importers.sales__buying_groups`
),
dim_buying_group_rename_column AS 
(
  SELECT 
  buying_group_id AS buying_group_key,
  buying_group_name
  FROM
  dim_buying_group
),
dim_buying_group_change_type AS 
(
  SELECT 
  CAST(buying_group_key AS INTEGER) AS buying_group_key,
  CAST (buying_group_name AS STRING) AS buying_group_name
  FROM  
  dim_buying_group_rename_column
)
SELECT 
buying_group_key,
buying_group_name
FROM  
dim_buying_group_change_type