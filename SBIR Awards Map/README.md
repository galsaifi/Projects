# Nebraska SBIR Awards Analysis

## Overview
This project **analyzes and visualizes** the **Small Business Innovation Research (SBIR) awards** in Nebraska. It includes:
- **Geocoding business addresses** to assign counties.
- **Mapping award distribution across Nebraska counties**.
- **Summarizing award counts and total funding by county and agency**.

---

## Data Sources
- **Nebraska_SBIRdata.xlsx** (SBIR Award Data)
- **county_boundaries.geojson** (Nebraska County Boundary Data)
- **Google Maps API** (Geocoding Business Addresses)

---

## Workflow

### 1. Data Cleaning
- **Removed non-Nebraska cities** (e.g., "New York", "Albuquerque").
- **Standardized county names**.

### 2. Geolocation & County Mapping
- Used **Google Geocoding API** to obtain:
  - **Longitude & Latitude** for each business.
  - **County names via Reverse Geocoding**.

### 3. Mapping SBIR Awards by County
- **Visualized award distribution using `ggplot2` and `sf`**.
- **Color-coded counties** and plotted award counts as **bubble sizes**.
- **Used cube root transformation** to balance award size visualization.

### 4. Data Summarization
- **Grouped awards by agency** to calculate **total funding**.
- **Summarized awards by county** with:
  - **Total awards count**.
  - **Total award amount**.

---

## Key Findings
📍 **SBIR Awards are concentrated in specific counties**.
📊 **Agency funding varies significantly**, with some agencies funding more than others.

---

## Technologies Used
- **R (`ggplot2`, `sf`, `ggmap`, `tidyverse`, `readxl`)**
- **Google Maps API** for geocoding & reverse geocoding
- **Spatial Mapping (`ggplot2`, `sf`)**
- **Data Aggregation (`dplyr`)**
- **Excel Export (`writexl`)**

---

## How to Use
1. **Ensure API access to Google Geocoding API**.
2. **Run the R script** to generate:
   - 📍 **SBIR Award Map** (`SBIR Awards Map.png`)
   - 📊 **Agency & County Award Reports** (`SBIR Awards by Agency.xlsx`, `SBIR Awards by County.xlsx`).
3. **Analyze trends & funding patterns**.

🚀 **This analysis helps identify geographic trends in SBIR funding for Nebraska. Let me know if refinements are needed!** 📍
