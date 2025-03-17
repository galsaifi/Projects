# Business Contacts Analysis - East of Kearney Counties

## Overview
This project processes **business contact data** across multiple Nebraska counties, particularly focusing on firms **east of Kearney**. The analysis integrates business information, NAICS classifications, and geographic data to map and categorize firms in specific industries.

## Data Sources
- **Multiple Excel files (`Data/*.xlsx`)** – Contains firm details, NAICS codes, contact information, and location data.
- **County Boundaries GeoJSON (`county_boundaries.geojson`)** – Provides Nebraska county boundaries for mapping.

## Process

### 1. Load and Merge Data
- Reads **56 separate Excel files** and merges them into a single **DataFrame (`dat`)**.
- Ensures proper data types for:
  - **Congressional Districts**
  - **County Codes**
  - **Zip Codes**
  - **NAICS Codes**
- Removes duplicate records.

### 2. Data Cleaning & Preprocessing
- Selects **key columns** related to firm identification, contacts, and location.
- Drops firms with **missing email addresses** to focus on firms with contactable records.

### 3. Assigning County Names
- Creates a **county dictionary** mapping **county codes** to **county names**.
- Maps county names to the dataset for easier geographic analysis.

### 4. Mapping Business Locations
- Uses **GeoPandas** to merge firm data with **Nebraska county boundaries**.
- Visualizes businesses located **east of Kearney** using `matplotlib`:
  - **Grey background for all counties**
  - **Light blue highlight for selected counties**
  - **County labels added to the map**
- Saves the final map as:
  **"East of Kearney Counties.png"**

### 5. Standardizing Business Address Formats
- Concatenates **street, city, state, and zip code** into a single **address field**.

### 6. NAICS Code Handling
- Extracts the **Primary NAICS Code** if available.
- If missing, attempts to extract the first **six-digit NAICS code** from the **list of all small-business NAICS codes**.

### 7. Industry Classification
- Extracts the **first two digits** of the NAICS code to determine industry sector.
- Filters businesses to **specific industries**:
  - `23` – **Construction**
  - `52` – **Finance and Insurance**
  - `54` – **Professional, Scientific, and Technical Services**
  - `56` – **Administrative and Support, Waste Management, and Remediation Services**
  - `51` – **Information**
- Maps NAICS prefixes to industry names.

### 8. Querying Industry-Specific Data
- Uses `pandasql` to extract firms **only in selected industries** (`eastKearney` dataset).

### 9. Exporting Business Contact Data
- Saves the **final industry-filtered dataset** as:
  **"East of Kearney Business Contacts.xlsx"**

### 10. Extracting Email Lists for Outreach
- Groups **email addresses** into lists of **50 emails per batch**.
- Saves the final email lists as:
  **"Carlos Emailing List.xlsx"**

## Output Files
- **East of Kearney Counties.png** – Map visualization of selected counties.
- **East of Kearney Business Contacts.xlsx** – Firms filtered by industry and location.
- **Carlos Emailing List.xlsx** – Segmented email lists for business outreach.

## Technologies Used
- **Python (pandas, geopandas, matplotlib, pandasql)**
- **SQL (pandasql) for industry-specific querying**
- **GeoJSON for county boundary mapping**
- **Excel for data storage and output**

---
This project provides a structured **business contact dataset**, **mapped locations**, and **industry-based segmentation** to facilitate outreach and analysis of firms in the Nebraska region.
