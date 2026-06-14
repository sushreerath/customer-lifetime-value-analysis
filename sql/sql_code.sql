use clv_analysis;
select * from customerdata;
-- Check Missing Values
SELECT COUNT(*) AS Total_Customers
FROM customerdata;
SELECT
SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Missing_Age,
SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Missing_Gender,
SUM(CASE WHEN Occupation IS NULL THEN 1 ELSE 0 END) AS Missing_Occupation,
SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS Missing_Sales
FROM customerdata;

-- Check Duplicate Customers
SELECT `Customer ID`,
COUNT(*) AS Duplicate_Count
FROM customerdata
GROUP BY `Customer ID`
HAVING COUNT(*) > 1;

-- Standardize Text Columns
UPDATE customerdata
SET Gender = TRIM(Gender);

UPDATE customerdata
SET Occupation = TRIM(Occupation);

UPDATE customerdata
SET `Marital Status` = TRIM(`Marital Status`);

-- Convert Purchase History to Date
ALTER TABLE customerdata
ADD Purchase_Date DATE;

UPDATE customerdata
SET Purchase_Date =
STR_TO_DATE(`Purchase History`, '%m/%d/%Y');

SELECT Purchase_Date
FROM customerdata
LIMIT 10;

-- Create Days Since Interaction
ALTER TABLE customerdata
ADD Days_Since_Interaction INT;

UPDATE customerdata
SET Days_Since_Interaction =
DATEDIFF(CURDATE(), Purchase_Date);

-- Create Age Group
ALTER TABLE customerdata
ADD Age_Group VARCHAR(20);

UPDATE customerdata
SET Age_Group =
CASE
    WHEN Age < 30 THEN '18-29'
    WHEN Age < 40 THEN '30-39'
    WHEN Age < 50 THEN '40-49'
    WHEN Age < 60 THEN '50-59'
    ELSE '60+'
END;

-- Create Income Group
ALTER TABLE customerdata
ADD Income_Group VARCHAR(20);

UPDATE customerdata
SET Income_Group =
CASE
    WHEN `Income Level` < 50000 THEN 'Low'
    WHEN `Income Level` < 100000 THEN 'Medium'
    ELSE 'High'
END;

-- Customer Distribution by Gender
SELECT Gender,
COUNT(*) AS Customers
FROM customerdata
GROUP BY Gender;

-- Age Group Distribution
SELECT Age_Group,
COUNT(*) AS Customers
FROM customerdata
GROUP BY Age_Group
ORDER BY Customers DESC;

-- Education Analysis
SELECT `Education Level`,
COUNT(*) AS Customers,
ROUND(AVG(Sales),2) AS Avg_Sales
FROM customerdata
GROUP BY `Education Level`
ORDER BY Avg_Sales DESC;

-- Occupation Analysis
SELECT Occupation,
COUNT(*) AS Customers,
ROUND(AVG(Sales),2) AS Avg_Sales,
ROUND(AVG(`Income Level`),2) AS Avg_Income
FROM customerdata
GROUP BY Occupation
ORDER BY Avg_Sales DESC;

-- Top States by Customers
SELECT `Geographic Information`,
COUNT(*) AS Customers
FROM customerdata
GROUP BY `Geographic Information`
ORDER BY Customers DESC
LIMIT 10;

-- Top States by Revenue
SELECT `Geographic Information`,
SUM(Sales) AS Revenue
FROM customerdata
GROUP BY `Geographic Information`
ORDER BY Revenue DESC
LIMIT 10;

-- Policy Analysis
SELECT `Policy Type`,
COUNT(*) AS Customers,
ROUND(AVG(Sales),2) AS Avg_Sales
FROM customerdata
GROUP BY `Policy Type`;

-- Rating Distribution
SELECT Rating,
COUNT(*) AS Customers
FROM customerdata
GROUP BY Rating
ORDER BY Rating;

-- Customer Service Channel Analysis
SELECT `Interactions with Customer Service`,
COUNT(*) AS Customers
FROM customerdata
GROUP BY `Interactions with Customer Service`
ORDER BY Customers DESC;

-- Executive KPI Query
SELECT
COUNT(*) AS Total_Customers,
SUM(Sales) AS Total_Revenue,
ROUND(AVG(Sales),2) AS Avg_Sales,
ROUND(AVG(`Income Level`),2) AS Avg_Income,
ROUND(AVG(Rating),2) AS Avg_Rating
FROM customerdata;

-- top 20 customers by sales
SELECT
    `Customer ID`,
    Occupation,
    Sales
FROM customerdata
ORDER BY Sales DESC
LIMIT 20;

-- Revenue by State
SELECT
    `Geographic Information`,
    SUM(Sales) AS Revenue
FROM customerdata
GROUP BY `Geographic Information`
ORDER BY Revenue DESC;

-- Average Income by Occupation
SELECT
    Occupation,
    ROUND(AVG(`Income Level`),2) AS Avg_Income
FROM customerdata
GROUP BY Occupation
ORDER BY Avg_Income DESC;

-- Best Performing Policy Type
SELECT
    `Policy Type`,
    COUNT(*) AS Customers,
    ROUND(AVG(Sales),2) AS Avg_Sales
FROM customerdata
GROUP BY `Policy Type`
ORDER BY Avg_Sales DESC;

-- Customer Rating Analysis
SELECT
    Rating,
    COUNT(*) AS Customers,
    ROUND(AVG(Sales),2) AS Avg_Sales
FROM customerdata
GROUP BY Rating
ORDER BY Rating;