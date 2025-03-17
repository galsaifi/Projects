# Nebraska Federal Contracts Analysis (FY22 & FY23)

## Overview
This project analyzes **federal contract spending in Nebraska** for **Fiscal Years 2022 and 2023** using data from **USASpending.gov**. The analysis covers:
- **Total spending by county**
- **Year-over-year comparisons (FY22 vs. FY23)**
- **Top awarded industries**
- **Spending by socio-economic status**
- **Business size classifications**
- **Geospatial visualizations of contract awards**

## Data Sources
- **Nebraska FY22 Contracts (`Nebraska FY22 Contracts.csv`)**
- **Nebraska FY23 Contracts (`Nebraska FY23 Contracts.csv`)**
- **Nebraska County Boundaries (`county_boundaries.geojson`)**
- **Place of Performance Contracts (`Nebraska FY23 POP Contracts.csv`)**
- **Women-Owned Small Business Map (`WOSB Map.csv`)**

## Process

### 1. Data Loading & Preprocessing
- Reads **federal contract data** for **FY22 and FY23**.
- Cleans and standardizes **county names**.
- Ensures **missing values are replaced** with `0` for financial calculations.
- Uses **SQL queries (via pandasql)** to **aggregate** spending and contract counts.

### 2. Total Federal Spending by County (FY23)
- **Summarizes** contract obligations by **county**.
- Merges with **county boundary data** for mapping.
- **Visualizes** total obligations using **color-coded maps** with a **logarithmic scale**.

**Output:**  
📌 `Total Obligated by County.png`

### 3. Year-over-Year Comparison (FY22 vs. FY23)
- Compares **contract obligations per county** for both fiscal years.
- **Highlights differences** in awarded dollars across counties.
- Uses **color-coded maps** to **identify increases and decreases**.

**Output:**  
📌 `Difference in Total Dollars Awarded (FY23 - FY22).png`

### 4. Top Awarded NAICS Codes (FY23)
- **Ranks the top 10 industries** receiving federal contracts.
- Uses **horizontal bar charts** with percentage labels.

**Output:**  
📌 `NAICS Codes by Awarded Amounts.xlsx`  
📌 `Top Industries by Dollars Awarded (FY23).png`

### 5. Socio-Economic Status Analysis
- Categorizes contracts into **Minority-Owned, Women-Owned, Veteran-Owned, and HUBZone businesses**.
- **Compares total spending** per category.
- **Visualizes** the distribution of federal contract obligations.

**Outputs:**  
📌 `Socio-Economic Status by Total Spending.png`  
📌 `Socio-Economic Status by Total Spending (FY22 vs. FY23).png`

### 6. Business Size Analysis
- **Breaks down** contract awards by **Small Business vs. Other Than Small Business**.
- Analyzes **contracts awarded by business size**.
- **Pie charts & bar charts** show award proportions.

**Outputs:**  
📌 `Distribution of Contracts by Business Size.png`  
📌 `Distribution of Businesses by Contracts.png`  
📌 `Difference in Contracts by Business Size (FY23 vs. FY22).png`

### 7. Certified vs. Non-Certified Small Businesses
- Categorizes **small businesses** into **certified (minority, women, veteran, HUBZone) vs. non-certified**.
- **Compares** the proportion of each category.
- **Year-over-year comparison (FY22 vs. FY23).**

**Outputs:**  
📌 `Certified vs Non-Certified Small Businesses (FY23).png`  
📌 `Certified vs Non-Certified Small Businesses (FY23 vs. FY22).png`

### 8. Women-Owned Businesses Mapping (FY23)
- **Maps locations** of **women-owned businesses** receiving federal contracts.
- Differentiates by **small vs. large business** status.

**Output:**  
📌 `Women Owned Business Location by Size (FY23).png`

### 9. Total Obligated Dollars by State (FY23)
- Aggregates **federal contract obligations by state**.
- **Visualizes spending with geospatial mapping.**

**Output:**  
📌 `Total Federal Action Obligations by State FY23.png`

### 10. Top Industries by Place of Performance (FY23)
- Identifies **industries with the highest spending** based on contract locations.
- **Compares** industry spending with **bar charts**.

**Output:**  
📌 `Top Industries by Dollars Obligated.png`

---

## Technologies Used
- **Python (pandas, geopandas, matplotlib, pandasql)**
- **SQL (pandasql) for contract data analysis**
- **GeoJSON for mapping federal spending by county**
- **Excel for storing output datasets**

This project provides insights into **federal contract awards** in Nebraska, highlighting **key industries, business demographics, and geographic distribution of funding**. 🚀
