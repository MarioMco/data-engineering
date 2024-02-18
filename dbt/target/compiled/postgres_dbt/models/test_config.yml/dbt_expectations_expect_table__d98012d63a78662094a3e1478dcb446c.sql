
    with a as (
        
    select
        
        count(*) as expression
    from
        "contosodb"."dbt_schema"."stg_contoso__sales"
    

    ),
    b as (
        
    select
        
        count(*) * 1 as expression
    from
        "contosodb"."dbt_schema"."sales"
    

    ),
    final as (

        select
            
            a.expression,
            b.expression as compare_expression,
            abs(coalesce(a.expression, 0) - coalesce(b.expression, 0)) as expression_difference,
            abs(coalesce(a.expression, 0) - coalesce(b.expression, 0))/
                nullif(a.expression * 1.0, 0) as expression_difference_percent
        from
        
            a cross join b
        
    )
    -- DEBUG:
    -- select * from final
    select
        *
    from final
    where
        
        expression_difference > 0.0
        
