WITH dim_customer_source AS 
(
  SELECT 
  * 
  FROM 
  `vit-lam-data.wide_world_importers.sales__customers` 
),
dim_customer_rename_column AS 
(
  SELECT 
  customer_id AS customer_key,   --int
  customer_name as customer_name,  --string
  is_statement_sent AS is_statement_sent_boolean, --boolean
  is_on_credit_hold as is_on_credit_hold_boolean, --boolean
  credit_limit as credit_limit, --float
  standard_discount_percentage as standard_discount_percentage, --float
  payment_days as payment_days, --int
  customer_category_id as customer_category_key, --int
  buying_group_id as buying_group_key, --int
  delivery_method_id as delivery_method_key, --int
  delivery_city_id as delivery_city_key --int
  FROM 
  dim_customer_source
),
dim_customer_change_type AS 
(
  SELECT 
  CAST(customer_key AS INTEGER) AS customer_key,
  CAST(customer_name AS STRING) AS customer_name,
  CAST(is_statement_sent_boolean AS BOOLEAN) AS is_statement_sent_boolean,
  CAST(is_on_credit_hold_boolean AS BOOLEAN) AS is_on_credit_hold_boolean,
  CAST(credit_limit AS FLOAT64) AS credit_limit,
  CAST(standard_discount_percentage AS FLOAT64) AS standard_discount_percentage,
  CAST(payment_days AS INTEGER) AS payment_days,
  CAST(customer_category_key AS INTEGER) AS customer_category_key,
  CAST(buying_group_key AS INTEGER) AS buying_group_key,
  CAST(delivery_method_key AS INTEGER) AS delivery_method_key,
  CAST(delivery_city_key AS INTEGER) AS delivery_city_key
  FROM 
  dim_customer_rename_column
),
dim_customer_convert_boolean AS 
(
SELECT 
*,
CASE 
WHEN is_statement_sent_boolean IS TRUE THEN 'is_statement_sent'
WHEN is_statement_sent_boolean IS FALSE THEN 'not_is_statement_sent'
WHEN is_statement_sent_boolean IS NULL THEN 'Undefined'
ELSE 'Invalid' 
END AS is_statement_sent ,

CASE 
WHEN  is_on_credit_hold_boolean IS TRUE THEN 'is_on_credit_hold'
WHEN is_on_credit_hold_boolean IS FALSE THEN 'not_is_on_credit_hold'
WHEN is_on_credit_hold_boolean IS NULL THEN 'Undefined'
ELSE 'Invalid'
END AS is_on_credit_hold

FROM 
dim_customer_change_type
),
dim_customer_add_undefined_record AS 
(

SELECT 
customer_key,
customer_name,
is_statement_sent,
is_on_credit_hold,
credit_limit,
standard_discount_percentage,
payment_days,
customer_category_key,
buying_group_key,
delivery_method_key,
delivery_city_key
FROM 
dim_customer_convert_boolean
UNION ALL 

SELECT
0 AS customer_key,
'Undefined' AS customer_name,
'Undefined' AS is_statement_sent,
'Undefined' AS is_on_credit_hold,
NULL AS credit_limit,
NULL AS standard_discount_percentage,
NULL AS payment_days,
0 AS customer_category_key,
0 AS buying_group_key,
0 AS delivery_method_key,
0 AS delivery_city_key
UNION ALL 
SELECT 
-1 AS customer_key,
'Invalid' AS customer_name,
'Invalid' AS is_statement_sent,
'Invalid' AS is_on_credit_hold,
NULL AS credit_limit,
NULL AS standard_discount_percentage,
NULL AS payment_days,
-1 AS customer_category_key,
-1 AS buying_group_key,
-1 AS delivery_method_key,
-1 AS delivery_city_key
)


SELECT 

dim_customer.customer_key,
dim_customer.customer_name,
dim_customer.is_statement_sent,
dim_customer.is_on_credit_hold,
dim_customer.credit_limit,
dim_customer.standard_discount_percentage,
dim_customer.payment_days,
dim_customer.customer_category_key,
COALESCE (dim_customer_category.customer_category_name,'Undefined') AS customer_category_name,
dim_customer.buying_group_key,
COALESCE(dim_buying_group.buying_group_name,'Undefined') AS buying_group_name,
dim_customer.delivery_method_key,
COALESCE(dim_delivery_method.delivery_method_name,'Undefined') AS delivery_method_name,
dim_customer.delivery_city_key,
COALESCE(dim_city.delivery_city_name,'Undefined') AS delivery_city_name,
COALESCE(dim_city.delivery_stage_province_name,'Undefined') AS delivery_stage_province_name,
COALESCE(dim_city.delivery_country_name,'Undefined') AS delivery_country_name
 FROM dim_customer_add_undefined_record as dim_customer
 LEFT JOIN {{ ref('stg_dim_customer_category') }} AS dim_customer_category
      ON dim_customer.customer_category_key = dim_customer_category.customer_category_key
LEFT JOIN {{ ref('stg_dim_buying_group') }} AS dim_buying_group 
      ON dim_customer.buying_group_key = dim_buying_group.buying_group_key
 LEFT JOIN {{ ref('stg_dim_delivery_method') }} AS dim_delivery_method
      ON dim_customer.delivery_method_key = dim_delivery_method.delivery_method_key
LEFT JOIN {{ ref('stg_dim_city') }} AS dim_city
      ON dim_customer.delivery_city_key = dim_city.delivery_city_key