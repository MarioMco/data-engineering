select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select productkey
from "contosodb"."dbt_schema"."stg_contoso__products"
where productkey is null



      
    ) dbt_internal_test