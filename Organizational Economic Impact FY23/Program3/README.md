# SBDC Economic Impact Analysis (2021-2023)

## Overview
This project analyzes the **economic impact of Small Business Development Center (SBDC) clients** across Nebraska from **2021 to 2023**. The analysis includes:
- **Client distribution by county** (spatial mapping)
- **Industry classification of businesses**
- **Congressional district breakdown**

---

## Data Sources
- **SBDC Economic Impact 21-23.xlsx** (SBDC Client Data)
- **county_boundaries.geojson** (Geospatial county boundaries)

---

## Workflow

### 1. Data Preparation
- **Address Handling**:
  - If all address fields are missing, **default county is set to Wayne**.
- **Client Grouping**:
  - Clients are **grouped by county**.
  - Missing values are handled appropriately.

### 2. Geographic Visualization
- **Mapped client counts** to county boundaries using `ggplot2` and `sf`.
- **Applied log-transformed color scaling** for better representation.

### 3. Industry Classification
- **NAICS Codes** mapped to industry categories:
  - Example categories: **Agriculture, Mining, Construction, Manufacturing, Retail, Transportation, etc.**
- **Businesses grouped by industry**, and **top industries identified**.

### 4. Congressional District Analysis
- **Client count breakdown by congressional district**.

---

## Key Findings
### 📌 **Client Distribution**
- **SBDC clients** are spread across Nebraska.
- Certain counties have significantly higher client counts.

### 📌 **Industry Breakdown**
- **Manufacturing, Retail, and Professional Services** are among the top industries.
- Clients span a diverse range of **NAICS classifications**.

### 📌 **Congressional District Representation**
- Clients are analyzed based on their **federal congressional district**.

---

## Technologies Used
- **R (`dplyr`, `tidyverse`, `sf`, `ggplot2`, `scales`, `writexl`)**
- **Spatial Mapping (`ggplot2`, `sf`)**
- **Data Visualization (`ggplot2`, `scales`)**
- **Excel Export (`writexl`)**

---

## Output Files
| Filename | Description |
|----------|------------|
| `SBDC Economic Impact 21-23.jpg` | Geographic distribution of SBDC clients |
| `SBDC Pie Data.xlsx` | Industry classification data for SBDC clients |
| `Federal Congressional Districts.xlsx` | Breakdown of SBDC clients by congressional district |

---

## How to Use
1. **Ensure all input files** are in the working directory.
2. **Run the R script** to generate and export visualizations.
3. **Check the `Deliverables/` folder** for the final outputs.

🚀 **This analysis provides insights into SBDC's economic impact across Nebraska. Let me know if you need refinements! 📊**
