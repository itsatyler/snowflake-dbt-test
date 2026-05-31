{{ config(materialized='view') }}

with ranked as (
  select
    *,
    row_number() over (
      partition by employee_id
      order by effective_date desc, ingest_date desc
    ) as rn
  from {{ref('stg_employees')}}
)
select * from ranked where rn = 1
