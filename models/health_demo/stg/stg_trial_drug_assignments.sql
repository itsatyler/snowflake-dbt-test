{{ config(materialized='view') }}

select 
  lower(trim(arm_label)) as arm_label,
  upper(trim(assignment_id)) as assignment_id,
  {{ safe_cast('dosage_mg', 'number(5,1)') }} as dosage_mg,
  upper(trim(drug_id)) as drug_id,
  frequency,
  upper(trim(trial_id)) as trial_id
from {{ source('lnd', 'raw_trial_drug_assignments') }}