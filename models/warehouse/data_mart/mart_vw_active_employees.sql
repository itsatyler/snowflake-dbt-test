{{ config(materialized='view')}}

select
  employee_id,
  concat(first_name, ' ',last_name) as name,
  department,
  job_title,
  manager_id,
  location,
  salary_band,
  effective_date
from {{ ref('dim_employees') }}
where current_record = 1
and employee_status = 'ACTIVE'