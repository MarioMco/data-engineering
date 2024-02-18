{{
  config(
    materialized = 'table',
    )
}}

SELECT 
st.storekey,
st.storename,
SUM(s.totalcost) AS TotalCost,
SUM(s.salesamount) AS TotalSales,
SUM(s.profit) AS TotalProfit
FROM {{ref('stg_contoso__sales')}} s
JOIN {{ref('int_contoso__stores')}} st
ON s.storekey = st.storekey
GROUP BY st.storekey, st.storename
ORDER BY TotalSales DESC