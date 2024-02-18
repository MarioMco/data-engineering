
    SELECT channelname
    FROM "contosodb"."dbt_schema"."stg_contoso__channels"
    WHERE TRIM(channelname) = ''
