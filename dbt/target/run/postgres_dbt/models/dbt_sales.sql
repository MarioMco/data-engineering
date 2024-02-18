
  create view "psql_contosodb"."dbt_schema"."dbt_sales__dbt_tmp"
    
    
  as (
    SELECT
p.productname,
p.productcategoryname,
COUNT(f.productkey) AS ProductSalesNo,
SUM(f.salesamount * f.salesquantity) AS Total
FROM "psql_contosodb"."dbt_schema"."dbt_factonlinesales_stg" f
JOIN
"psql_contosodb"."dbt_schema"."dbt_product_stg" p
ON f.productkey = p.productkey
GROUP BY
p.productname,
p.productcategoryname
ORDER BY ProductSalesNo DESC
  );