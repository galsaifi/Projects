# Veteran-Owned Business Certification Matching

## Overview
This project aims to match businesses from the **Neoserra Clients** dataset with the **DSBS Veteran-Owned** dataset to verify and certify veteran-owned businesses. It utilizes **string distance matching** to identify potential matches for businesses without a **Unique Entity Identifier (UEI)** and cross-references businesses that do have a UEI.

## Data Sources
- **DSBS Veteran-Owned.xlsx**: Contains a list of businesses with veteran-owned certifications.
- **Neoserra Clients.xlsx**: Contains client records from the Neoserra system.

## Process

### 1. Consultant Assignment
Neoserra clients are assigned to specific **APEX consultants** based on their county.

### 2. Preprocessing
- Business names are **standardized** by converting to lowercase and removing punctuation and extra spaces.

### 3. Matching Clients Without a UEI
- Uses **Jaro-Winkler string distance** to compare business names.
- If a match is found within a **0.15 threshold**, the following details are extracted:
  - Client ID
  - Company Name
  - Matched DSBS Name
  - Veteran Certification Details
  - Primary Consultant

### 4. Matching Clients With a UEI
- Businesses with a UEI are directly joined with the **DSBS dataset** to retrieve veteran certification details.

### 5. Combining Certified Matches
- Matches from both **UEI-based** and **string-distance-based** approaches are merged into a final certification list.

### 6. Identifying Incorrect Certifications
- Clients that **should not be certified** are flagged:
  - Businesses marked as "VOSB Certified" in Neoserra but **not found in DSBS**.
  - Non-UEI businesses that do not match any **DSBS firm**.

## Output Files
- **Matches.xlsx** – Businesses that were successfully matched.
- **Veteran Owned Certified.xlsx** – Final list of veteran-owned certified businesses.
- **Not Veteran Owned.xlsx** – Businesses flagged as incorrectly certified.
