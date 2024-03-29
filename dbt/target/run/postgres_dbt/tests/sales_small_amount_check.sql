select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      -- SELECT 
-- saleskey,
-- salesamount
-- FROM "contosodb"."dbt_schema"."stg_contoso__sales"
-- WHERE salesamount < 0

SELECT 
saleskey
FROM "contosodb"."dbt_schema"."stg_contoso__sales"
WHERE ((salesamount - totalcost) / salesamount) < 0.1
      
    ) dbt_internal_test