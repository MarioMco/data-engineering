-- Tables size
select
  schema_name,
  relname,
  pg_size_pretty(table_size) as size,
  table_size
from (
       select
         pg_catalog.pg_namespace.nspname as schema_name,
         relname,
         pg_relation_size(pg_catalog.pg_class.oid) as table_size
       from pg_catalog.pg_class
       join pg_catalog.pg_namespace on relnamespace = pg_catalog.pg_namespace.oid
     ) t
where schema_name = 'public'
order by table_size desc;


-- Check dimstore data
select 
	count(*),
	max(update_date) as "Latest Update"
from dimstore;


-- Check dimchannel data
select 
	count(*),
	max(update_date) as "Latest Update"
from dimchannel;


--- Check dimproduct data
select
	count(*),
	max(update_date) as "Latest Update"
from dimproduct;



-- Check dimcalendar data
select 
	min(date_key) as "First Date", 
	max(date_key) as "Last Date",
	count(*) as "Number of Days"
from dimcalendar;



-- Check factsales data
select
	count(*),
	max(update_date) as "Latest Update"
from factsales;



-- Data Analyis
select  
    s.store_name as "Store",
    SUM(f.sales_amount) as "Total Sales"
from factsales f
left join dimstore s
on f.store_key  = s.store_key  
group by s.store_key 
order by "Total Sales" desc;


select 
	c.calendar_year as "Year",
	c.month_no as "Month",
	sum(s.sales_amount) as "Sales Amount",
	sum(s.sales_quantity) as "Total Qunatity"
from dimcalendar c
left join factsales s
on c.date_key = s.date_key 
group by c.calendar_year, c.month_no 
order by c.calendar_year, c.month_no;




