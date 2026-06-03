{{ config(materialized='table') }}

select 
  *
from {{ ref('clinical_trials') }}