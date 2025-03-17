# MTB Registrants and Awarded Contracts Analysis

## Overview
This project analyzes **MTB registrants from Spring 2019 - Spring 2024** and their awarded contracts across different **industries and agencies**. The goal is to determine:
- The **industry distribution** of registrants
- **Total contract amounts awarded** to attendees
- **Agencies awarding contracts** to MTB participants
- **Breakdowns by set-aside types, NAICS codes, and business classifications**

## Data Sources
- **MTB Registrants**: (`MTB Registrants (Spring 19 - Spring 24).xlsx`)
- **Client Information**: (`All Clients.xlsx`)
- **Contract Awards Data**: (`All Client Awards by Agency.xlsx`)

---

## Workflow

### 1. Data Preparation
- **Merged** registrant data with **client profiles and contract awards**.
- **Standardized NAICS codes** to identify industries.
- **Mapped NAICS codes to broad industry categories**.

### 2. Industry Distribution Analysis
- **Categorized businesses by industry** based on NAICS codes.
- **Created an industry distribution pie chart** showing industry representation.
- **Grouped small industries (<3% representation) under "Others".**
- **Exported the final industry distribution table**.

### 3. Contract Awards Analysis
- **Merged registrants with their awarded contracts**.
- **Filtered out attendees with missing contract data**.
- **Summed total contracts and award amounts**.
- **Mapped agencies to categories (e.g., DoD, State Agencies, Commercial).**
- **Exported data to `Awarded Attendees.xlsx`.**

### 4. Visualization
- **Generated a pie chart** for MTB registrant industry distribution.
- **Created a horizontal bar chart** displaying contract awards by agency type.
- **Added contract amounts and total contract counts as annotations**.

---

## Key Findings
### 📌 **Industry Breakdown of MTB Registrants**
- **Most common industries**: Manufacturing, Professional Services, and Construction.
- **Top represented industries**: [Industry names based on the final pie chart].
- **Small industries (<3%) grouped under "Others".**

### 📌 **Total Awards Received by MTB Attendees**
- **Total Dollar Value**: **$2.23 Billion**
- **Total Contracts Awarded**: **39,858**

### 📌 **Top Awarding Agencies**
- **Department of Defense (DoD)**: Largest contributor to contract awards.
- **State Agencies**: Second largest in awarded contracts.
- **Other Federal Agencies**: Significant contributor.

---

## Technologies Used
- **Python (`pandas`, `pandasql`)**
- **SQL Queries (`pandasql.sqldf`)**
- **Data Visualization (`matplotlib`)**
- **Excel Processing (`pandas.read_excel`, `to_excel`)**
- **Industry Classification (NAICS mapping)**

---

## Output Files
| Filename | Description |
|----------|------------|
| `MTB Fall24 Industry Distribution.xlsx` | Industry distribution of MTB registrants |
| `MTB Fall24 Industry Distribution Pie Chart.png` | Pie chart of industry representation |
| `Awarded Attendees.xlsx` | Attendees who won contracts |
| `Attendees Contracts By Agency.png` | Bar chart of contract amounts by agency |

---

## How to Use
1. **Run the Python script** in `Jupyter Notebook` or as a standalone Python file.
2. **Ensure all Excel datasets** are placed inside the `Data/` folder.
3. **Check the `Deliverables/` folder** for final output reports and visualizations.

🚀 **This analysis provides a strategic view of MTB registrants' industry distribution and awarded contracts. Let me know if you need adjustments! 📊**
