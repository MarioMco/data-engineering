select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    SELECT channelname
    FROM "contosodb"."dbt_schema"."stg_contoso__channels"
    WHERE TRIM(channelname) = ''

      
    ) dbt_internal_test