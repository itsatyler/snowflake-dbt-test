{{ config(materialized='view') }}

select
  cast(upper(trim(enrollment_id)) as varchar) as enrollment_id,
  cast(event_date as date) as event_date,
  cast(event_description as text) as event_description,
  cast(upper(trim(event_id)) as varchar) as event_id,
  cast(upper(trim(patient_id)) as varchar) as patient_id,
  cast(reported_by as varchar) as reported_by,
  cast(resolved_date as date) as resolved_date,
  cast(lower(trim(severity)) as varchar) as severity
from {{ source('lnd','raw_adverse_events') }}