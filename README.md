# testing-snowflake-dbt

Practice dbt + Snowflake project building a layered analytics warehouse (landing → staging → intermediate → warehouse → marts) with dimensional modeling, SCD2 snapshots, and data tests.

## Stack

- **dbt-core** + **dbt-snowflake** (`>=1.11`)
- **Snowflake** as the warehouse
- **uv** for Python dependency management
- **Docker** (optional) for an isolated dbt runtime

## Architecture

```
lnd (raw)  →  stg (views)  →  intermediate (views)  →  dw (dims + facts)  →  data_mart (analytics tables/views)
```

Schemas are routed by `macros/generate_schema_name.sql` so each layer lands in its own Snowflake schema as configured in `dbt_project.yml`.

### Layers

| Layer | Materialization | Purpose |
|-------|-----------------|---------|
| `lnd` | (source, not managed by dbt) | Raw ingested tables |
| `stg` | view | Cast types, trim/normalize, rename |
| `intermediate` | view | Per-entity prep (e.g. latest record selection) |
| `dw` | table / incremental | Conformed dimensions + facts |
| `data_mart` | table / view | Analytics-ready marts |

### Models

**Dimensions** (`models/dw/`)
- `dim_customers`, `dim_products`, `dim_warehouses`
- `dim_status`, `dim_sales_channels`
- `dim_employees` — SCD2 via `snap_employees`, materialized incrementally

**Facts** (`models/dw/`)
- `fct_orders`, `fct_order_items`, `fct_payments`, `fct_shipments`, `fct_returns`
- `fct_inventory_snapshots`

**Marts** (`models/data_mart/`)
- `mart_product_sales` — units, gross sales, discounts by product
- `mart_sales_report` — sales rolled up with returns
- `mart_inventory_risk` — reorder-point classification + rolling 7/14d averages
- `mart_vw_active_employees` — current active employees view

**Snapshot** (`snapshots/`)
- `snap_employees` — check-strategy SCD2 on employee attributes

**Custom test** (`tests/`)
- `test_no_self_managers` — guards against `employee_id == manager_id`

## Layout

```
.
├── dbt_project.yml
├── Dockerfile
├── pyproject.toml
├── macros/
│   └── generate_schema_name.sql
├── models/
│   └──warehouse/
│       ├── stg/
│       ├── intermediate/
│       ├── dw/
│       └── data_mart/
├── snapshots/
│   └── snap_employees.sql
├── tests/
│   └── test_no_self_managers.sql
└── seeds/
```

## Usage

```bash
# Build everything
uv run dbt build

# Layer-by-layer
uv run dbt run --select warehouse.stg warehouse.intermediate
uv run dbt snapshot
uv run dbt run --select warehouse.dw warehouse.data_mart

# Tests only
uv run dbt test --select warehouse
```

## Docker

```bash
docker build -t testing-snowflake-dbt .
docker run --rm -it \
  -v "$HOME/.dbt:/root/.dbt:ro" \
  -v "$PWD:/app" \
  testing-snowflake-dbt
```

The container ships `dbt-core` + `dbt-snowflake` and mounts the host profile read-only.

## Notes

- Surrogate keys are `md5(...)` of natural keys (or composite keys for snapshot grain).
- `dim_employees` uses `dbt_valid_from`/`dbt_valid_to` from `snap_employees`; `current_record = 1` flags the active row.
- Schema routing relies on the custom `generate_schema_name` macro — custom schemas in model configs are used verbatim (not prefixed with the target schema).
