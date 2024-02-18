WITH products AS (
    SELECT * FROM {{source('contosodb', 'dimproducts')}}
),

stores AS (
    SELECT * FROM {{source('contosodb', 'dimstores')}}
),

stores_products AS (
    SELECT storekey, productkey FROM {{source('contosodb', 'fctsales')}}
    GROUP BY storekey, productkey 
),

final AS (
    SELECT 
    st.storename,
    p.productname
    FROM stores_products s
    JOIN products p
    ON s.productkey = p.productkey
    JOIN stores st
    ON s.storekey = st.storekey
)

SELECT * FROM final