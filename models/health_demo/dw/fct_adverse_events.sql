{{
  config(
    materialized='incremental',
    unique_key='fct_adverse_event_id'
  )
}}

with src as (
  select * from {{ref('snap_adverse_events')}}
)
select
  sha2(concat(e.fct_trial_enrollment_id, '|', p.dim_patient_id)) as fct_adverse_event_id,
  s.event_id,
  e.fct_trial_enrollment_id,
  p.dim_patient_id,
  s.reported_by,
  s.event_description,
  s.event_date,
  s.severity,
  s.resolved_date,
  dbt_valid_from as from_dt,
  dbt_valid_to as to_dt,
  case
    when dbt_valid_to is null then 1
    else 0
  end as current_record
from src s
left join {{ref('fct_trial_enrollments')}} e on s.enrollment_id = e.enrollment_id
left join {{ref('dim_patients')}} p on s.patient_id = p.dim_patient_id