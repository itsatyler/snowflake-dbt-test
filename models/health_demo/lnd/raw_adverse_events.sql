{{ config(materialized='table') }}

select 
  *
from {{ source('seed','adverse_events') }}