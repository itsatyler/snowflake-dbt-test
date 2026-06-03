{{ config(materialized='view') }}

with base as (
  select 
    *,
    row_number() over (
      partition by patient_id
      order by updated_at desc
    ) as rn
  from {{ ref('stg_patients') }}
)
select * from base
where rn = 1