# Government Contracting Analysis: HUBZone & Small Business Set-Asides

## Overview
This project **analyzes federal contract awards** from **2019–2023** using **NAICS codes**, **set-aside types**, and **socio-economic business classifications** to identify trends in government contracting. It leverages **Pandas, SQLite (pandasql), and USAspending.gov data** to extract insights on:
- **HUBZone & Small Business awards** (nationally & regionally)
- **Top NAICS industries receiving contracts**
- **Businesses in Dodge County registered in SAM with contracts**
- **Federal agencies awarding HUBZone & Small Business contracts**
- **DSBS (Dynamic Small Business Search) business profiles**

## Data Sources
- **USAspending.gov**: Federal contract awards data (`FY19-FY23`)
- **SAM.gov & DSBS**: Business registration data
- **Local Government Data**: Fremont & Dodge County business profiles
- **NAICS Codes**: Industry classifications for contract awards

---

## Workflow

### 1. Data Preparation
- **Read contract datasets** (`2019-2023`).
- **Combine datasets** and remove **Veteran Set-Aside contracts**.
- **Standardize NAICS codes** and **fill missing values**.
- **Categorize Set-Asides** into:
  - HUBZone
  - Small Business
  - Other

### 2. NAICS-Based Analysis
- **Top 10 NAICS codes** by **total awarded amount** for HUBZone firms.
- **Set-aside contracts by industry** for **Fremont businesses**.
- **Comparison of HUBZone vs. Small Business contracts** by NAICS.

### 3. Dodge County Business Analysis
- **Identify businesses in Dodge County** that:
  - Are registered in **SAM**.
  - Have **won at least one federal contract**.
- **Extract business profiles from DSBS** (Dynamic Small Business Search).

### 4. Agency-Level Analysis
- **Top 10 federal agencies** awarding:
  - HUBZone contracts (National & Regional)
  - Small Business contracts (National & Regional)
- **Breakdown by socio-economic status**.

### 5. Data Processing Logic
- **SQL Queries (`pandasql`)** for:
  - Grouping contracts by **NAICS & awarding agency**.
  - Summing **total obligations** and **contract counts**.
  - Filtering contracts by **geographic location** (Nebraska, Iowa, Kansas, Missouri).
- **Mapping NAICS codes to industries** for clear reporting.

---

## Key Findings
### 📌 **Top 10 NAICS Codes for HUBZone Awards (2019-2023)**
- Manufacturing, Construction, and Professional Services lead in awarded contracts.

### 📌 **Dodge County Business Contracts**
- Identified **top-awarded businesses** registered in SAM.
- Compiled **contact information & contract details**.

### 📌 **Top Federal Agencies Awarding HUBZone & Small Business Contracts**
- **Nationally**: Department of Defense, Veterans Affairs, Homeland Security.
- **Regionally**: Department of Agriculture, General Services Administration.

---

## Technologies Used
- **Python (`pandas`, `pandasql`)**
- **SQL Queries (`pandasql.sqldf`)**
- **Excel File Processing (`pandas.read_excel`)**
- **Data Cleaning & Mapping (NAICS industry categorization)**

---

## Output Files
| Filename | Description |
|----------|------------|
| `HUBZone Awards by NAICS.xlsx` | Top 10 HUBZone NAICS codes (2019-2023) |
| `Dodge County Contracts.xlsx` | Contracts awarded to businesses in Dodge County |
| `National HUBZone Agencies.xlsx` | Top agencies awarding HUBZone contracts (National) |
| `Regional HUBZone Agencies.xlsx` | Top agencies awarding HUBZone contracts (Regional) |
| `Small Business Agencies.xlsx` | Top agencies awarding Small Business contracts |
| `Fremont HUBZone Contracts.xlsx` | HUBZone contracts for Fremont businesses |
| `Fremont Small Business Contracts.xlsx` | Small Business contracts for Fremont businesses |
| `DSBS Dodge Business Profiles.xlsx` | Businesses listed in DSBS for Dodge County |

---

## How to Use
1. **Run the Python scripts** in `Jupyter Notebook` or as standalone Python files.
2. **Ensure all CSV datasets** are placed inside the `Data/` folder.
3. **Check `Deliverables/` folder** for output Excel reports.

🚀 **This project enables targeted business development efforts for HUBZone and Small Business contractors.** Let me know if you need adjustments! 📊
