
with unique_product as (
    select productkey,
    SUM(salesquantity) as soldquantity
    from {{ source('contosodb', 'fctsales') }}
    group by productkey
)

{{ dbt_utils.deduplicate(
    relation='unique_product',
    partition_by='productkey',
    order_by="productkey desc",
   )
}}