
    SELECT
    channelkey,
    SUM(totalcost) AS totalcost,
    SUM(salesamount) AS totalsales,
    SUM(salesamount - totalcost) AS profit
    FROM "contosodb"."dbt_schema"."stg_contoso__sales"
    WHERE channelkey = 2
    GROUP BY channelkey
