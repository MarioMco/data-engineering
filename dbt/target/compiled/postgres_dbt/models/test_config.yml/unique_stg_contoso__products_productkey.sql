
    
    

select
    productkey as unique_field,
    count(*) as n_records

from "contosodb"."dbt_schema"."stg_contoso__products"
where productkey is not null
group by productkey
having count(*) > 1


