{{ config(materialized='view') }}

select distinct
  upper(trim(address_state)) as address_state,
  {{ safe_cast('created_at', 'DATE') }} as created_at,
  {{ safe_cast('date_of_birth', 'DATE') }} as date_of_birth,
  lower(trim(enrollment_status)) as enrollment_status,
  first_name as first_name,
  case
    when gender = 'M' then 'Male'
    when gender = 'F' then 'Female'
    else 'Other'
  end as gender,
  {{ safe_cast('insurance_plan_code', 'VARCHAR') }} as insurance_plan_code,
  insurance_provider as insurance_provider,
  last_name as last_name,
  {{ safe_cast('patient_id', 'VARCHAR') }} as patient_id,
  {{ safe_cast('primary_physician_id', 'VARCHAR') }} as primary_physician_id,
  {{ safe_cast('updated_at', 'DATE') }} as updated_at
from {{ source('lnd','raw_patients') }}