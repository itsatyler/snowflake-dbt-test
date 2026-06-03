{{ config(materialized='view') }}

select
  cast(employee_id as number) as employee_id,
  split_part(employee_name, ' ', 1) as first_name,
  split_part(employee_name, ' ', 2) as last_name,
  upper(trim(department)) as department,
  trim(job_title) as job_title,
  cast(manager_id as number) as manager_id,
  upper(trim(location)) as location,
  upper(employee_status) as employee_status,
  upper(trim(salary_band)) as salary_band,
  cast(effective_date as date) as effective_date,
  current_timestamp() as ingest_date
from {{source('lnd','raw_employees')}}