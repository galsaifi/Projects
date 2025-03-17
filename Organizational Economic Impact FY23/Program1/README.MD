# APEX Economic Impact Analysis (FY21-FY23)

## Overview
This project analyzes **economic impact data** for APEX clients from **Fiscal Year 2021 to Fiscal Year 2023**, focusing on:
- **Client distribution by county** (mapped visualization)
- **Industry distribution** (NAICS-based classification)
- **Congressional district breakdown**

---

## Data Sources
- **APEX Economic Impact (FY21 - FY23).xlsx** (Main dataset)
- **county_boundaries.geojson** (Geospatial boundaries for counties)

---

## Workflow

### 1. Data Preparation
- **Ensured missing county values** were assigned to "Wayne."
- **Filtered** clients with valid physical county data.
- **Grouped clients by county** and calculated total counts.

### 2. Geographic Visualization (County-Level Client Distribution)
- **Merged client counts** with county boundaries (`GeoJSON`).
- **Generated a gradient-filled county map** using `ggplot2` and `sf`:
  - **Color scale**: Light blue to dark blue
  - **Log transformation** applied for better representation
  - **Client count labels overlaid** on the map
- **Exported as `APEX Economic Impact 21-23.png`**

### 3. Industry Breakdown (Pie Chart Data)
- **Mapped NAICS codes to industry names**.
- **Grouped clients by industry classification**.
- **Excluded "Pre-venture/Nascent" businesses**.
- **Created a summarized dataset for visualization**.
- **Exported as `APEX Pie Data.xlsx`**.

### 4. Congressional District Analysis
- **Grouped clients by Federal Congressional District**.
- **Calculated total clients per district**.
- **Exported as `Federal Congressional Districts.xlsx`**.

---

## Key Findings
### 📌 **Client Distribution by County**
- Clients are **concentrated in specific counties**.
- **Wayne County assigned** to missing locations.

### 📌 **Industry Breakdown**
- **Top industries**: [Insert top industries from pie chart]
- **Most common business sectors**: Manufacturing, Professional Services, Construction.

### 📌 **Congressional District Representation**
- **Client distribution by district** available in `Federal Congressional Districts.xlsx`.

---

## Technologies Used
- **R (`dplyr`, `tidyverse`, `sf`, `ggplot2`)**
- **Spatial Mapping (`ggplot2`, `sf`)**
- **Excel Export (`writexl`)**
- **Data Visualization (`ggplot2`, `scales`)**
- **Industry Classification (NAICS mapping)**

---

## Output Files
| Filename | Description |
|----------|------------|
| `APEX Economic Impact 21-23.png` | Geographic distribution of clients (county-level map) |
| `APEX Pie Data.xlsx` | Industry classification data for visualization |
| `Federal Congressional Districts.xlsx` | Congressional district client counts |

---

## How to Use
1. **Ensure all input files** are in the working directory.
2. **Run the R script** to generate and export reports.
3. **Check the `Deliverables/` folder** for final visualizations and datasets.

🚀 **This analysis provides a strategic view of APEX's client impact across counties, industries, and congressional districts. Let me know if you need modifications! 📊**
