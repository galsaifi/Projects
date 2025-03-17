# Nebraska Client Awards & Consulting Area Analysis

## Overview
This project **analyzes and visualizes** the **client distribution, consultant areas, and awarded amounts** for businesses in Nebraska from **January 2023 to March 2024**. The analysis includes:
- **Client distribution by consulting area**.
- **Awarded contract amounts mapped by county**.
- **Top awarded industries by NAICS codes**.

---

## Data Sources
- **Uncleaned.xlsx** (Raw Client Data)
- **Awards (Jan 23 - March 24).xlsx** (Awarded Contracts Data)
- **Awarded Clients.xlsx** (List of Clients Receiving Awards)
- **county_boundaries.geojson** (Nebraska County Boundary Data)

---

## Workflow

### 1. **Client Distribution by Consultant Area**
- **Mapped client distribution across consulting areas:**
  - Omaha
  - Norfolk
  - Lincoln
  - Kearney
- **Color-coded Nebraska counties by consultant area**.
- **Labeled counties with client counts**.

### 2. **Awarded Contract Amounts by County**
- **Aggregated total contract amounts** per county.
- **Used log-transformed color gradients** to visualize awarded amounts.
- **Outlined consulting areas and labeled award values**.

### 3. **Top Industries by Awarded Amount**
- **Grouped awarded clients by NAICS codes**.
- **Ranked top 10 industries based on total awarded amounts**.
- **Formatted industry names and wrapped text for readability**.

---

## Key Findings
📍 **Omaha, Norfolk, and Lincoln have the highest client counts**.
💰 **Certain counties received significantly higher awarded amounts**.
🏭 **Industries like R&D, Manufacturing, and Tech received the most funding**.

---

## Technologies Used
- **R (`ggplot2`, `sf`, `tidyverse`, `readxl`, `scales`, `ggthemes`)**
- **Spatial Mapping (`ggplot2`, `sf`)**
- **Data Aggregation (`dplyr`)**
- **Excel Export (`writexl`)**

---

## How to Use
1. **Ensure all datasets (`.xlsx` and `.geojson`) are available**.
2. **Run the R script** to generate:
   - 🗺 **Client Distribution Map** (`Clients by Consultant.jpg`)
   - 📍 **Awards by County Map** (`Awards by County.jpg`)
   - 📊 **Top Awarded Industries Bar Plot** (`Client Awards by Industry.jpg`).
3. **Analyze trends & funding distribution**.

🚀 **This analysis helps identify geographic and industry trends in awarded contracts and consultant assignments. Let me know if refinements are needed!** 📍
