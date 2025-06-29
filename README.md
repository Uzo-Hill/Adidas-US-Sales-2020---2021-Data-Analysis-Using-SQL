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
df = pd.read_excel(file_path)

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

---


### ✅ Q2: How did Adidas’ sales, margins, and units vary between 2020 and 2021?

![YoYQuery](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/YoY_Sales_Query.PNG)


`Output:`


![YoYoutput](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/YoYOutput.PNG)

---

### ✅ Q3: How do monthly and quarterly sales trends reveal seasonal patterns for better inventory planning?


![YoYoutput](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Monthly_Sales_Query.PNG)

`Output:`


![YoYoutput](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Monthly_Sales_Output.PNG)


![YoYoutput](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Quarterly_Sales_Output.PNG)


---

---

### ✅ Q4: Which products generates the highest total sales and profit?


![RevenueProductQuery](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Sales_By_Product_Query.PNG)


`Output:`


![RevenueProductOutput](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Sales_By_Product_Output.PNG)


---

---

### ✅ Q5: Which regions and states deliver the highest sales volume and profitability margins to prioritize expansion and marketing efforts?


![RevenueByLocation](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Sales_By_Location_Query.PNG)


`Output:`


![RevenueByLocation](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Sales_By_Location_Output.PNG)



![RevenueByLocation](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Sales_By_State_output.PNG)

---


---


### ✅ Q6: Which retailers generate the highest sales volume and profit margins across product categories?



![RevenueByRetailers](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Sales_By_Retailer_Query.PNG)


`Output:`

![RevenueByRetailers](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Sales_By_Retailer_Output.PNG)


---


---

### ✅ Q7: How do different sales channels compare in terms of sales volume, profitability margins, and average transaction size to optimize channel strategy? 



![RevenueByChannels](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Sales_Channels_Query.PNG)


`Output:`

![RevenueByChannel](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Sales_Channels_Output.PNG)


---


---


### ✅ Q8: What are the low performing states and cities?



![LowPerformingCities](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/LowPerformingLocationsQuery.PNG)


`Output:`

![LowPerformingCities](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/LowPerformingLocationsOutput.PNG)


---

---


## 📈 Data Visualization
Dashboards reports were built in **Power BI**  to visualize major KPIs and insights from our SQL data query outputs.







## 📊 Dashboard Visualizations

| [![Executive Dashboard](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Dashboard1.PNG)](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Dashboard1.PNG) | [![Geographic Dashboard](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Dashboard2.PNG)](https://github.com/Uzo-Hill/Adidas-US-Sales-2020---2021-Data-Analysis-Using-SQL/blob/main/ProjectImages/Dashboard2.PNG) |
|:-------------------------------------------------------------:|:--------------------------------------------------------------:|
| **Executive Summary**<br>KPIs and trends                      | **Geographic Analysis**<br>Regional performance                |


---


---


## 🔍 Key Insights
- In 2021, Adidas recorded a total sales revenue of $717.8M, representing a YoY increase of $535.7M from $182.1M in 2020. Units sold also surged from 462K to 2.02M, a growth of 1.55M units. Additionally, the average profit margin improved from 40.37% to 42.60%, marking a YoY gain of 2.23%.
- Monthly and quarterly trend analysis revealed Q3 and July as peak sales periods.
- Men’s Street Footwear and Women’s Apparel were top-performing categories, generating $209M and $179M in total sales respectively,
- In-store generated **45%** of sales but Online had best margins (**39%**)
- West Gear and Foot Locker emerged as the top-performing retailers by sales volume, generating $243.0M and $220.1M respectively. Together, they contributed approximately 51.5% of Adidas’ total sales revenue across all retail partners, highlighting their strategic importance in overall retail performance.
- New York, California, and Florida led Adidas' state-level performance, contributing a combined 20.4% of total sales—$64.2M, $60.2M, and $59.3M respectively—making them the top three revenue-generating states across the U.S. during the 2020–2021 period.


---


---

## ✅ Recommendations
- Prioritize inventory and marketing investments in high-performing states like New York, California, and Florida to maximize regional returns.

- Strengthen partnerships with top-performing retailers such as West Gear and Foot Locker to scale distribution and leverage existing sales momentum.

- Enhance online and outlet channel strategies by optimizing product bundling and digital promotions to improve their profit margins and sales contribution.



## 🧠 Final Thoughts

This project demonstrates how a well-structured relational dataset and effective SQL queries can uncover valuable retail insights. Integrating SQL with dashboarding tools enables powerful storytelling and decision support.

---

## 📌 Project Credits

- **Author:** Uzoh C. Hillary  
- **LinkedIn:** [linkedin.com/in/hillaryuzoh](https://www.linkedin.com/in/hillaryuzoh)  
- **GitHub:** [github.com/Uzo-Hill](https://github.com/Uzo-Hill)

---


---

> ⭐ **Feel free to contribute improvements.**

