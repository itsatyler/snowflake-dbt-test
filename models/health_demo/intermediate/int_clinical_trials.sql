{{ config(materialized='view') }}

with base as (
  select 
    *,
    row_number() over (
      partition by trial_id
      order by updated_at desc
    ) as rn
  from {{ ref('stg_clinical_trials') }}
)
select * from base
where rn = 1