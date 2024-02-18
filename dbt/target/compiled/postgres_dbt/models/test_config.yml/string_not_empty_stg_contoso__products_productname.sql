
    SELECT productname
    FROM "contosodb"."dbt_schema"."stg_contoso__products"
    WHERE TRIM(productname) = ''
