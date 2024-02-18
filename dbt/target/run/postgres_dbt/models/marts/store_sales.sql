
  
    

  create  table "contosodb"."dbt_schema"."store_sales__dbt_tmp"
  
  
    as
  
  (
    

SELECT 
st.storekey,
st.storename,
SUM(s.totalcost) AS TotalCost,
SUM(s.salesamount) AS TotalSales,
SUM(s.profit) AS TotalProfit
FROM "contosodb"."dbt_schema"."stg_contoso__sales" s
JOIN "contosodb"."dbt_schema"."int_contoso__stores" st
ON s.storekey = st.storekey
GROUP BY st.storekey, st.storename
ORDER BY TotalSales DESC
  );
  