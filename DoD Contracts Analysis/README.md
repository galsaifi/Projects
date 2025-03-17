# DoD Contracted Clients Analysis (Nov 2021 - Nov 2023)

## Overview
This project processes and analyzes **Department of Defense (DoD) contract data** alongside **client information** to identify clients who have received contracts, either by **matching their Unique Entity Identifier (UEI)** or by **fuzzy name matching**. The analysis categorizes contractors by consultant area and provides insights into contract values and award counts.

## Data Sources
- **Clients.xlsx** – Contains client details, contact information, and consultant assignments.
- **DOD Contracts FY22-24.csv** – Includes DoD contract details from **FY 2022 to FY 2024**.

## Process

### 1. Load and Filter Data
- Reads contract and client data using `pandas` and `data.table`.
- Selects **key contract fields** such as **contract amount, awarding agency, recipient details, and NAICS codes**.
- Converts recipient county names to **uppercase** for consistency.
- Assigns **Consultant Areas** based on county.

### 2. Identify Unique Contractors
- Groups contract data by **recipient name** to get **total dollars obligated**, **award count**, and other key details.
- Aggregates recipient details for each unique contractor.

### 3. Matching Clients by UEI
- Filters clients with a **Unique Entity Identifier (UEI)**.
- Performs a **left join** between **contracted companies** and **client data** based on UEI.
- Extracts key fields such as:
  - **Client ID**
  - **Company Name**
  - **Primary Consultants**
  - **GIB/DIB Readiness Dates**
  - **Total Awards Value**
  - **Award Count**
  - **Contact Information**

### 4. Matching Clients by Name (Fuzzy Matching)
- Filters clients **without a UEI**.
- Uses **Jaro-Winkler string similarity** (`stringdist::stringdist`) to compare company names.
- If similarity is **above 85%** (`≤0.15 distance`), assigns the contract record to the client.
- Assigns **Primary Consultant** based on available consultant information or the **consultant area**.
- Creates a **new dataset** with matched clients and contract details.

### 5. Exporting Final Matched Dataset
- Saves **matched clients (by UEI and name)** into an Excel file:  
  **"DoD Contracted Clients (November 2021 - November 2023).xlsx"**.

## Output Files
- **Matches.xlsx** – Initial fuzzy-matched contracts for manual review.
- **DoD Contracted Clients (November 2021 - November 2023).xlsx** – Final dataset with matched clients and contract details.

## Technologies Used
- **R (dplyr, data.table, stringr, writexl)**
- **Fuzzy Name Matching (Jaro-Winkler Distance)**
- **Excel for data output**
