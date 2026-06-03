{{
  config(
    materialized='incremental',
    unique_key='dim_clinical_trial_id',
    incremental_strategy='merge'
  )
}}

with src as (
  select * from {{ref('int_clinical_trials')}}
)
select
  trial_id as dim_clinical_trial_id,
  trial_name,
  therapeutic_area,
  status,
  sponsor_name,
  phase,
  end_date,
  updated_at
from src