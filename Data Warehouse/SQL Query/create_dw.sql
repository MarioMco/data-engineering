-- Create database and tables

reate database sales_dw;


create table dimstore (
    store_key int primary key,
	store_type text null,
	store_name text not null,
	store_description text not null,
	store_status text not null,
	zip_code text null,
	store_phone text null,
    address_line text null,
    load_date timestamp not null default (now() at time zone 'utc'),
    update_date timestamp not null default (now() at time zone 'utc')
);



create table dimchannel (
	channel_key int primary key,
	channel_label text not null,
    channel_name text not null,
    channel_description text not null,
    load_date timestamp not null default (now() at time zone 'utc'),
    update_date timestamp not null default (now() at time zone 'utc')
);


create table dimproduct (
	product_key int primary key,
	product_label text null,
    product_name text null,
    product_description text null,
    manufacturer text null,
    brand_name text null,
    class_name text null,
    style_name text null,
    color_name text null,
    unit_cost numeric(10,2) null,
    unit_price numeric(10,2) null,
    avalable_for_sale_date timestamp null,
    stop_sale_date timestamp null,
	status text null,
	load_date timestamp not null default (now() at time zone 'utc'),
    update_date timestamp not null default (now() at time zone 'utc')
);


create table dimcalendar (
   date_key date primary key,
   calendar_year int not null,
   month_no int not null,
   day_no int not null,
   day_of_week_no int not null,
   week_no int not null,
   week_name text not null
);


create table factsales(
	sales_key serial primary key,
	channel_key int not null,
	date_key  date not null,
    store_key int not null,
    product_key int not null,
    unit_cost   numeric(10,2) not null,
    unit_price  numeric(10,2) not null,
    sales_quantity int not null,
    total_cost numeric(10,2) not null,
    sales_amount numeric(10,2) not null,
    load_date timestamp not null default (now() at time zone 'utc'),
    update_date timestamp not null default (now() at time zone 'utc'),
    constraint fk_store_key foreign key(store_key) references dimstore(store_key),
    constraint fk_channel_key foreign key(channel_key) references dimchannel(channel_key),
    constraint fk_product_key foreign key(product_key) references dimproduct(product_key),
    constraint fk_date_key foreign key(date_key) references dimcalendar(date_key)
);
