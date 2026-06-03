{{ config(materialized='table') }}

select 
  *
from {{ ref('physicians') }}