{{ config(materialized='view') }}

with base as (
  select 
    *,
    row_number() over (
      partition by enrollment_id
      order by enrolled_date desc 
    ) as rn
  from {{ ref('stg_trial_enrollments') }}
)
select * from base
where rn = 1