with src as (
    select * from {{ ref('stg_zendesk__support_tickets') }}
),

dim_customers as (
    select customer_id, dim_customer_id
    from {{ ref('dim_customers') }}
)

select
    src.ticket_id,
    dc.dim_customer_id,
    src.ticket_status,
    src.created_at,
    src.closed_at,
    src.category,
    current_timestamp as record_loaded_ts
from src
left join dim_customers dc
    on src.customer_id = dc.customer_id
