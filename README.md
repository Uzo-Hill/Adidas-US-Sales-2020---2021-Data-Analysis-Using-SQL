# Adidas US Sales (2020-2021) Data Analysis Using MySQL

---
![Project Banner](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Dashboard1.PNG)

---
## 📌 Introduction
This project analyzes Adidas US sales data (2020-2021) from different retailers in the United States to uncover business insights using MySQL. The dataset includes detailed sales information across products, time, and sales channels. The primary goal is to restructure and analyze this data to uncover actionable business insights that can inform sales strategies, product performance, and regional effectiveness.

---
## 🎯 Project Aim and Objectives

Aim:

To transform the raw Adidas US sales data into a clean, relational format and extract key business insights using SQL analytics.

Objectives:

- Clean and transform the data for consistency and analysis readiness.
- Normalize the dataset into a relational database structure using python.
- Use SQL queries to answer critical business questions for strategic decision-making.
- Create dashboards reports in Power BI and derive strategic recommendations for Adidas' retail performance.

---

## Dataset
The dataset used in this project was sourced from **Kaggle**:  
[Adidas US Sales dataset link](https://www.kaggle.com/datasets/sagarmorework/adidas-us-sales)


### Dataset Description
The dataset is a flat CSV file containing 9648 sales records for different Adidas retailers in the US. It contains the following columns:

- Retailer, Retailer ID

- Invoice Date

- Region
  
- State
  
- City

- Product

- Units Sold

- Total Sales, Operating Profit, Operating Margin

- Sales Method


### Raw Dataset
![Raw Dataset](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/RawAdidasDataset.PNG) 
  
---

## Technologies Used

- **Python (pandas)** for data cleaning & preprocessing
- **MySQL Workbench** for SQL querying and relational modeling
- **Power BI** for dashboard creation
- **GitHub** for project versioning and documentation.


---

## 🔧 Data Preparation & Transformation (Python)

The original flat file was transformed using Python into four normalized tables for better relational modeling:



---

## 🔧 Data Preparation & Transformation (Python)

The original flat file was transformed using Python into four normalized tables for better relational modeling:

### 🧹 Key Cleaning Steps

| Action                     | Description                                                |
|----------------------------|------------------------------------------------------------|
| Removed commas             | `"1,200"` → `1200` in `units_sold`                        |
| Stripped currency symbols  | Removed `$` for numeric conversion in `price`, `sales`     |
| Converted to float/int     | Enabled proper aggregations in SQL                         |
| Standardized column names  | CamelCase → `snake_case`                                   |
| Resolved retailer mapping  | Ensured each retailer had **one consistent ID**            |



```python

import pandas as pd

# Load the original CSV
file_path = "C:\Users\DELL\Desktop\Data Analytics Projects\Adidas Sales Analysis\Adidas US Sales1.xlsx"
df = pd.excel_csv(file_path)

# Rename columns to SQL-friendly names
df.rename(columns={
    'Retailer': 'retailer_name',
    'Retailer ID': 'retailer_id',
    'Invoice Date': 'invoice_date',
    'Region': 'region',
    'State': 'state',
    'City': 'city',
    'Product': 'product_name',
    'Price per Unit': 'price_per_unit',
    'Units Sold': 'units_sold',
    'Total Sales': 'total_sales',
    'Operating Profit': 'operating_profit',
    'Operating Margin': 'operating_margin',
    'Sales Method': 'sales_method'
}, inplace=True)

# Clean and convert money columns
money_columns = ['price_per_unit', 'total_sales', 'operating_profit']
for col in money_columns:
    df[col] = df[col].replace('[\$,]', '', regex=True).astype(float)

# Clean and convert 'operating_margin' column (remove % and convert to float)
df['operating_margin'] = df['operating_margin'].replace('[%]', '', regex=True).astype(float)

# Clean 'units_sold' (remove comma and convert to int)
df['units_sold'] = df['units_sold'].replace(',', '', regex=True).astype(int)

# Save cleaned CSV
cleaned_file_path = "adidas_sales_clean.csv"
df.to_csv(cleaned_file_path, index=False)

print(f"Cleaned CSV saved as: {cleaned_file_path}")

```

---


## 🧱 Database Schema Design

The cleaned data was split into a 4 normalized relational database for advanced SQL analytics like JOINS.

### 🧩 Tables:

1. retailers table
   - retailer_id (PK)
   - retailer

2. products table
   - product_id (PK)
   - product
   - price_per_unit

3. locations table
   - location_id (PK)
   - region
   - state
   - city

4. sales facttable
   - invoice_date
   - retailer_id (FK)
   - product_id (FK)
   - location_id (FK)
   - units_sold, total_sales, operating_profit, operating_margin, sales_method



  ![Dtabase Design](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/DBDesign.PNG) 

 ![Dtabase Design](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/EER_Diagram.PNG)


---


## 📊 Business Questions & SQL Analysis

Each question was answered using SQL with the outputs results saved for visualizations.


### ✅ Q1: What are the overall total sales, average profit margin, and total units sold?

![KPIQuery](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/KPI_query.PNG)


`Output:`



![KPIOutput](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/KPI_output.PNG)


