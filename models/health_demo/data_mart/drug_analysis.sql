{{ config(materialized='table') }}

-- assignment volume + trial spread, per drug
with assignments as (
  select
    a.dim_drug_id,
    count(*) as total_assignments,
    count(distinct a.dim_clinical_trial_id) as distinct_trials_assigned,
    count(distinct t.therapeutic_area) as distinct_therapeutic_areas,
    round(avg(a.dosage_mg), 2) as avg_dosage_mg
  from {{ ref('fct_drug_assignments') }} a
  left join {{ ref('dim_clinical_trials') }} t
    on a.dim_clinical_trial_id = t.dim_clinical_trial_id
  where a.current_record = 1
  group by a.dim_drug_id
),

-- approximate: adverse events occurring in trials where the drug is assigned.
-- trial-level association (no patient-level drug-administration link exists).
drug_trials as (
  select distinct dim_drug_id, dim_clinical_trial_id
  from {{ ref('fct_drug_assignments') }}
  where current_record = 1
),

trial_adverse_events as (
  select
    e.dim_clinical_trial_id,
    count(*) as adverse_events
  from {{ ref('fct_adverse_events') }} a
  left join {{ ref('fct_trial_enrollments') }} e
    on a.fct_trial_enrollment_id = e.fct_trial_enrollment_id
    and e.current_record = 1
  where a.current_record = 1
  group by e.dim_clinical_trial_id
),

drug_adverse_events as (
  select
    dt.dim_drug_id,
    sum(coalesce(tae.adverse_events, 0)) as adverse_events_in_assigned_trials
  from drug_trials dt
  left join trial_adverse_events tae
    on dt.dim_clinical_trial_id = tae.dim_clinical_trial_id
  group by dt.dim_drug_id
)

select
  d.dim_drug_id,
  d.drug_name,
  d.generic_name,
  d.drug_class,
  d.manufacturer,
  d.approval_status,
  coalesce(a.total_assignments, 0) as total_assignments,
  coalesce(a.distinct_trials_assigned, 0) as distinct_trials_assigned,
  coalesce(a.distinct_therapeutic_areas, 0) as distinct_therapeutic_areas,
  a.avg_dosage_mg,
  coalesce(dae.adverse_events_in_assigned_trials, 0) as adverse_events_in_assigned_trials
from {{ ref('dim_drugs') }} d
left join assignments a on d.dim_drug_id = a.dim_drug_id
left join drug_adverse_events dae on d.dim_drug_id = dae.dim_drug_id
