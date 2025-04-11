WITH dim_person_source AS (
  SELECT 
    *
  FROM `vit-lam-data.wide_world_importers.application__people`
),

dim_person_rename_colum AS (
  SELECT 
    person_id as person_key,
    full_name as full_name,
    preferred_name as preferred_name,
    search_name as search_name,
    is_employee as is_employee, --bolean
    is_salesperson as is_salesperson --bolean
  FROM dim_person_source
),

dim_person_change_type AS (
  SELECT
    CAST(person_key AS INTEGER) AS person_key,
    CAST(full_name AS STRING) AS full_name,
    CAST(preferred_name AS STRING) AS preferred_name,
    CAST(search_name AS STRING) AS search_name,
    CAST(is_employee AS BOOLEAN) AS is_employee_bolean,
    CAST(is_salesperson AS BOOLEAN) AS is_salesperson_bolean
  FROM dim_person_rename_colum
),
dim_person_convert_boolean AS 
(
  SELECT 
  *,
  CASE 
    WHEN is_employee_bolean IS TRUE THEN 'is_employee'
    WHEN is_employee_bolean IS FALSE THEN 'not_is_employee'
    WHEN is_employee_bolean IS NULL THEN 'Undefined'
    ELSE 'Invalid' 
  END AS is_employee,
  CASE 
    WHEN is_salesperson_bolean IS TRUE THEN 'is_salesperson'
    WHEN is_salesperson_bolean IS FALSE THEN 'not_is_salesperson'
    WHEN is_salesperson_bolean IS NULL THEN 'Undefined'
    ELSE 'Invalid'
  END AS is_salesperson

  FROM 
  dim_person_change_type 
)
,
dim_person_add_undefined_rows AS (
  SELECT 
    person_key,
    full_name,
    preferred_name,
    search_name,
    is_employee,
    is_salesperson
  FROM dim_person_convert_boolean

  UNION ALL

  SELECT 
    0 AS person_key,
    'Undefined' AS full_name,
     'Undefined' AS preferred_name,
   'Undefined'AS search_name,
    'Undefined' AS is_employee,
    'Undefined' AS is_salesperson

  UNION ALL

  SELECT 
    -1 AS person_key,
    'Invalid' AS full_name,
    'Invalid' AS preferred_name,
   'Invalid'AS search_name,
    'Invalid' AS is_employee,
    'Invalid' AS is_salesperson
)

SELECT
  person_key,
  full_name,
  preferred_name,
  search_name,
  is_employee,
  is_salesperson
FROM dim_person_add_undefined_rows
