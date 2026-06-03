{{
  config(
    materialized='incremental',
    unique_key='dim_physician_id',
    incremental_strategy='merge'
  )
}}

with src as (
  select * from {{ref('int_physicians')}}
)
select
  physician_id as dim_physician_id,
  honorific,
  first_name,
  last_name,
  specialty,
  npi_number,
  employment_type,
  affiliated_hospital,
  license_state,
  updated_at
from src