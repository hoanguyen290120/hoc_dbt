
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
supplier_id as supplier_key,
stock_item_name as product_name,
brand as brand_name
FROM 
dim_product_source
),
--B3: Chuyển đổi type data
dim_produtc_change_type  AS
(
SELECT  
CAST(product_key AS INTEGER) as product_key,
CAST(product_name AS STRING) as product_name,
CAST (supplier_key AS INTEGER) AS supplier_key,
CAST (brand_name as STRING ) as brand_name
FROM dim_product_renname_column
)
--B4: Chọn cột cần thiết
SELECT
dim_product.product_key,
dim_product.product_name,
dim_product.brand_name,
dim_product.supplier_key,
dim_supplier.supplier_name
FROM 
dim_produtc_change_type as dim_product 
LEFT JOIN {{ref('dim_supplier')}} as dim_supplier
ON dim_product.supplier_key=dim_supplier.supplier_key