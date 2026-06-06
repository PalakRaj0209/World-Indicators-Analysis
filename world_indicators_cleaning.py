"""
World Indicators - Data Cleaning Script
Author: Palak
Tools: Python (pandas, numpy)
Dataset: World Indicators (2704 rows, 28 columns)
Purpose: Clean raw data before SQL analysis and Tableau visualization
"""

import pandas as pd
import numpy as np

# ── 1. LOAD DATA ────────────────────────────────────────────────────────────
df = pd.read_excel("World_Indicators.xlsx")
print(f"✅ Data Loaded: {df.shape[0]} rows, {df.shape[1]} columns")

# ── 2. DROP UNNECESSARY COLUMNS ─────────────────────────────────────────────
# 'Number of Records' and 'Header' are metadata columns, not useful for analysis
df.drop(columns=['Number of Records', 'Header'], inplace=True)
print("✅ Dropped metadata columns: 'Number of Records', 'Header'")

# ── 3. FIX DATA TYPES ───────────────────────────────────────────────────────

# GDP: Remove '$' and ',' then convert to numeric
df['GDP'] = df['GDP'].astype(str).str.replace(r'[\$,]', '', regex=True)
df['GDP'] = pd.to_numeric(df['GDP'], errors='coerce')

# Health Exp/Capita: Remove '$' and ',' then convert to numeric
df['Health Exp/Capita'] = df['Health Exp/Capita'].astype(str).str.replace(r'[\$,]', '', regex=True)
df['Health Exp/Capita'] = pd.to_numeric(df['Health Exp/Capita'], errors='coerce')

# Tourism Inbound & Outbound: Remove '$' and ',' then convert to numeric
df['Tourism Inbound'] = df['Tourism Inbound'].astype(str).str.replace(r'[\$,]', '', regex=True)
df['Tourism Inbound'] = pd.to_numeric(df['Tourism Inbound'], errors='coerce')

df['Tourism Outbound'] = df['Tourism Outbound'].astype(str).str.replace(r'[\$,]', '', regex=True)
df['Tourism Outbound'] = pd.to_numeric(df['Tourism Outbound'], errors='coerce')

# Business Tax Rate: Remove '%' if present and convert to numeric
df['Business Tax Rate'] = df['Business Tax Rate'].astype(str).str.replace('%', '', regex=False)
df['Business Tax Rate'] = pd.to_numeric(df['Business Tax Rate'], errors='coerce')

# Year: Extract just the year as integer
df['Year'] = pd.to_datetime(df['Year'], errors='coerce').dt.year

print("✅ Fixed data types: GDP, Health Exp/Capita, Tourism, Business Tax Rate, Year")

# ── 4. HANDLE MISSING VALUES ─────────────────────────────────────────────────

# Strategy:
# - Columns with <15% nulls → fill with median (grouped by Region for better accuracy)
# - Columns with very high nulls (>50%) → fill with median overall (no regional split reliable)
# - Ease of Business has 93% nulls → drop column entirely

# Drop 'Ease of Business' — too many nulls to be useful
df.drop(columns=['Ease of Business'], inplace=True)
print("✅ Dropped 'Ease of Business' column (93% null values)")

# Columns to fill using Region-wise median
region_fill_cols = [
    'Birth Rate', 'CO2 Emissions', 'Energy Usage', 'GDP',
    'Health Exp % GDP', 'Health Exp/Capita', 'Infant Mortality Rate',
    'Internet Usage', 'Life Expectancy Female', 'Life Expectancy Male',
    'Mobile Phone Usage', 'Population 0-14', 'Population 15-64',
    'Population 65+', 'Population Urban', 'Tourism Inbound', 'Tourism Outbound'
]

for col in region_fill_cols:
    df[col] = df.groupby('Region')[col].transform(lambda x: x.fillna(x.median()))

# Columns with high nulls — fill with global median
high_null_cols = ['Business Tax Rate', 'Days to Start Business', 'Hours to do Tax', 'Lending Interest']

for col in high_null_cols:
    df[col] = df[col].fillna(df[col].median())

print("✅ Handled missing values using Region-wise median and global median")

# ── 5. ADD CALCULATED COLUMNS ────────────────────────────────────────────────

# GDP Per Capita
df['GDP Per Capita'] = df['GDP'] / df['Population Total']

# Tourism Balance (Inbound - Outbound) — positive means more tourists coming IN
df['Tourism Balance'] = df['Tourism Inbound'] - df['Tourism Outbound']

# Average Life Expectancy
df['Life Expectancy Avg'] = (df['Life Expectancy Female'] + df['Life Expectancy Male']) / 2

# GDP Category (for easier grouping in analysis)
df['GDP Category'] = pd.cut(
    df['GDP Per Capita'],
    bins=[0, 1000, 5000, 20000, float('inf')],
    labels=['Low Income', 'Lower Middle Income', 'Upper Middle Income', 'High Income']
)

print("✅ Added calculated columns: GDP Per Capita, Tourism Balance, Life Expectancy Avg, GDP Category")

# ── 6. REMOVE DUPLICATES ─────────────────────────────────────────────────────
before = len(df)
df.drop_duplicates(subset=['Country', 'Year'], inplace=True)
after = len(df)
print(f"✅ Removed duplicates: {before - after} duplicate rows dropped")

# ── 7. FINAL CHECK ───────────────────────────────────────────────────────────
print(f"\n📊 Final Dataset Shape: {df.shape[0]} rows, {df.shape[1]} columns")
print(f"📊 Remaining Null Values: {df.isnull().sum().sum()} total")
print(f"📊 Year Range: {df['Year'].min()} to {df['Year'].max()}")
print(f"📊 Countries: {df['Country'].nunique()}")
print(f"📊 Regions: {df['Region'].unique().tolist()}")

# ── 8. EXPORT CLEANED DATA ───────────────────────────────────────────────────
df.to_csv("world_indicators_cleaned.csv", index=False)
print("\n✅ Cleaned data exported to: world_indicators_cleaned.csv")
print("🎉 Data cleaning complete! Ready for SQL analysis.")
