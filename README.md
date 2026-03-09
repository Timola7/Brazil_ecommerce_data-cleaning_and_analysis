# Brazil_ecommerce_data-cleaning_and_analysis
This project represents a comprehensive Data Cleaning and Exploratory Data Analysis (EDA) workflow for the Olist Brazilian E-Commerce dataset. It transitions from raw data ingestion and schema definition to complex business intelligence queries, such as calculating rolling revenue and customer retention rates.

The project is designed to process a multi-table relational database containing information on customers, orders, products, and payments. Key operations include:

Data Ingestion & Sanitization: Using LOAD DATA INFILE to import CSVs and applying TRIM and DELETE operations to handle inconsistent formatting (like extra quotes or null values).

Feature Engineering: Extracting specific time components from timestamps to create new columns like shipping_limit_time.

Financial Analysis: Reconciling differences between item values (price + freight) and actual payments, as well as calculating monthly revenue growth and rolling totals using Window Functions (LAG, OVER).

Business Metrics: Determining the Repeat Purchase Rate, identifying top-performing product categories by revenue, and ranking the highest-spending customers

# Brazilian E-Commerce Data Analysis (Olist)

## Overview
This repository contains SQL scripts used to clean, transform, and analyze the Olist Brazilian E-Commerce dataset. The project covers the entire data pipeline from initial schema creation and data loading to advanced analytical querying.

## Database Schema
The script interacts with several key tables:
- `customers_dataset`: Customer location and identification.
- `orders`: Order status and timestamps.
- `order_items`: Product IDs, seller info, price, and freight.
- `order_payments`: Payment methods and transaction values.
- `products`: Product category metadata.
- `order_reviews`: Customer ratings and comments.

## Key Features

### 1. Data Cleaning & Preprocessing
- **Quote Stripping:** Uses `TRIM` to remove double quotes often found in raw CSV exports.
- **Null Handling:** Filters out incomplete records to ensure data integrity.
- **Type Correction:** Standardizes date strings and extracts specific time-of-day data into new columns.

### 2. Financial Metrics
- **Revenue Reconciliation:** Compares `price + freight` against `payment_value` to identify discrepancies across different order statuses.
- **Revenue Trends:** Calculates monthly revenue, rolling totals, and month-over-month growth percentages.

### 3. Customer & Product Insights
- **Repeat Purchase Rate:** Calculates the percentage of customers who have made more than one purchase.
- **Top Categories:** Identifies the top 10 product categories by total sales volume and revenue.
- **Geographic Analysis:** Aggregates sales data by state to identify regional performance.

## Requirements
- MySQL Server 8.0+
- Olist Dataset CSV files (placed in the MySQL `Uploads` directory for `LOAD DATA` operations).

## Usage
1. Execute the `CREATE TABLE` statements to set up the schema.
2. Update the file paths in the `LOAD DATA INFILE` commands to match your local environment.
3. Run the script sequentially to clean the data before moving to the analysis queries.
