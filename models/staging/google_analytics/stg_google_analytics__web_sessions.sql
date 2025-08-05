with source as (
    select * from {{ source('google_analytics', 'web_sessions') }}
)

select
    session_id,
    customer_id,
    cast(session_start as timestamp) as session_start,
    cast(session_end as timestamp) as session_end,
    lower(trim(channel)) as channel,
    CURRENT_TIMESTAMP AS record_loaded_ts
from source
