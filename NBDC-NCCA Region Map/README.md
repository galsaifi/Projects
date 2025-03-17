# Nebraska County Consulting and Community College Area Mapping

## Overview
This project creates a **geospatial visualization** of **Nebraska counties** categorized by:
- **Consulting areas** (Omaha, Lincoln, Norfolk, Kearney)
- **Nebraska Community College Areas (NCCA)**
- Overlay of **major city locations**

The visualizations help **identify consulting coverage and educational boundaries**, aiding **resource allocation and service planning**.

---

## Data Sources
- **Doubledd.geojson** (Nebraska county boundary data)
- **City coordinates** (Hardcoded within the script)

---

## Workflow

### 1. Data Preparation
- **County names converted to uppercase** for consistency.
- **Consultant Areas Assigned**:
  - **Omaha**, **Norfolk**, **Lincoln**, **Kearney**
- **Community College Boundaries Assigned**:
  - Northeast, Southeast, Western, Mid-Plains, and Central **Community College Areas**

### 2. Spatial Mapping
Two **geospatial visualizations** are generated:

#### 📌 **Consultant Area Map**
- **Each county is colored by its consulting area**.
- **Community college boundaries are outlined**.

#### 📌 **Community College Area Map**
- **Each county is colored by its assigned NCCA area**.
- **Consulting area boundaries are outlined**.

---

## Key Findings
- **Consulting areas and college regions do not always align**, suggesting the need for **collaborative efforts**.
- **Major cities (Omaha, Lincoln, Norfolk, Kearney) are labeled**, improving spatial understanding.

---

## Technologies Used
- **R (`ggplot2`, `sf`, `dplyr`, `ggthemes`)**
- **Geospatial Mapping (`ggplot2`, `sf`)**
- **Data Manipulation (`dplyr`)**
- **Custom Legends & Overlays (`ggplot2`, `geom_sf`, `geom_text`, `geom_point`)**

---

## How to Use
1. **Ensure `Doubledd.geojson` exists** in the working directory.
2. **Run the R script** to generate visualizations.
3. **Check the plotted maps** in the R output window.

🚀 **This visualization provides key insights into Nebraska's consulting and community college coverage. Let me know if refinements are needed!** 📍
