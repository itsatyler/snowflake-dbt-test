{{
  config(
    materialized='incremental',
    unique_key='fct_drug_assignment_id'
  )
}}

with src as (
  select * from {{ref('snap_drug_assignments')}}
)
select
  sha2(concat(s.assignment_id, '|', c.dim_clinical_trial_id, '|', d.dim_drug_id)) as fct_drug_assignment_id,
  s.assignment_id,
  c.dim_clinical_trial_id,
  d.dim_drug_id,
  s.arm_label,
  s.frequency,
  s.dosage_mg,
  dbt_valid_from as from_dt,
  dbt_valid_to as to_dt,
  case
    when dbt_valid_to is null then 1
    else 0
  end as current_record
from src s
left join {{ref('dim_clinical_trials')}} c on s.trial_id = c.dim_clinical_trial_id
left join {{ref('dim_drugs')}} d on s.drug_id = d.dim_drug_id