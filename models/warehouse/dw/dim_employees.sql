{{
  config(
    materialized='incremental',
    unique_key='dim_employee_id'
  )
}}

select
  md5(concat(employee_id, '|', dbt_valid_from)) as dim_employee_id,
  employee_id,
  first_name,
  last_name,
  department,
  job_title,
  manager_id,
  location,
  employee_status,
  salary_band,
  effective_date,
  dbt_valid_from as from_dt,
  dbt_valid_to as to_dt,
  case
    when dbt_valid_to is null then 1
    else 0
  end as current_record,
  current_timestamp() as ingest_date
from {{ ref('snap_employees') }}