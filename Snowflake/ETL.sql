USE DATABASE EXAMPLE_DB;
USE ROLE SYSADMIN;

-- Create 3 schemas
CREATE OR REPLACE SCHEMA landing_zone;
CREATE OR REPLACE SCHEMA curated_zone;
CREATE OR REPLACE SCHEMA consumption_zone;
SHOW SCHEMAS;

-- Create Tables in LANDING_ZONE
USE SCHEMA LANDING_ZONE;

CREATE OR REPLACE TRANSIENT TABLE landing_channel(
channel_key varchar,
channel_label varchar,
channel_description varchar
) COMMENT='Channel table in landing_zone';

CREATE OR REPLACE TRANSIENT TABLE landing_product(
product_key varchar,
product_label varchar,
product_name varchar,
product_description varchar,
manufacturer varchar,
brand_name varchar,
unit_cost varchar,
unit_price varchar,
status varchar
) COMMENT='Product table in landing_zone';

CREATE OR REPLACE TRANSIENT TABLE landing_store(
store_key varchar,
store_type varchar,
store_name varchar,
store_description varchar,
store_status varchar,
zip_code varchar,
store_phone varchar,
address_line varchar
) COMMENT='Store table in landing_zone';

CREATE OR REPLACE TRANSIENT TABLE landing_sales(
sales_key varchar,
channel_key varchar,
store_key varchar,
product_key varchar,
unit_cost varchar,
unit_price varchar,
sales_quantity varchar,
total_cost varchar,
sales_amount varchar
) COMMENT='Sales table in landing_zone';

SHOW TABLES;

-- Create File Format
CREATE OR REPLACE FILE FORMAT csv_example
    TYPE = 'CSV'
    COMPRESSION = 'AUTO'
    FIELD_DELIMITER = ','
    RECORD_DELIMITER = '\n'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '\042'
    NULL_IF = ('\\N');


-- Create tables in Curated Zone
USE SCHEMA EXAMPLE_DB.CURATED_ZONE;

CREATE OR REPLACE TRANSIENT TABLE curated_channel(
channel_key number,
channel_label varchar(10),
channel_description varchar(200)
) COMMENT='Channel table in curated_zone';

CREATE OR REPLACE TRANSIENT TABLE curated_product(
product_key varchar(7),
product_label varchar(50),
product_name varchar(100),
product_description varchar(500),
manufacturer varchar(100),
brand_name varchar(50),
unit_cost number(7,2),
unit_price number(7,2),
status varchar(3)
) COMMENT='Product table in curated_zone';

CREATE OR REPLACE TRANSIENT TABLE curated_store(
store_key varchar(50),
store_type varchar(50),
store_name varchar(200),
store_description varchar(500),
store_status varchar(100),
zip_code varchar(10),
store_phone varchar(15),
address_line varchar(200)
) COMMENT='Store table in curated_zone';

CREATE OR REPLACE TRANSIENT TABLE curated_sales(
sales_key number,
channel_key number,
store_key number,
product_key varchar(7),
unit_cost number(7,2),
unit_price number(7,2),
sales_quantity number,
total_cost number(7,2),
sales_amount number(7,2)
) COMMENT='Sales table in curated_zone';

SHOW TABLES;

-- Insert all data from landing to curated zone tables
INSERT INTO EXAMPLE_DB.CURATED_ZONE.CURATED_CHANNEL(
channel_key,
channel_label,
channel_description
)
SELECT 
channel_key,
channel_label,
channel_description
FROM EXAMPLE_DB.LANDING_ZONE.LANDING_CHANNEL;



INSERT INTO EXAMPLE_DB.CURATED_ZONE.CURATED_PRODUCT(
product_key,
product_label,
product_name,
product_description,
manufacturer,
brand_name,
unit_cost,
unit_price,
status
)
SELECT
product_key,
product_label,
product_name,
product_description,
manufacturer,
brand_name,
unit_cost,
unit_price,
status
FROM EXAMPLE_DB.LANDING_ZONE.LANDING_PRODUCT;

INSERT INTO EXAMPLE_DB.CURATED_ZONE.CURATED_STORE(
store_key,
store_type,
store_name,
store_description,
store_status,
zip_code,
store_phone,
address_line
)
SELECT
store_key,
store_type,
store_name,
store_description,
store_status,
zip_code,
store_phone,
address_line
FROM EXAMPLE_DB.LANDING_ZONE.LANDING_STORE;

INSERT INTO EXAMPLE_DB.CURATED_ZONE.CURATED_SALES(
sales_key,
channel_key,
store_key,
product_key,
unit_cost,
unit_price,
sales_quantity,
total_cost,
sales_amount
)
SELECT
sales_key,
channel_key,
store_key,
product_key,
unit_cost,
unit_price,
sales_quantity,
total_cost,
sales_amount
FROM EXAMPLE_DB.LANDING_ZONE.LANDING_SALES;


-- Create tables in Consumption Zone
USE SCHEMA EXAMPLE_DB.CONSUMPTION_ZONE;

CREATE OR REPLACE TABLE channel_dim(
channel_key number,
channel_label varchar(10),
channel_description varchar(200),
load_date timestamp default current_timestamp,
update_date timestamp default current_timestamp
) COMMENT='Channel Dim table in consumption_zone';

CREATE OR REPLACE TABLE product_dim(
product_key varchar(7),
product_label varchar(50),
product_name varchar(100),
product_description varchar(500),
manufacturer varchar(100),
brand_name varchar(50),
unit_cost number(7,2),
unit_price number(7,2),
status varchar(3),
load_date timestamp default current_timestamp,
update_date timestamp default current_timestamp
) COMMENT='Product Dim table in consumption_zone';

CREATE OR REPLACE TABLE store_dim(
store_key varchar(50),
store_type varchar(50),
store_name varchar(200),
store_description varchar(500),
store_status varchar(100),
zip_code varchar(10),
store_phone varchar(15),
address_line varchar(200),
load_date timestamp default current_timestamp,
update_date timestamp default current_timestamp
) COMMENT='Store Dim table in consumption_zone';

CREATE OR REPLACE TABLE sales_fact(
sales_key number,
channel_key number,
store_key number,
product_key varchar(7),
unit_cost number(7,2),
unit_price number(7,2),
sales_quantity number,
total_cost number(7,2),
sales_amount number(7,2),
load_date timestamp default current_timestamp,
update_date timestamp default current_timestamp
) COMMENT='Sales Fact table in consumption_zone';

SHOW TABLES;

-- Insert all data from curated to consumption zone tables
INSERT INTO EXAMPLE_DB.CONSUMPTION_ZONE.CHANNEL_DIM(
channel_key,
channel_label,
channel_description
)
SELECT 
channel_key,
channel_label,
channel_description
FROM EXAMPLE_DB.CURATED_ZONE.CURATED_CHANNEL;




INSERT INTO EXAMPLE_DB.CONSUMPTION_ZONE.PRODUCT_DIM(
product_key,
product_label,
product_name,
product_description,
manufacturer,
brand_name,
unit_cost,
unit_price,
status
)
SELECT
product_key,
product_label,
product_name,
product_description,
manufacturer,
brand_name,
unit_cost,
unit_price,
status
FROM EXAMPLE_DB.CURATED_ZONE.CURATED_PRODUCT;

INSERT INTO EXAMPLE_DB.CONSUMPTION_ZONE.STORE_DIM(
store_key,
store_type,
store_name,
store_description,
store_status,
zip_code,
store_phone,
address_line
)
SELECT
store_key,
store_type,
store_name,
store_description,
store_status,
zip_code,
store_phone,
address_line
FROM EXAMPLE_DB.CURATED_ZONE.CURATED_STORE;

INSERT INTO EXAMPLE_DB.CONSUMPTION_ZONE.SALES_FACT(
sales_key,
channel_key,
store_key,
product_key,
unit_cost,
unit_price,
sales_quantity,
total_cost,
sales_amount
)
SELECT
sales_key,
channel_key,
store_key,
product_key,
unit_cost,
unit_price,
sales_quantity,
total_cost,
sales_amount
FROM EXAMPLE_DB.CURATED_ZONE.CURATED_SALES;

-- STAGES AND PIPES
USE SCHEMA EXAMPLE_DB.LANDING_ZONE;

-- Create Stages

CREATE OR REPLACE STAGE delta_channel_azure
  URL = 'azure://snowflakest21.blob.core.windows.net/snowflake-blob/channel/'
  CREDENTIALS=(AZURE_SAS_TOKEN=<azure_sas_token>);

CREATE OR REPLACE STAGE delta_product_azure
  URL = 'azure://snowflakest21.blob.core.windows.net/snowflake-blob/product/'
  CREDENTIALS=(AZURE_SAS_TOKEN=<azure_sas_token>);

CREATE OR REPLACE STAGE delta_store_azure
  URL = 'azure://snowflakest21.blob.core.windows.net/snowflake-blob/store/'
  CREDENTIALS=(AZURE_SAS_TOKEN=<azure_sas_token>);

CREATE OR REPLACE STAGE delta_sales_azure
  URL = 'azure://snowflakest21.blob.core.windows.net/snowflake-blob/sales/'
  CREDENTIALS=(AZURE_SAS_TOKEN=<azure_sas_token>);

SHOW STAGES;





-- Create Pipes

-- Integration
USE ROLE ACCOUNTADMIN;
CREATE NOTIFICATION INTEGRATION AZURE_BLOB_LOADING_EVENT
ENABLED=TRUE
TYPE=QUEUE
NOTIFICATION_PROVIDER=AZURE_STORAGE_QUEUE
AZURE_STORAGE_QUEUE_PRIMARY_URI='https://snowflakest21.queue.core.windows.net/snowflake-queue'
AZURE_TENANT_ID='2a4ac381-8ec2-4e06-88db-e46592950237';

SHOW INTEGRATIONS;
DESC NOTIFICATION INTEGRATION AZURE_BLOB_LOADING_EVENT;

-- Make it all like channel_pipe
USE SCHEMA LANDING_ZONE;
CREATE OR REPLACE PIPE channel_pipe
AUTO_INGEST=TRUE
INTEGRATION='AZURE_BLOB_LOADING_EVENT'
AS
COPY INTO EXAMPLE_DB.LANDING_ZONE.LANDING_CHANNEL
FROM @DELTA_CHANNEL_AZURE
FILE_FORMAT = (FORMAT_NAME='EXAMPLE_DB.LANDING_ZONE.CSV_EXAMPLE')
ON_ERROR = 'CONTINUE';


CREATE OR REPLACE PIPE product_pipe
AUTO_INGEST=TRUE
INTEGRATION='AZURE_BLOB_LOADING_EVENT'
AS
COPY INTO EXAMPLE_DB.LANDING_ZONE.LANDING_PRODUCT
FROM @DELTA_PRODUCT_AZURE
FILE_FORMAT = (FORMAT_NAME='EXAMPLE_DB.LANDING_ZONE.CSV_EXAMPLE')
PATTERN = '.*product.*[.]csv'
ON_ERROR = 'CONTINUE';

CREATE OR REPLACE PIPE store_pipe
AUTO_INGEST=TRUE
INTEGRATION='AZURE_BLOB_LOADING_EVENT'
AS
COPY INTO EXAMPLE_DB.LANDING_ZONE.LANDING_STORE
(store_key,store_type,store_name,store_description,store_status,zip_code,store_phone,address_line)
FROM (SELECT $1,$2,$3,$4,$5,$6,$7,$8 FROM @DELTA_STORE_AZURE)
FILE_FORMAT = (FORMAT_NAME='EXAMPLE_DB.LANDING_ZONE.CSV_EXAMPLE')
ON_ERROR = 'CONTINUE';

CREATE OR REPLACE PIPE sales_pipe
AUTO_INGEST=TRUE
INTEGRATION='AZURE_BLOB_LOADING_EVENT'
AS
COPY INTO EXAMPLE_DB.LANDING_ZONE.LANDING_SALES
FROM @DELTA_SALES_AZURE
FILE_FORMAT = (FORMAT_NAME='EXAMPLE_DB.LANDING_ZONE.CSV_EXAMPLE')
ON_ERROR = 'CONTINUE';

SHOW PIPES;

-- Check the Pipe Status
SELECT SYSTEM$PIPE_STATUS('channel_pipe');
SELECT SYSTEM$PIPE_STATUS('product_pipe');
SELECT SYSTEM$PIPE_STATUS('store_pipe');
SELECT SYSTEM$PIPE_STATUS('sales_pipe');


-- STREAMS Landing Zone
USE SCHEMA LANDING_ZONE;

CREATE OR REPLACE STREAM landing_channel_stream ON TABLE landing_channel
APPEND_ONLY = TRUE;
CREATE OR REPLACE STREAM landing_product_stream ON TABLE landing_product
APPEND_ONLY = TRUE;
CREATE OR REPLACE STREAM landing_store_stream ON TABLE landing_store
APPEND_ONLY = TRUE;
CREATE OR REPLACE STREAM landing_sales_stream ON TABLE landing_sales
APPEND_ONLY = TRUE;

SHOW STREAMS;

-- TASKS
USE SCHEMA CURATED_ZONE;

CREATE OR REPLACE TASK channel_curated_task
    WAREHOUSE = EXAMPLE_WH
    SCHEDULE = '1 minute'
WHEN
    SYSTEM$STREAM_HAS_DATA('example_db.landing_zone.landing_channel_stream')
AS
MERGE INTO example_db.curated_zone.curated_channel curated_channel
USING example_db.landing_zone.landing_channel_stream landing_channel_stream ON
curated_channel.channel_key = landing_channel_stream.channel_key
WHEN MATCHED
    THEN UPDATE SET
    curated_channel.channel_label = landing_channel_stream.channel_label,
    curated_channel.channel_description = landing_channel_stream.channel_description
WHEN NOT MATCHED THEN
INSERT(
channel_key,
channel_label,
channel_description
)
VALUES(
landing_channel_stream.channel_key,
landing_channel_stream.channel_label,
landing_channel_stream.channel_description
);


CREATE OR REPLACE TASK product_curated_task
    WAREHOUSE = EXAMPLE_WH
    SCHEDULE = '1 minute'
WHEN
    SYSTEM$STREAM_HAS_DATA('example_db.landing_zone.landing_product_stream')
AS
MERGE INTO example_db.curated_zone.curated_product curated_product
USING example_db.landing_zone.landing_product_stream landing_product_stream ON
curated_product.product_key = landing_product_stream.product_key
WHEN MATCHED
    THEN UPDATE SET
    curated_product.product_label = landing_product_stream.product_label,
    curated_product.product_name = landing_product_stream.product_name,
    curated_product.product_description = landing_product_stream.product_description,
    curated_product.manufacturer = landing_product_stream.manufacturer,
    curated_product.brand_name = landing_product_stream.brand_name,
    curated_product.unit_cost = landing_product_stream.unit_cost,
    curated_product.unit_price = landing_product_stream.unit_price,
    curated_product.status = landing_product_stream.status
WHEN NOT MATCHED THEN
INSERT(
product_key,
product_label,
product_name,
product_description,
manufacturer,
brand_name,
unit_cost,
unit_price,
status
)
VALUES(
landing_product_stream.product_key,
landing_product_stream.product_label,
landing_product_stream.product_name,
landing_product_stream.product_description,
landing_product_stream.manufacturer,
landing_product_stream.brand_name,
landing_product_stream.unit_cost,
landing_product_stream.unit_price,
landing_product_stream.status
);


CREATE OR REPLACE TASK store_curated_task
    WAREHOUSE = EXAMPLE_WH
    SCHEDULE = '1 minute'
WHEN
    SYSTEM$STREAM_HAS_DATA('example_db.landing_zone.landing_store_stream')
AS
MERGE INTO example_db.curated_zone.curated_store curated_store
USING example_db.landing_zone.landing_store_stream landing_store_stream ON
curated_store.store_key = landing_store_stream.store_key
WHEN MATCHED
    THEN UPDATE SET
    curated_store.store_type = landing_store_stream.store_type,
    curated_store.store_name = landing_store_stream.store_name,
    curated_store.store_description = landing_store_stream.store_description,
    curated_store.store_status = landing_store_stream.store_status,
    curated_store.zip_code = landing_store_stream.zip_code,
    curated_store.store_phone = landing_store_stream.store_phone,
    curated_store.address_line = landing_store_stream.address_line
WHEN NOT MATCHED THEN
INSERT(
store_key,
store_type,
store_name,
store_description,
store_status,
zip_code,
store_phone,
address_line
)
VALUES(
landing_store_stream.store_key,
landing_store_stream.store_type,
landing_store_stream.store_name,
landing_store_stream.store_description,
landing_store_stream.store_status,
landing_store_stream.zip_code,
landing_store_stream.store_phone,
landing_store_stream.address_line
);


CREATE OR REPLACE TASK sales_curated_task
    WAREHOUSE = EXAMPLE_WH
    SCHEDULE = '1 minute'
WHEN
    SYSTEM$STREAM_HAS_DATA('example_db.landing_zone.landing_sales_stream')
AS
MERGE INTO example_db.curated_zone.curated_sales curated_sales
USING example_db.landing_zone.landing_sales_stream landing_sales_stream ON
curated_sales.sales_key = landing_sales_stream.sales_key
WHEN MATCHED
    THEN UPDATE SET
    curated_sales.channel_key = landing_sales_stream.channel_key,
    curated_sales.store_key = landing_sales_stream.store_key,
    curated_sales.product_key = landing_sales_stream.product_key,
    curated_sales.unit_cost = landing_sales_stream.unit_cost,
    curated_sales.unit_price = landing_sales_stream.unit_price,
    curated_sales.sales_quantity = landing_sales_stream.sales_quantity,
    curated_sales.total_cost = landing_sales_stream.total_cost,
    curated_sales.sales_amount = landing_sales_stream.sales_amount
WHEN NOT MATCHED THEN
INSERT(
sales_key,
channel_key,
store_key,
product_key,
unit_cost,
unit_price,
sales_quantity,
total_cost,
sales_amount
)
VALUES(
landing_sales_stream.sales_key,
landing_sales_stream.channel_key,
landing_sales_stream.store_key,
landing_sales_stream.product_key,
landing_sales_stream.unit_cost,
landing_sales_stream.unit_price,
landing_sales_stream.sales_quantity,
landing_sales_stream.total_cost,
landing_sales_stream.sales_amount
);
    

SHOW TASKS;


-- Check the status via Task History
SELECT * FROM TABLE (information_schema.task_history())
    WHERE name IN ('CHANNEL_CURATED_TASK', 'PRODUCT_CURATED_TASK', 'SALES_CURATED_TASK', 'STORE_CURATED_TASK')
    ORDER BY scheduled_time DESC;


    
-- STREAMS Curated Zone
USE SCHEMA CURATED_ZONE;

CREATE OR REPLACE STREAM curated_channel_stream ON TABLE curated_channel;
CREATE OR REPLACE STREAM curated_product_stream ON TABLE curated_product;
CREATE OR REPLACE STREAM curated_store_stream ON TABLE curated_store;
CREATE OR REPLACE STREAM curated_sales_stream ON TABLE curated_sales;

SHOW STREAMS;


-- Create tasks for Consumption Zone
USE SCHEMA CONSUMPTION_ZONE;


CREATE OR REPLACE TASK channel_consumption_task
    WAREHOUSE = EXAMPLE_WH
    SCHEDULE = '5 minute'
WHEN
    SYSTEM$STREAM_HAS_DATA('example_db.curated_zone.curated_channel_stream')
AS
MERGE INTO example_db.consumption_zone.channel_dim channel_dim
USING example_db.curated_zone.curated_channel_stream curated_channel_stream ON
channel_dim.channel_key = curated_channel_stream.channel_key
WHEN MATCHED
    AND curated_channel_stream.METADATA$ACTION = 'INSERT'
    AND curated_channel_stream.METADATA$ISUPDATE = 'TRUE'
    THEN UPDATE SET
    channel_dim.channel_label = curated_channel_stream.channel_label,
    channel_dim.channel_description = curated_channel_stream.channel_description
WHEN NOT MATCHED 
    AND curated_channel_stream.METADATA$ACTION = 'INSERT'
    AND curated_channel_stream.METADATA$ISUPDATE = 'FALSE'
    THEN
INSERT(
channel_key,
channel_label,
channel_description
)
VALUES(
curated_channel_stream.channel_key,
curated_channel_stream.channel_label,
curated_channel_stream.channel_description
);


CREATE OR REPLACE TASK product_consumption_task
    WAREHOUSE = EXAMPLE_WH
    SCHEDULE = '5 minute'
WHEN
    SYSTEM$STREAM_HAS_DATA('example_db.curated_zone.curated_product_stream')
AS
MERGE INTO example_db.consumption_zone.product_dim product_dim
USING example_db.curated_zone.curated_product_stream curated_product_stream ON
product_dim.product_key = curated_product_stream.product_key
WHEN MATCHED
    AND curated_product_stream.METADATA$ACTION = 'INSERT'
    AND curated_product_stream.METADATA$ISUPDATE = 'TRUE'
    THEN UPDATE SET
    product_dim.product_label = curated_product_stream.product_label,
    product_dim.product_name = curated_product_stream.product_name,
    product_dim.product_description = curated_product_stream.product_description,
    product_dim.manufacturer = curated_product_stream.manufacturer,
    product_dim.brand_name = curated_product_stream.brand_name,
    product_dim.unit_cost = curated_product_stream.unit_cost,
    product_dim.unit_price = curated_product_stream.unit_price,
    product_dim.status = curated_product_stream.status
WHEN NOT MATCHED 
    AND curated_product_stream.METADATA$ACTION = 'INSERT'
    AND curated_product_stream.METADATA$ISUPDATE = 'FALSE'
    THEN
INSERT(
product_key,
product_label,
product_name,
product_description,
manufacturer,
brand_name,
unit_cost,
unit_price,
status
)
VALUES(
curated_product_stream.product_key,
curated_product_stream.product_label,
curated_product_stream.product_name,
curated_product_stream.product_description,
curated_product_stream.manufacturer,
curated_product_stream.brand_name,
curated_product_stream.unit_cost,
curated_product_stream.unit_price,
curated_product_stream.status
);


CREATE OR REPLACE TASK store_consumption_task
    WAREHOUSE = EXAMPLE_WH
    SCHEDULE = '5 minute'
WHEN
    SYSTEM$STREAM_HAS_DATA('example_db.curated_zone.curated_store_stream')
AS
MERGE INTO example_db.consumption_zone.store_dim store_dim
USING example_db.curated_zone.curated_store_stream curated_store_stream ON
store_dim.store_key = curated_store_stream.store_key
WHEN MATCHED
    AND curated_store_stream.METADATA$ACTION = 'INSERT'
    AND curated_store_stream.METADATA$ISUPDATE = 'TRUE'
    THEN UPDATE SET
    store_dim.store_type = curated_store_stream.store_type,
    store_dim.store_name = curated_store_stream.store_name,
    store_dim.store_description = curated_store_stream.store_description,
    store_dim.store_status = curated_store_stream.store_status,
    store_dim.zip_code = curated_store_stream.zip_code,
    store_dim.store_phone = curated_store_stream.store_phone,
    store_dim.address_line = curated_store_stream.address_line
WHEN NOT MATCHED 
    AND curated_store_stream.METADATA$ACTION = 'INSERT'
    AND curated_store_stream.METADATA$ISUPDATE = 'FALSE'
    THEN
INSERT(
store_key,
store_type,
store_name,
store_description,
store_status,
zip_code,
store_phone,
address_line
)
VALUES(
curated_store_stream.store_key,
curated_store_stream.store_type,
curated_store_stream.store_name,
curated_store_stream.store_description,
curated_store_stream.store_status,
curated_store_stream.zip_code,
curated_store_stream.store_phone,
curated_store_stream.address_line
);


CREATE OR REPLACE TASK sales_consumption_task
    WAREHOUSE = EXAMPLE_WH
    SCHEDULE = '5 minute'
WHEN
    SYSTEM$STREAM_HAS_DATA('example_db.curated_zone.curated_sales_stream')
AS
MERGE INTO example_db.consumption_zone.sales_fact sales_fact
USING example_db.curated_zone.curated_sales_stream curated_sales_stream ON
sales_fact.sales_key = curated_sales_stream.sales_key
WHEN MATCHED
    AND curated_sales_stream.METADATA$ACTION = 'INSERT'
    AND curated_sales_stream.METADATA$ISUPDATE = 'TRUE'
    THEN UPDATE SET
    sales_fact.channel_key = curated_sales_stream.channel_key,
    sales_fact.store_key = curated_sales_stream.store_key,
    sales_fact.product_key = curated_sales_stream.product_key,
    sales_fact.unit_cost = curated_sales_stream.unit_cost,
    sales_fact.unit_price = curated_sales_stream.unit_price,
    sales_fact.sales_quantity = curated_sales_stream.sales_quantity,
    sales_fact.total_cost = curated_sales_stream.total_cost,
    sales_fact.sales_amount = curated_sales_stream.sales_amount
WHEN NOT MATCHED 
    AND curated_sales_stream.METADATA$ACTION = 'INSERT'
    AND curated_sales_stream.METADATA$ISUPDATE = 'FALSE'
    THEN
INSERT(
sales_key,
channel_key,
store_key,
product_key,
unit_cost,
unit_price,
sales_quantity,
total_cost,
sales_amount
)
VALUES(
curated_sales_stream.sales_key,
curated_sales_stream.channel_key,
curated_sales_stream.store_key,
curated_sales_stream.product_key,
curated_sales_stream.unit_cost,
curated_sales_stream.unit_price,
curated_sales_stream.sales_quantity,
curated_sales_stream.total_cost,
curated_sales_stream.sales_amount
);


SHOW TASKS;

SELECT * FROM TABLE (information_schema.task_history())
    WHERE name IN ('CHANNEL_CONSUMPTION_TASK', 'PRODUCT_CONSUMPTION_TASK', 'SALES_CONSUMPTION_TASK', 'STORE_CONSUMPTION_TASK')
    ORDER BY scheduled_time DESC;


-- Start running tasks
USE SCHEMA CURATED_ZONE;
ALTER TASK channel_curated_task RESUME;
ALTER TASK product_curated_task RESUME;
ALTER TASK store_curated_task RESUME;
ALTER TASK sales_curated_task RESUME;


USE SCHEMA CONSUMPTION_ZONE;
ALTER TASK channel_consumption_task RESUME;
ALTER TASK product_consumption_task RESUME;
ALTER TASK store_consumption_task RESUME;
ALTER TASK sales_consumption_task RESUME;

-- Start Pipes
USE SCHEMA LANDING_ZONE;
ALTER PIPE channel_pipe REFRESH;
ALTER PIPE product_pipe REFRESH;
ALTER PIPE store_pipe REFRESH;
ALTER PIPE sales_pipe REFRESH;

-- Stop running tasks
USE SCHEMA CURATED_ZONE;
ALTER TASK channel_curated_task SUSPEND;
ALTER TASK product_curated_task SUSPEND;
ALTER TASK store_curated_task SUSPEND;
ALTER TASK sales_curated_task SUSPEND;

USE SCHEMA CONSUMPTION_ZONE;
ALTER TASK channel_consumption_task SUSPEND;
ALTER TASK product_consumption_task SUSPEND;
ALTER TASK store_consumption_task SUSPEND;
ALTER TASK sales_consumption_task SUSPEND;








    










