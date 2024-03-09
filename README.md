# Data-Warehousing-Implementation-for-Retail-Business

## Project Overview
This repository documents the design and implementation of a conceptual data warehouse for "Blue Sky Online", an online consumer electronics retailer operating across the United Kingdom and Europe. The data warehouse project aims to refine business processes, enhance business insights, and solve challenges associated with customer data management and analytics to facilitate optimal decision-making for business managers.

## Objective
The primary goal is to build a central data repository and analytics platform that consolidates customer, product, sales transactions, payment types, and other relevant business data from diverse sources into an integrated data warehouse for customer profiling, sales analysis, and data-driven decision-making.

## Implementation
The data warehouse, implemented using SQL Server and managed with Azure Data Studio and Docker containers, acts as a fundamental framework for data integration and analysis. The project showcases the Extract, Transform, and Load (ETL) processes, essential for aggregating and harmonizing disparate data into a coherent format suitable for business intelligence activities.

### Data Model and SQL Implementation
The SQL script included in this repository creates the following objects:
- Dimensional tables: `DateDim`, `CustomerDim`, `PaymentTypeDim`, `ChannelTypeDim` for capturing key business dimensions.
- Fact table: `SalesFact` to record transactional data.
- Staging tables and lookup tables to assist in the ETL process and ensure data integrity.
- Bulk insert operations from source files into staging tables and transformations into final dimensional and fact tables.


## Features
- Detailed ETL workflow documentation.
- Comprehensive database schema design.
- Analytical queries and procedures for actionable insights.

## Usage
To use this SQL script:
1. Set up an SQL Server environment.
2. Run the SQL script to create the data warehouse schema.
3. Execute the ETL process as documented in the script to populate the data warehouse.

## Technologies
- SQL Server: For relational data warehouse implementation.
- Azure Data Studio: For managing and querying the database.
- Docker: For containerization of the database services.

## Authors
- Marizeek Mabifa
