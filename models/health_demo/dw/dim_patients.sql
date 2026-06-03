{{
  config(
    materialized='incremental',
    unique_key='dim_patient_id',
    incremental_strategy='merge'
  )
}}

with src as (
  select * from {{ref('int_patients')}}
)
select
  s.patient_id as dim_patient_id,
  s.first_name,
  s.last_name,
  s.date_of_birth,
  s.gender,
  s.address_state,
  s.insurance_provider,
  s.insurance_plan_code,
  p.dim_physician_id,
  s.enrollment_status,
  s.created_at,
  s.updated_at
from src s
left join {{ref('dim_physicians')}} p on s.primary_physician_id = p.dim_physician_id