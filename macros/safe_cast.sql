{% macro safe_cast(column_name, target_type) %}
  {%- set supported_try_cast_types = ['ARRAY', 'BINARY', 'BOOLEAN', 'DATE', 'DATETIME', 'DECIMAL', 'NUMBER', 'TIME', 'TIMESTAMP', 'VARCHAR', 'DOUBLE'] -%}
  
  {%- if target_type | upper in supported_try_cast_types -%}
    TRY_CAST({{ column_name }} AS {{ target_type }})
  {%- else -%}
    CAST({{ column_name }} AS {{ target_type }})
  {%- endif -%}
{% endmacro %}