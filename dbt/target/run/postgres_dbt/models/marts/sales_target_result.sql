
  create view "contosodb"."dbt_schema"."sales_target_result__dbt_tmp"
    
    
  as (
    SELECT 
st.storekey,
ss.storename,
st.salestarget,
ss.totalsales,
(ss.totalsales - st.salestarget) as salesdiff,
CASE 
    WHEN 
    (ss.totalsales - st.salestarget) < 0 THEN 'NO'
    ELSE 'YES'
    END AS target_achieved
FROM "contosodb"."dbt_schema"."salestarget" st 
JOIN "contosodb"."dbt_schema"."store_sales" ss 
ON ss.storekey = st.storekey
  );