select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    SELECT productname
    FROM "contosodb"."dbt_schema"."stg_contoso__products"
    WHERE TRIM(productname) = ''

      
    ) dbt_internal_test