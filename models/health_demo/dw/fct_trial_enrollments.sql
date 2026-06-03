{{
  config(
    materialized='incremental',
    unique_key='fct_trial_enrollment_id'
  )
}}

with src as (
  select * from {{ref('snap_enrollments')}}
)
select
  sha2(concat(s.enrollment_id, '|', c.dim_clinical_trial_id, '|', p.dim_patient_id)) as fct_trial_enrollment_id,
  s.enrollment_id,
  p.dim_patient_id,
  c.dim_clinical_trial_id,
  s.enrolled_date,
  s.current_status,
  s.withdrawal_reason,
  s.withdrawal_date,
  s.updated_at,
  dbt_valid_from as from_dt,
  dbt_valid_to as to_dt,
  case
    when dbt_valid_to is null then 1
    else 0
  end as current_record
from src s
left join {{ref('dim_clinical_trials')}} c on s.trial_id = c.dim_clinical_trial_id
left join {{ref('dim_patients')}} p on s.patient_id = p.dim_patient_id