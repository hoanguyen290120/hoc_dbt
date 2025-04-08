--B1: Đổi source lấy data
WITH fact_sales_order_line_source AS
(
SELECT
 * 
FROM 
`vit-lam-data.wide_world_importers.sales__order_lines`
),

--Đổi cột
sales_order_line_rename_column AS
(

  SELECT
  order_line_id as sales_order_line_key ,
  order_id as sales_order_key,
  stock_item_id as product_key,
  quantity as quantity,
  unit_price as unit_price,
  FROM 
  fact_sales_order_line_source
),

--B3: Chuyển type
fact_sales_order_line_change_type AS
(
SELECT
CAST( sales_order_line_key AS INTEGER) as sales_order_line_key,
CAST(sales_order_key AS INTEGER) as sales_order_key,
CAST (product_key AS INTEGER) as product_key,
 CAST(quantity AS INTEGER) as quantity,
CAST(unit_price AS NUMERIC) as unit_price
FROM
sales_order_line_rename_column
)
SELECT 
fact_line.sales_order_line_key,
fact_line.sales_order_key,
fact_header.customer_key,
fact_line.product_key,
fact_line.quantity,
fact_line.unit_price,
fact_line.unit_price * fact_line.quantity as gross_amount
FROM 
fact_sales_order_line_change_type AS fact_line
LEFT JOIN {{ref('stg_fact_sales_order')}} as fact_header --bảng này từ tạo straging
ON fact_line.sales_order_key = fact_header.sales_order_key