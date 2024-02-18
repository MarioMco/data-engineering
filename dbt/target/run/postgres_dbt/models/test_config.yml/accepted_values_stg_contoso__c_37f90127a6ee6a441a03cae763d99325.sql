select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with all_values as (

    select
        channelname as value_field,
        count(*) as n_records

    from "contosodb"."dbt_schema"."stg_contoso__channels"
    group by channelname

)

select *
from all_values
where value_field not in (
    'Store','Online','Catalog'
)



      
    ) dbt_internal_test