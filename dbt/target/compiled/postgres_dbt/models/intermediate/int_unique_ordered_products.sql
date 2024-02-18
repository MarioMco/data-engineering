with unique_product as (
    select productkey,
    SUM(salesquantity) as soldquantity
    from "contosodb"."public"."fctsales"
    group by productkey
)

select
        distinct on (productkey) *
    from unique_product
    order by productkey,productkey desc