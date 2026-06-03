{% snapshot snap_adverse_events %}

{{
  config(
    target_schema='snapshots',
    unique_key='event_id',
    strategy='check',
    check_cols=[
      'enrollment_id',
      'patient_id',
      'reported_by',
      'event_description',
      'event_date',
      'severity',
      'resolved_date',
    ]
  )
}}

select *
from {{ ref('int_adverse_events') }}

{% endsnapshot %}