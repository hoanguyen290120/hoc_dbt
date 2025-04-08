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
sales_order_line_key,
sales_order_key,
product_key,
quantity,
unit_price,
unit_price*quantity as gross_amount
FROM 
fact_sales_order_line_change_type
