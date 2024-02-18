
  create view "contosodb"."dbt_schema"."int_unique_ordered_products__dbt_tmp"
    
    
  as (
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
  );