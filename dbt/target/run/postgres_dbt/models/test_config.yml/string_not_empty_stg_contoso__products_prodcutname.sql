select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    SELECT prodcutname
    FROM "contosodb"."dbt_schema"."stg_contoso__products"
    WHERE TRIM(prodcutname) = ''

      
    ) dbt_internal_test