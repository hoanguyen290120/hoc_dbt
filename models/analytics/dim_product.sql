
-- B1: Source lấy data
WITH dim_product_source AS
(
  SELECT 
   *
  FROM 
  `vit-lam-data.wide_world_importers.warehouse__stock_items`
),
--B2: Đổi cột
  dim_product_renname_column AS
  (
SELECT
stock_item_id as product_key,
stock_item_name as product_name,
brand as brand_name
FROM 
dim_product_source
)

SELECT  
CAST(product_key AS INTEGER) as product_key,
CAST(product_name AS STRING) as product_name,
CAST (brand_name as STRING ) as brand_name
FROM dim_product_renname_column