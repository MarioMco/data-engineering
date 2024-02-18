




    with grouped_expression as (
    select
        
        
    
   is not null as expression


    from "contosodb"."dbt_schema"."sales"
    where
        saleskey is not null
    
    

),
validation_errors as (

    select
        *
    from
        grouped_expression
    where
        not(expression = true)

)

select *
from validation_errors



