SELECT
CAST( order_line_id AS INTEGER) as sales_order_line_key,
CAST (stock_item_id AS INTEGER) as product_key,
 CAST(quantity AS INTEGER) as quantity,
CAST(unit_price AS NUMERIC) as unit_price,
CAST(unit_price as INTEGER)*CAST(quantity as NUMERIC) as gross_amount
 FROM `vit-lam-data.wide_world_importers.sales__order_lines` 