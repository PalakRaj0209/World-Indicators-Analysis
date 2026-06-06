-- ============================================================
-- World Indicators - SQL Analysis
-- Author: Palak
-- Dataset: world_indicators_cleaned.csv
-- Tool: SQLite / any SQL engine
-- Purpose: Extract meaningful insights for Tableau dashboards
-- ============================================================

-- NOTE: Load the cleaned CSV into a table named 'world_indicators'
-- before running these queries.

-- ============================================================
-- QUERY 1: Top 10 Countries by Average GDP Per Capita
-- Insight: Which countries have the highest wealth per person?
-- ============================================================
SELECT
    Country,
    Region,
    ROUND(AVG("GDP Per Capita"), 2) AS Avg_GDP_Per_Capita
FROM world_indicators
GROUP BY Country, Region
ORDER BY Avg_GDP_Per_Capita DESC
LIMIT 10;


-- ============================================================
-- QUERY 2: Regional Health vs Life Expectancy Analysis
-- Insight: Does spending more on health lead to longer life?
-- ============================================================
SELECT
    Region,
    ROUND(AVG("Health Exp % GDP") * 100, 2)   AS Avg_Health_Exp_Pct_GDP,
    ROUND(AVG("Health Exp/Capita"), 2)          AS Avg_Health_Exp_Per_Capita,
    ROUND(AVG("Life Expectancy Avg"), 2)        AS Avg_Life_Expectancy,
    ROUND(AVG("Infant Mortality Rate") * 100, 2) AS Avg_Infant_Mortality_Rate
FROM world_indicators
GROUP BY Region
ORDER BY Avg_Life_Expectancy DESC;


-- ============================================================
-- QUERY 3: Internet and Mobile Phone Usage Growth Over Years
-- Insight: How has digital adoption grown globally?
-- ============================================================
SELECT
    Year,
    ROUND(AVG("Internet Usage") * 100, 2)      AS Avg_Internet_Usage_Pct,
    ROUND(AVG("Mobile Phone Usage") * 100, 2)  AS Avg_Mobile_Usage_Pct
FROM world_indicators
GROUP BY Year
ORDER BY Year ASC;


-- ============================================================
-- QUERY 4: Top 10 Countries with Highest Infant Mortality
-- Insight: Which countries need most healthcare intervention?
-- ============================================================
SELECT
    Country,
    Region,
    ROUND(AVG("Infant Mortality Rate") * 100, 2) AS Avg_Infant_Mortality_Rate
FROM world_indicators
GROUP BY Country, Region
ORDER BY Avg_Infant_Mortality_Rate DESC
LIMIT 10;


-- ============================================================
-- QUERY 5: Tourism Balance by Region
-- Insight: Which regions attract more tourists than they send out?
-- ============================================================
SELECT
    Region,
    ROUND(SUM("Tourism Inbound") / 1e9, 2)   AS Total_Tourism_Inbound_Billion,
    ROUND(SUM("Tourism Outbound") / 1e9, 2)  AS Total_Tourism_Outbound_Billion,
    ROUND(SUM("Tourism Balance") / 1e9, 2)   AS Net_Tourism_Balance_Billion
FROM world_indicators
GROUP BY Region
ORDER BY Net_Tourism_Balance_Billion DESC;


-- ============================================================
-- QUERY 6: GDP Category Distribution by Region
-- Insight: How are countries distributed across income groups?
-- ============================================================
SELECT
    Region,
    "GDP Category",
    COUNT(DISTINCT Country) AS Number_of_Countries
FROM world_indicators
WHERE "GDP Category" IS NOT NULL
GROUP BY Region, "GDP Category"
ORDER BY Region, "GDP Category";


-- ============================================================
-- QUERY 7: CO2 Emissions vs GDP — Are richer countries polluting more?
-- Insight: Relationship between economic growth and emissions
-- ============================================================
SELECT
    Country,
    Region,
    ROUND(AVG("GDP Per Capita"), 2)   AS Avg_GDP_Per_Capita,
    ROUND(AVG("CO2 Emissions"), 2)    AS Avg_CO2_Emissions,
    ROUND(AVG("Energy Usage"), 2)     AS Avg_Energy_Usage
FROM world_indicators
GROUP BY Country, Region
ORDER BY Avg_GDP_Per_Capita DESC
LIMIT 20;


-- ============================================================
-- QUERY 8: Population Demographics by Region
-- Insight: Which regions have a younger vs older population?
-- ============================================================
SELECT
    Region,
    ROUND(AVG("Population 0-14") * 100, 2)  AS Avg_Youth_Population_Pct,
    ROUND(AVG("Population 15-64") * 100, 2) AS Avg_Working_Age_Pct,
    ROUND(AVG("Population 65+") * 100, 2)   AS Avg_Elderly_Population_Pct,
    ROUND(AVG("Population Urban") * 100, 2) AS Avg_Urban_Population_Pct
FROM world_indicators
GROUP BY Region
ORDER BY Avg_Youth_Population_Pct DESC;


-- ============================================================
-- QUERY 9: Ease of Doing Business — Days & Tax Hours by Region
-- Insight: Which regions are most business-friendly?
-- ============================================================
SELECT
    Region,
    ROUND(AVG("Days to Start Business"), 1)  AS Avg_Days_to_Start_Business,
    ROUND(AVG("Hours to do Tax"), 1)         AS Avg_Hours_to_do_Tax,
    ROUND(AVG("Business Tax Rate"), 2)       AS Avg_Business_Tax_Rate_Pct
FROM world_indicators
GROUP BY Region
ORDER BY Avg_Days_to_Start_Business ASC;


-- ============================================================
-- QUERY 10: Year-wise Global Population & Birth Rate Trend
-- Insight: Is world population growth slowing down?
-- ============================================================
SELECT
    Year,
    ROUND(SUM("Population Total") / 1e9, 3)  AS Total_World_Population_Billion,
    ROUND(AVG("Birth Rate") * 1000, 2)        AS Avg_Birth_Rate_Per_1000
FROM world_indicators
GROUP BY Year
ORDER BY Year ASC;
