-- Function that will update datetime in update_date column any time when data has been updated
create or replace function func_update_date()
returns trigger 
language plpgsql
as 
$$
begin 
	new.update_date = now() at time zone 'utc';
	
	return new;
end;
$$


-- Triggers to update datetime in update_date column
create trigger update_date_dimstore
before update
on dimstore
for each row 
execute procedure func_update_date();

create trigger update_date_dimchannel
before update
on dimchannel
for each row 
execute procedure func_update_date();

create trigger update_date_dimproduct
before update
on dimproduct
for each row 
execute procedure func_update_date();

create trigger update_date_factsales
before update
on factsales
for each row 
execute procedure func_update_date();