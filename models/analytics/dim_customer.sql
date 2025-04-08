--B1: Source lấy data
WITH dim_customer_source AS(
  SELECT 
  * 
  FROM `vit-lam-data.wide_world_importers.sales__customers` 
),
--B2: Đổi tên cột
dim_customer_rename_column as
(
  SELECT 
  customer_id as customer_key,
  customer_name
  FROM 
  dim_customer_source
),
--B3: Chuyển đổi type data
dim_customer_change_type as
(
  SELECT
  CAST(customer_key as INTEGER) AS customer_key,
  CAST(customer_name as STRING ) AS customer_name
  FROM 
  dim_customer_rename_column
)
--B4: Chọn cột cần thiết
SELECT
customer_key,
customer_name
FROM 
dim_customer_change_type

