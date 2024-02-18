{% macro macro_generate_profit(ch_key=1)%}
    SELECT
    channelkey,
    SUM(totalcost) AS totalcost,
    SUM(salesamount) AS totalsales,
    SUM(salesamount - totalcost) AS profit
    FROM {{ ref('stg_contoso__sales')}}
    WHERE channelkey = {{ch_key}}
    GROUP BY channelkey
{% endmacro %}
