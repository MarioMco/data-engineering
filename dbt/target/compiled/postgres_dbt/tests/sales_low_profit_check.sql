SELECT 
saleskey
FROM "contosodb"."dbt_schema"."stg_contoso__sales"
WHERE ((salesamount - totalcost) / salesamount) < 0.15