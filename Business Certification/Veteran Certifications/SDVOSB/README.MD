# Service-Disabled Veteran-Owned Small Business (SDVOSB) Matching and Validation

This project automates the **matching of Neoserra clients** with **Service-Disabled Veteran-Owned Small Businesses (SDVOSBs)** from the **Dynamic Small Business Search (DSBS)** dataset. It validates veteran-owned business status and flags potential certification errors.

## Features
- Loads **Neoserra** and **DSBS SDVOSB** datasets from Excel files.
- Converts **certification and expiration dates** to date format for consistency.
- **Assigns APEX Consultants** based on business location.
- **Matches clients without UEIs** using **string similarity (Jaro-Winkler distance)**.
- **Joins clients with UEIs** directly with the DSBS dataset.
- Exports **certified SDVOSB clients** to an Excel file.
- Identifies clients **incorrectly classified as SDVOSBs**.

## Dataset
The project uses two datasets:
- **Neoserra Clients** (`Neoserra Clients.xlsx`): List of business clients.
- **DSBS SDVOSB** (`DSBS SDVOSB.xlsx`): List of SDVOSB-certified businesses.

## Installation
To run this analysis, install the required R packages:

```r
install.packages(c("stringdist", "readxl", "dplyr", "data.table", "writexl", "lubridate"))
