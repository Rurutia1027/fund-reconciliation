# Mini Fund Reconciliation Warehouse 

## Introduction 
In e-commerce platforms, daily operations involve a large number of transactions, refunds, commissions, coupon redemptions, and other fund flows. To ensure clear accounting, accurate funds management, and error-free reconciliation, it is essential to build an efficient, accurate, and traceable fund reconciliation data warehouse. 

This project focus on building a reconciliation solution based on an offline data warehouse architecture. It tracks fund movement at **hourly**, **daily**, and **monthly** granularties to support financial and operational departments in timely issue detection and verification. 

## Tech Stack 
- Apache Airflow: Workflow orchestration.
- Docker / Docker Compose: Contrainerization and local environment setup
- dbt core: Data Transformation and modeling
- Apache Superset: BI and Visualization
- PostgreSQL: OLTP simulation, Data Warehouse backend, and Airflow metadata storage layer. 

## Granularity Levels 
![alt text](pics/granularity.png)

## System Requirements 
### Local Deployment 
#### Docker 
Make sure Docker Engine is installed. Then, navigate to the root folder containing `docker-compose.yml` and run: 

```bash
docker compose up --build 
```

#### Demo Credentials 
- Set in `.env` file
![env-credentials](./pics/docker-app-credentials.png)

- Ports Exposed Locally 
![docker-exposed-service-ports](./pics/docker-service-ports.png)

### K8S Cluster Deployment 
// todo 

## Project Structure Example 
```bash 
.
├── airflow/
│   ├── dags/
│   │   └── run_dbt.py        # Airflow DAG to trigger DBT DW & OLTP operations
│   └── Dockerfile
├── fund_recon_pipeline/                  
│   ├── profiles.yml
│   ├── models/
│   │   ├── oltp_source.sql
│   │   └── dw_model.sql
│   └── profiles.yml
├── docker-compose.yml
```

## Workflow Overview 
- **Data Generation**: Example transactional and flat file data (XML, CSV) are generated automatically. 
- **Data Ingestion**: Flat files and OLTP transactional data are imported to the staging area of the Data Warehouse using Airflow. 
- **Data Transformation**: dbt models clean, transform, and organize data into fact and dimension tables.
- **Data Analysis**: Explore the data using Superset dashboards by querying the Data Warehouse directly.

## Airflow DAGs Overview 
- `initialize_etl_environment`: Initializes database objects for ETL environment (one-time run).
- `import_main_data`: Imports transactional data to staging.
- `import_reseller_data`: Loads reseller flat file data to staging. 
- `run_dbt_init_tasks`: Install dbt dependencies and seeds static data (one-time run).
- `run_dbt_model`: Transforms, tests, and loads final Data Warehouse tables. 

## Architecture Overview 


## Data Warehouse Layers & Data Quality Monitoring 
### Data Warehouse Layers 
- **ODS(Operational Data Store)**: Contains raw transactional data such as orders, refunds, and vouchers.
- **DWD(Data Warehouse Data)**: Cleaned and structured data from ODS often used for operational reporting. This layer prepares data for further aggregation. 
- ***ADS(Analytical Data Store)**: Contains final reports, reconciliation results, and other analysis-ready outputs. Often includes KPIs or data used for anomaly detection. 

### Data Quality Monitoring 
- **Data Quality in DWD**: In this layer, data is cleaned and transformed using **dbt**. Data quality checks such as duplicates removal, normalization, and integrity checks are performed. 

- **Monitoring in DWS**: At this layer, we focus on verifying the accuracy of aggregated data. Checks include ensuring correct aggregation, completeness, and consistency across time periods. 

- **Validation in ADS**: Once the data is ready for analysis in ADS, we monitor for completeness, the correctness of financial reports, and the alignment of data with external platforms like payment gateways. 

## Visualization 

After workflows are completed, use:
- Airflow UI: Monitor ETL orchestration http://localhost:8080
- Superset UI: Query and visualize reconciliation data http://localhost:8088

## Additional Notes 