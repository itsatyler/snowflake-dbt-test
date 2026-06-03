{{ config(materialized='table') }}

with src as (
  select * from {{ source('lnd', 'raw_customers') }}
)
  select
    md5(customer_id) as dim_customer_id,
    customer_id,
    first_name,
    last_name,
    email,
    state,
    region,
    signup_date,
    customer_status
  from src
