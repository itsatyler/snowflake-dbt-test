{{
  config(
    materialized='incremental',
    unique_key='dim_drug_id',
    incremental_strategy='merge'
  )
}}

with src as (
  select * from {{ref('int_drugs')}}
)
select
  drug_id as dim_drug_id,
  drug_name,
  generic_name,
  drug_class,
  manufacturer,
  approval_status,
  updated_at
from src