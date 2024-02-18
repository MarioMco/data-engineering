WITH products AS (
    SELECT * FROM "contosodb"."public"."dimproducts"
),

stores AS (
    SELECT * FROM "contosodb"."public"."dimstores"
),

stores_products AS (
    SELECT storekey, productkey FROM "contosodb"."public"."fctsales"
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