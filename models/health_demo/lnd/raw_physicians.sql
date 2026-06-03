{{ config(materialized='table') }}

select 
  *
from {{ source('seed','physicians') }}