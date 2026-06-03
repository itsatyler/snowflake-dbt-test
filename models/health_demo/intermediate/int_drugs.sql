{{ config(materialized='view') }}

with base as (
  select 
    *,
    row_number() over (
      partition by drug_id
      order by updated_at desc
    ) as rn
  from {{ ref('stg_drugs') }}
)
select * from base
where rn = 1