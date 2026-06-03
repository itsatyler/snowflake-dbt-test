{{ config(materialized='table') }}

select 
  *
from {{ ref('adverse_events') }}