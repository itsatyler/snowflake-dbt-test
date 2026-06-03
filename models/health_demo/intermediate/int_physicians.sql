{{ config(materialized='view') }}

with base as (
  select 
    *,
    row_number() over (
      partition by physician_id
      order by updated_at desc
    ) as rn
  from {{ ref('stg_physicians') }}
)
select * from base
where rn = 1