with src as (
    select * from {{ ref('stg_stripe__transactions') }}
),

dim_customers as (
    select customer_id, customer_dim_id
    from {{ ref('dim_customers') }}
),

dim_products as (
    select product_name, product_dim_id
    from {{ ref('dim_products') }}
)

select
    src.transaction_id,
    dc.customer_dim_id,
    dp.product_dim_id,
    src.amount,
    src.transaction_date,
    current_timestamp as record_loaded_ts
from src
left join dim_customers dc
    on src.customer_id = dc.customer_id
left join dim_products dp
    on lower(trim(src.product)) = lower(trim(dp.product_name))
