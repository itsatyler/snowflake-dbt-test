{% snapshot snap_employees %}

{{
  config(
    target_schema='snapshots',
    unique_key='employee_id',
    strategy='check',
    check_cols=[
      'first_name',
      'last_name',
      'department',
      'job_title',
      'manager_id',
      'location',
      'employee_status',
      'salary_band',
      'effective_date'
    ]
  )
}}

select *
from {{ ref('int_employees_latest') }}

{% endsnapshot %}