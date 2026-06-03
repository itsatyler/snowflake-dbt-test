{{ config(materialized='table') }}

-- grain: one row per insurance_provider + insurance_plan_code
with patient_base as (
  select
    insurance_provider,
    insurance_plan_code,
    dim_patient_id,
    gender,
    address_state,
    enrollment_status
  from {{ ref('dim_patients') }}
),

patient_summary as (
  select
    insurance_provider,
    insurance_plan_code,
    count(*) as total_patients,
    count(case when enrollment_status = 'active' then 1 end) as active_patients,
    count(case when enrollment_status = 'inactive' then 1 end) as inactive_patients,
    count(case when gender = 'Male' then 1 end) as male_patients,
    count(case when gender = 'Female' then 1 end) as female_patients,
    count(case when gender = 'Other' then 1 end) as other_gender_patients,
    count(distinct address_state) as distinct_states
  from patient_base
  group by insurance_provider, insurance_plan_code
),

enrollments as (
  select
    p.insurance_provider,
    p.insurance_plan_code,
    count(*) as total_trial_enrollments,
    count(distinct e.dim_clinical_trial_id) as distinct_trials
  from {{ ref('fct_trial_enrollments') }} e
  inner join patient_base p on e.dim_patient_id = p.dim_patient_id
  where e.current_record = 1
  group by p.insurance_provider, p.insurance_plan_code
),

adverse_events as (
  select
    p.insurance_provider,
    p.insurance_plan_code,
    count(*) as total_adverse_events
  from {{ ref('fct_adverse_events') }} a
  inner join patient_base p on a.dim_patient_id = p.dim_patient_id
  where a.current_record = 1
  group by p.insurance_provider, p.insurance_plan_code
)

select
  ps.insurance_provider,
  ps.insurance_plan_code,
  ps.total_patients,
  ps.active_patients,
  ps.inactive_patients,
  ps.male_patients,
  ps.female_patients,
  ps.other_gender_patients,
  ps.distinct_states,
  coalesce(en.total_trial_enrollments, 0) as total_trial_enrollments,
  coalesce(en.distinct_trials, 0) as distinct_trials,
  coalesce(ae.total_adverse_events, 0) as total_adverse_events
from patient_summary ps
left join enrollments en
  on ps.insurance_provider = en.insurance_provider
  and ps.insurance_plan_code = en.insurance_plan_code
left join adverse_events ae
  on ps.insurance_provider = ae.insurance_provider
  and ps.insurance_plan_code = ae.insurance_plan_code
