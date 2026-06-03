{{ config(materialized='view') }}

with base as (
  select 
    *,
    row_number() over (
      partition by assignment_id
      order by drug_id desc
    ) as rn
  from {{ ref('stg_trial_drug_assignments') }}
)
select * from base
where rn = 1