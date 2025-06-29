-- Create the Database Schema
CREATE DATABASE adidas_sales;
USE adidas_sales;

-- Creating retailers table:
CREATE TABLE retailers (
    retailer_id INT PRIMARY KEY,
    retailer VARCHAR(100)
);

-- Creating product table:
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product VARCHAR(100),
    price_per_unit DECIMAL(10,2)
);




-- Creating locations table:
CREATE TABLE locations (
    location_id INT PRIMARY KEY,
    region VARCHAR(50),
    state VARCHAR(50),
    city VARCHAR(50)
);

-- Creating sales table:
CREATE TABLE sales (
    invoice_date DATE,
    retailer_id INT,
    product_id INT,
    location_id INT,
    units_sold INT,
    total_sales DECIMAL(15,2),
    operating_profit DECIMAL(15,2),
    operating_margin VARCHAR(10),
    sales_method VARCHAR(50),
    FOREIGN KEY (retailer_id) REFERENCES retailers(retailer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

TRUNCATE TABLE sales;
SELECT * FROM sales;

ALTER TABLE sales
MODIFY COLUMN operating_margin DECIMAL(5,2);

SELECT * FROM retailers;

SELECT * FROM products;
SELECT * FROM locations;
SELECT * FROM sales;

SELECT DISTINCT retailer
FROM retailers
WHERE retailer IS NOT NULL;

-- Disable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;

-- Truncate the table
TRUNCATE TABLE retailers;

TRUNCATE TABLE sales;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;





SELECT sales_method FROM sales;

SELECT * FROM locations;

SELECT * FROM products;

-- DATA ANALYSIS

-- Q 1: What are the overall total sales, average profit margin, and total units sold across the entire Adidas US sales for the period?

SELECT
    COUNT(invoice_date) AS total_transactions,
    ROUND(SUM(total_sales), 2) AS total_sales_usd,
    ROUND(AVG(operating_margin) * 100, 2) AS avg_profit_margin_percentage,
    SUM(units_sold) AS total_units_sold
FROM sales;

         

    
-- Business Insights:
-- Top Product: Men's Street Footwear leads in both sales ($208.8M) and profit ($82.8M)
-- Margin Leader: Also has the highest margin at 39.65%

-- Q2: How did Adidas’ total sales, profit margins, and units sold vary across 2020 and 2021 to assess year-over-year performance?

SELECT 
    YEAR(invoice_date) AS sales_year,
    ROUND(SUM(total_sales), 2) AS total_sales_usd,
    ROUND(AVG(operating_margin) * 100, 2) AS avg_profit_margin_percentage,
    SUM(units_sold) AS total_units_sold,

    -- YoY calculations
    ROUND(SUM(total_sales) - LAG(SUM(total_sales)) OVER (ORDER BY YEAR(invoice_date)), 2) AS yoy_sales_change,
    ROUND(SUM(units_sold) - LAG(SUM(units_sold)) OVER (ORDER BY YEAR(invoice_date)), 0) AS yoy_units_change,
    ROUND(
        (AVG(operating_margin) * 100) - 
        LAG(AVG(operating_margin) * 100) OVER (ORDER BY YEAR(invoice_date)), 2
    ) AS yoy_profit_margin_change

FROM sales
GROUP BY YEAR(invoice_date)
ORDER BY sales_year;


-- Q 3: How do monthly and quarterly sales trends reveal seasonal patterns for better inventory planning?
	-- A: Monthly Performance Analysis:
SELECT
    MONTHNAME(s.invoice_date) AS sales_month,
    MONTH(s.invoice_date) AS month_number,
    SUM(s.total_sales) AS total_sales,
    SUM(s.units_sold) AS total_units_sold,
    ROUND(AVG(s.operating_margin) * 100, 2) AS profit_margin_percentage,
    
    RANK() OVER (ORDER BY SUM(s.total_sales) DESC) AS sales_rank,
    RANK() OVER (ORDER BY AVG(s.operating_margin) DESC) AS profit_margin_rank

FROM sales s
GROUP BY month_number, sales_month
ORDER BY month_number;

-- B: Quartely Performance Analysis:
SELECT
    CASE QUARTER(invoice_date)
        WHEN 1 THEN 'Q1'
        WHEN 2 THEN 'Q2'
        WHEN 3 THEN 'Q3'
        WHEN 4 THEN 'Q4'
    END AS sales_quarter,
    
    ROUND(SUM(total_sales), 2) AS total_sales_usd,
    SUM(units_sold) AS total_units_sold,
    ROUND(AVG(operating_margin) * 100, 2) AS profit_margin_percentage,
    
    RANK() OVER (ORDER BY SUM(total_sales) DESC) AS sales_rank,
    RANK() OVER (ORDER BY AVG(operating_margin) DESC) AS profit_margin_rank

FROM sales
GROUP BY sales_quarter
ORDER BY sales_quarter;


 -- Q 4: Which products generates the highest total sales and profit?      

SELECT 
    p.product,
    SUM(s.units_sold) AS total_units_sold,
    ROUND(SUM(s.total_sales), 2) AS total_sales,
    ROUND(SUM(s.operating_profit), 2) AS total_profit,
    ROUND((SUM(s.operating_profit) / SUM(s.total_sales)) * 100, 2) AS profit_margin_percentage,
    RANK() OVER (ORDER BY SUM(s.total_sales) DESC) AS sales_rank,
    RANK() OVER (ORDER BY SUM(s.operating_profit) DESC) AS profit_rank
FROM 
    sales s
JOIN 
    products p ON s.product_id = p.product_id
GROUP BY 
    p.product
ORDER BY 
    total_sales DESC;
    
    
-- Regional Performance Breakdown
-- Q 5: Which regions and states deliver the highest sales volume and profitability margins to prioritize expansion and marketing efforts?

-- A: Top Regions by Sales & Profitability 

SELECT 
    l.region,
    COUNT(DISTINCT l.city) AS cities_covered,
    SUM(s.total_sales) AS total_sales,
    SUM(s.operating_profit) AS total_profit,
    ROUND(SUM(s.operating_profit) / SUM(s.total_sales) * 100, 2) AS profit_margin,
    ROUND(SUM(s.total_sales) / COUNT(DISTINCT l.city), 2) AS sales_per_city,
    RANK() OVER (ORDER BY SUM(s.total_sales) DESC) AS sales_rank,
    RANK() OVER (ORDER BY SUM(s.operating_profit) / SUM(s.total_sales) DESC) AS margin_rank
FROM sales s
JOIN locations l ON s.location_id = l.location_id
GROUP BY l.region
ORDER BY total_sales DESC;

-- Top States by Sales & Profitability
SELECT 
    l.state,
    COUNT(DISTINCT l.city) AS cities_covered,
    SUM(s.total_sales) AS total_sales,
    SUM(s.operating_profit) AS total_profit,
    ROUND(SUM(s.operating_profit) / SUM(s.total_sales) * 100, 2) AS profit_margin,
    ROUND(SUM(s.total_sales) / COUNT(DISTINCT l.city), 2) AS sales_per_city,
    RANK() OVER (ORDER BY SUM(s.total_sales) DESC) AS sales_rank,
    RANK() OVER (ORDER BY SUM(s.operating_profit) / SUM(s.total_sales) DESC) AS margin_rank
FROM sales s
JOIN locations l ON s.location_id = l.location_id
GROUP BY l.state
ORDER BY total_sales DESC
LIMIT 10;


-- Q 6: Which retailers generate the highest sales volume and profit margins across product categories?
SELECT 
    r.retailer,
    SUM(s.total_sales) AS total_sales,
    SUM(s.units_sold) AS total_units_sold,
    ROUND(AVG(s.operating_margin) * 100, 2) AS avg_profit_margin_percentage,
    RANK() OVER (ORDER BY SUM(s.total_sales) DESC) AS sales_rank,
    RANK() OVER (ORDER BY AVG(s.operating_margin) DESC) AS margin_rank
FROM sales s
JOIN retailers r ON s.retailer_id = r.retailer_id
GROUP BY r.retailer
ORDER BY total_sales DESC;


-- Q 7: How do different sales channels compare in terms of sales volume, profitability margins, and average transaction size to optimize channel strategy?
SELECT 
    sales_method,
    COUNT(*) AS transaction_count,
    SUM(total_sales) AS total_sales,
    SUM(operating_profit) AS total_profit,
    ROUND((SUM(operating_profit) / SUM(total_sales)) * 100, 2) AS profit_margin_percentage,
    AVG(units_sold) AS avg_units_per_transaction,
    ROUND(AVG(total_sales), 2) AS avg_transaction_value,
    RANK() OVER (ORDER BY SUM(total_sales) DESC) AS sales_rank,
    RANK() OVER (ORDER BY (SUM(operating_profit) / SUM(total_sales)) DESC) AS margin_rank
FROM 
    sales
GROUP BY 
    sales_method
ORDER BY 
    total_sales DESC;









-- Q 7: How does the product mix differ across retailers, and which ones show potential for strategic partnerships?
SELECT 
    r.retailer,
    p.product,
    COUNT(*) AS product_sales_count,
    SUM(s.total_sales) AS total_sales,
    ROUND(AVG(s.operating_margin) * 100, 2) AS avg_profit_margin_percentage
FROM sales s
JOIN retailers r ON s.retailer_id = r.retailer_id
JOIN products p ON s.product_id = p.product_id
GROUP BY r.retailer, p.product
ORDER BY r.retailer, total_sales DESC;

-- Q8 : What are the low performing states and cities?

SELECT 
    l.region,
    l.state,
    l.city,
    ROUND(SUM(s.total_sales), 2) AS total_sales,
    SUM(s.units_sold) AS total_units_sold,
    ROUND(AVG(s.operating_margin) * 100, 2) AS avg_profit_margin_percentage
FROM 
    sales s
JOIN 
    locations l ON s.location_id = l.location_id
GROUP BY 
    l.region, l.state, l.city
ORDER BY 
    total_sales ASC
LIMIT 5;



