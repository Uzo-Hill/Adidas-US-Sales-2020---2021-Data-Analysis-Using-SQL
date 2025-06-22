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

NEXT - Attach python cleaning code

---

## 🧱 Database Schema Design

The cleaned data was split into **4 normalized tables**:

### 🧩 Tables:

1. **`retailers`**
   - `retailer_id` (PK)
   - `retailer`

2. **`products`**
   - `product_id` (PK)
   - `product`
   - `price_per_unit`

3. **`locations`**
   - `location_id` (PK)
   - `region`, `state`, `city`

4. **`sales`**
   - `invoice_date`
   - `retailer_id` (FK)
   - `product_id` (FK)
   - `location_id` (FK)
   - `units_sold`, `total_sales`, `operating_profit`, `operating_margin`, `sales_method`

📌 **[Attach ERD Image Here]**  
`![ERD](./documentation/ERD.png)`

---
