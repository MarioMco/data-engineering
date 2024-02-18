{{
  config(
    materialized = 'table',
    )
}}

SELECT 
scp.productname,
st.storename,
scc.channelname,
s.unitcost,
s.unitprice,
s.salesquantity,
s.discountamount,
s.totalcost,
s.salesamount,
s.profit,
s.datekey
FROM {{ref('stg_contoso__sales')}} s
JOIN {{ref('int_contoso__stores')}} st
ON s.storekey = st.storekey 
JOIN {{ref('stg_contoso__products')}} scp 
ON scp.productkey = s.productkey 
JOIN {{ref('stg_contoso__channels')}} scc 
ON s.channelkey = scc.channelkey 
WHERE st.storestatus = 'Active'
ORDER BY s.salesamount DESC