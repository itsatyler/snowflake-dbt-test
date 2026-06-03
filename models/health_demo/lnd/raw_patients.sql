{{ config(materialized='table') }}

select 
  *
from {{ source('seed','patients') }}