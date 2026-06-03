{{ config(materialized='table') }}

select 
  *
from {{ ref('patients') }}