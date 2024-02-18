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
FROM {{ref('salestarget')}} st 
JOIN {{ref('store_sales')}} ss 
ON ss.storekey = st.storekey 