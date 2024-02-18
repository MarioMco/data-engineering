SELECT 
saleskey
FROM {{ref('stg_contoso__sales')}}
WHERE ((salesamount - totalcost) / salesamount) < 0.15