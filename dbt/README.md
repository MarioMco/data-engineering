In this example we used PostgreSQL database

### models

models are SQL queries that define transformations on the data within a data warehouse. Models are the core building blocks of a dbt project and represent the logical entities or datasets that you want to create or manipulate.

- we have spearate queries inside of the models into three folders:
  - `staging` - for loading raw or source data into our DB or data warehouse.
  - `intermediate` - for perform intermediate-level transformations on the staged data.
  - `marts` - for creating data marts, aggregate and organize data.
- `schema.yml` - this file is used to define the schema or structure of the output produced by a specific dbt model.
- `doc_blocks.md` - This documentation block is used to provide contextual information, explanations, and descriptions for various elements within the project, such as models, columns, and tests.

<img src="pics/Created docs.png" alt="dbt docs" title="dbt docs">

<img src="pics/Lineage graph.png" alt="dbt lineage graph" title="dbt lineage graph">

### seeds
seeds are static data files used to populate tables or models with initial data. These static data files can be in various formats such as CSV, JSON, or YAML, and they typically contain predefined data records that are loaded into the database when the dbt project is executed. 
 - In our example we have created `salestarget.csv` and used it in `sales_target_result.sql` query.
 - To use it in a query just use seed name without .csv for example `{{ref('salestarget')}}`.

### tests

tests are assertions that you define to validate the correctness and quality of your data transformations. In our example we have created:
  - `sales_low_profit_check.sql` - this is hardcoded test.
  - `string_not_empty.sql` - generic query that can be reused as many times as needed with different model and column.
  - `test_config.yml` - this file contains information about the tests. In our example we use it to run:
    - generic test we have created
    - built in tests
    - dbt_expectations package

<img src="pics/Low profit fail.png" alt="dbt tests" title="dbt tests">

### packages
dbt has an option to install packages and in our example we have installed `dbt_utils` and `dbt_expectations`. To install packages create yml file, in our case it's `packages.yml` and add packages we want to install. It's possible to install packages from github as well. After that we need to run `dbt deps`.

### materialized
The concept of "materialized" refers to how the output of a dbt model is stored in the data warehouse. By default it's set as `view`. In data warehouse it can be stored as:
  - `table` - When a model is materialized as a table, dbt executes the SQL query defined in the model and stores the result as a permanent table in the data warehouse. This means that the output of the model is persisted and can be queried directly like any other table in the database.
  - `view` - When a model is materialized as a view, dbt executes the SQL query defined in the model but does not store the result as a separate table. Instead, it creates a virtual view that represents the result of the query.
  - We can set type of `materialized` in `dbt_project.yml` or in the models query with config. For example: `{{ config(materialized = 'table')}}`.
  - `incremental` - Incremental materialization is a special type of materialization used for models that need to be updated incrementally based on changes in the source data. DBT generates SQL queries to perform incremental updates to the target table, allowing you to efficiently maintain the data warehouse's state without needing to rebuild the entire dataset each time. In our example we used it in `stg_contoso__sales.sql`. We check the DATEKEY and SALESKEY as unique ID so if SALESKEY exists it will update the row, otherwise it will just import new data.

### macros

macros are reusable blocks of SQL code. They allow you to define complex SQL functionality once and reuse it across multiple models or projects within your DBT project. In our example we have created `macro_common.sql`. In one file you can add as many macro as you want.

