

WITH purchasing_suppliers_source AS
(
  SELECT 
  *
   FROM `vit-lam-data.wide_world_importers.purchasing__suppliers`  
),
purchasing_suppliers_rename_colum AS
(
  SELECT 
  supplier_id as supplier_key,
  supplier_name as supplier_name
  FROM 
  purchasing_suppliers_source
),
purchasing_suppliers_change_type AS 
(
SELECT
CAST(supplier_key AS INTEGER) AS supplier_key,
CAST (supplier_name AS STRING ) AS supplier_name
FROM 
purchasing_suppliers_rename_colum
)
SELECT
supplier_key,
supplier_name
FROM 
purchasing_suppliers_rename_colum