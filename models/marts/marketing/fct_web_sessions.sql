with src as (
    select * from {{ ref('stg_google_analytics__web_sessions') }}
),

dim_customers as (
    select customer_id, customer_dim_id
    from {{ ref('dim_customers') }}
),

dim_channels as (
    select channel_name, channel_dim_id
    from {{ ref('dim_channels') }}
)

select
    src.session_id,
    dc.customer_dim_id,
    dch.channel_dim_id,
    src.session_start,
    src.session_end,
    current_timestamp as record_loaded_ts
from src
left join dim_customers dc
    on src.customer_id = dc.customer_id
left join dim_channels dch
    on lower(trim(src.channel)) = lower(trim(dch.channel_name))
