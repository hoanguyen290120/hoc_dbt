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
  customer_name,
  customer_category_id as customer_category_key,
  buying_group_id as buying_group_key,
  FROM 
  dim_customer_source
),
--B3: Chuyển đổi type data
dim_customer_change_type as
(
  SELECT
  CAST(customer_key as INTEGER) AS customer_key,
  CAST(customer_name as STRING ) AS customer_name,
  CAST(customer_category_key as INTEGER) AS customer_category_key,
  CAST(buying_group_key as INTEGER) as buying_group_key
  FROM 
  dim_customer_rename_column
)
--B4: Chọn cột cần thiết
SELECT
dim_customer.customer_key,
dim_customer.customer_name,
dim_customer.customer_category_key,
dim_customer.buying_group_key,
dim_buying_group.buying_group_name,
dim_customer_category.customer_category_name

FROM 
dim_customer_change_type as dim_customer
LEFT JOIN {{ref('stg_dim_buying_group')}} as dim_buying_group 
on dim_customer.buying_group_key=dim_buying_group.buying_group_key
LEFT JOIN {{ref('stg_dim_customer_category')}} as dim_customer_category 
on dim_customer.customer_category_key= dim_customer_category.customer_category_key

