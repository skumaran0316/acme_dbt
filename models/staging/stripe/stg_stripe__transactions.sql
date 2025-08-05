with source as (
    select * from {{ source('stripe', 'transactions') }}
)

select
    id as transaction_id,
    customer_id,
    try_cast(amount as float) as amount,
    cast(transaction_date as date) as transaction_date,
    initcap(trim(product)) as product
from source
