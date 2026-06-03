{{ config(materialized='table') }}

select 
  *
from {{ source('seed','trial_enrollments') }}