{{ config(materialized='view') }}

with base as (
  select 
    *,
    row_number() over (
      partition by enrollment_id
      order by event_date desc
    ) as rn
  from {{ ref('stg_adverse_events') }}
)
select * from base
where rn = 1