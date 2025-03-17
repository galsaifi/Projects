# HUBZone Client Matching and Certification Validation

This project automates the **matching of Neoserra clients** with **HUBZone-certified firms** from the **Dynamic Small Business Search (DSBS)** dataset. It assigns consultants, identifies HUBZone certifications, and flags potential certification errors.

## Features
- Loads **Neoserra** and **DSBS** datasets from Excel files.
- **Assigns consultants** based on geographical regions.
- Preprocesses company names to **standardize formatting**.
- **Matches clients without UEIs** using **string distance similarity**.
- **Joins clients with UEIs** directly with the DSBS dataset.
- Exports **HUBZone-certified** clients to an Excel file.
- Identifies clients **incorrectly classified as HUBZone-certified**.

## Dataset
The project uses two datasets:
- **Neoserra Clients** (`Neoserra Clients.xlsx`): List of clients with consultant assignments.
- **DSBS HUBZone** (`DSBS HUBZone.xlsx`): List of HUBZone-certified businesses.

## Installation
To run this analysis, install the required R packages:

```r
install.packages(c("stringdist", "readxl", "dplyr", "data.table", "writexl"))
