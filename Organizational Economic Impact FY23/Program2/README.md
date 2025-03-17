# NBDC Economic Impact Analysis (2021-2023)

## Overview
This project analyzes the **economic impact** of **NBDC (Nebraska Business Development Center)** clients and **APEX clients** across Nebraska from **2021 to 2023**. The analysis includes:
- **Client distribution by county** (spatial mapping)
- **Comparative visualization of NBDC and APEX clients**

---

## Data Sources
- **NBDC Economic Impact 2021-2023.xlsx** (NBDC Client Data)
- **APEX Economic Impact 21-23.xlsx** (APEX Client Data)
- **county_boundaries.geojson** (Geospatial county boundaries)

---

## Workflow

### 1. Data Preparation
- **Filtered data** for Nebraska-based clients.
- **Grouped clients by county** and calculated total counts.

### 2. Geographic Visualization
- **Mapped client counts** to county boundaries using `ggplot2` and `sf`.
- **Created two spatial visualizations**:
  1. **NBDC Clients (2021-2023)**
  2. **APEX Clients (2021-2023)**
- **Applied log-transformed color scaling** for better representation.

### 3. Exported Visualizations
- **Generated `NBDC Economic Impact 21-23.jpg`** (NBDC client distribution)
- **Generated `APEX Economic Impact 21-23.jpg`** (APEX client distribution)

---

## Key Findings
### 📌 **Client Distribution**
- **NBDC and APEX clients** are distributed **statewide**, with certain counties having significantly higher client counts.

### 📌 **Comparative Analysis**
- **NBDC clients** are more widespread.
- **APEX clients** may be concentrated in specific regions.

---

## Technologies Used
- **R (`dplyr`, `tidyverse`, `sf`, `ggplot2`, `scales`)**
- **Spatial Mapping (`ggplot2`, `sf`)**
- **Data Visualization (`ggplot2`, `scales`)**

---

## Output Files
| Filename | Description |
|----------|------------|
| `NBDC Economic Impact 21-23.jpg` | Geographic distribution of NBDC clients |
| `APEX Economic Impact 21-23.jpg` | Geographic distribution of APEX clients |

---

## How to Use
1. **Ensure all input files** are in the working directory.
2. **Run the R Markdown script** to generate and export visualizations.
3. **Check the `Deliverables/` folder** for the final outputs.

🚀 **This analysis provides insights into NBDC's and APEX's economic impact across Nebraska. Let me know if you need modifications! 📊**
