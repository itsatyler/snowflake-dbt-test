{% snapshot snap_enrollments%}

{{
  config(
    target_schema='snapshots',
    unique_key='enrollment_id',
    strategy='check',
    check_cols=[
      'patient_id',
      'trial_id',
      'enrolled_date',
      'current_status',
      'withdrawal_reason',
      'withdrawal_date',
      'updated_at',
    ]
  )
}}

select *
from {{ref('int_trial_enrollments')}}

{% endsnapshot %}