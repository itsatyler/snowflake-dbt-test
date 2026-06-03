{{ config(materialized='view') }}

select distinct
  affiliated_hospital,
  employment_type,
  split_part(full_name, ' ', 1) as honorific,
  split_part(full_name, ' ', 2) as first_name,
  split_part(full_name, ' ', 3 )as last_name,
  upper(trim(license_state)) as license_state,
  {{ safe_cast('npi_number','number') }} as npi_number,
  upper(trim({{ safe_cast('physician_id','varchar') }})) as physician_id,
  lower(trim(specialty)) as specialty,
  {{ safe_cast('updated_at','date') }} as updated_at
from {{ source('lnd','raw_physicians') }}