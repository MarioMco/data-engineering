
  
    

  create  table "contosodb"."dbt_schema"."dbt_factsales__dbt_tmp"
  
  
    as
  
  (
    

WITH DBT_FACTSALES AS (
    SELECT FS.TOTALCOST, D.PRODUCTNAME
    FROM FACTONLINESALES FS
    LEFT JOIN DIMPRODUCT D
    on FS.PRODUCTKEY = D.PRODUCTKEY
    group by FS.TOTALCOST, D.PRODUCTNAME
    order by FS.TOTALCOST desc
)

SELECT * FROM DBT_FACTSALES
  );
  