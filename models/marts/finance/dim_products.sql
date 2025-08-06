with products as (
    select distinct product_name
    from {{ ref('stg_stripe__transactions') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['product_name']) }} as dim_product_id,
    product_name,
    case 
        when product_name ilike any (array['laptop', 'phone', 'headphones']) then 'Electronics'
        when product_name ilike any (array['charger', 'mug']) then 'Accessories'
        else 'Office'
    end as category,
    current_timestamp as record_loaded_ts,
    date(current_timestamp) as effective_start_date,
    9999/12/31 as effective_end_date,
    'Y' as is_current
from products
