{{ config(materialized='table') }}

with enrollments as (
  select
    dim_clinical_trial_id,
    count(*) as total_enrollments,
    count(case when current_status = 'enrolled' then 1 end) as enrolled_enrollments,
    count(case when current_status = 'withdrawn' then 1 end) as withdrawn_enrollments,
    count(case when current_status = 'completed' then 1 end) as completed_enrollments
  from {{ ref('fct_trial_enrollments') }}
  where current_record = 1
  group by dim_clinical_trial_id
),

drug_assignments as (
  select
    dim_clinical_trial_id,
    count(distinct dim_drug_id) as distinct_drugs_assigned,
    count(distinct arm_label) as total_arms
  from {{ ref('fct_drug_assignments') }}
  where current_record = 1
  group by dim_clinical_trial_id
),

adverse_events as (
  select
    e.dim_clinical_trial_id,
    count(*) as total_adverse_events,
    count(case when a.severity = 'mild' then 1 end) as mild_adverse_events,
    count(case when a.severity = 'moderate' then 1 end) as moderate_adverse_events,
    count(case when a.severity = 'severe' then 1 end) as severe_adverse_events
  from {{ ref('fct_adverse_events') }} a
  left join {{ ref('fct_trial_enrollments') }} e
    on a.fct_trial_enrollment_id = e.fct_trial_enrollment_id
    and e.current_record = 1
  where a.current_record = 1
  group by e.dim_clinical_trial_id
)

select
  t.dim_clinical_trial_id,
  t.trial_name,
  t.therapeutic_area,
  t.status,
  t.sponsor_name,
  t.phase,
  t.end_date,
  coalesce(en.total_enrollments, 0) as total_enrollments,
  coalesce(en.enrolled_enrollments, 0) as enrolled_enrollments,
  coalesce(en.withdrawn_enrollments, 0) as withdrawn_enrollments,
  coalesce(en.completed_enrollments, 0) as completed_enrollments,
  coalesce(da.distinct_drugs_assigned, 0) as distinct_drugs_assigned,
  coalesce(da.total_arms, 0) as total_arms,
  coalesce(ae.total_adverse_events, 0) as total_adverse_events,
  coalesce(ae.mild_adverse_events, 0) as mild_adverse_events,
  coalesce(ae.moderate_adverse_events, 0) as moderate_adverse_events,
  coalesce(ae.severe_adverse_events, 0) as severe_adverse_events
from {{ ref('dim_clinical_trials') }} t
left join enrollments en on t.dim_clinical_trial_id = en.dim_clinical_trial_id
left join drug_assignments da on t.dim_clinical_trial_id = da.dim_clinical_trial_id
left join adverse_events ae on t.dim_clinical_trial_id = ae.dim_clinical_trial_id
