# Self-Certified SDB Client Matching and Validation

This project automates the **matching of Neoserra clients** with **Self-Certified Small Disadvantaged Businesses (SDBs)** from the **Dynamic Small Business Search (DSBS)** dataset. It validates disadvantaged business status and flags potential certification errors.

## Features
- Loads **Neoserra** and **DSBS** datasets from Excel files.
- Preprocesses company names to **standardize formatting**.
- **Matches clients without UEIs** using **string similarity (Jaro-Winkler distance)**.
- **Joins clients with UEIs** directly with the DSBS dataset.
- Exports **Self-Certified SDB clients** to an Excel file.
- Identifies clients **incorrectly classified as Self-Certified SDBs**.

## Dataset
The project uses two datasets:
- **Neoserra Clients** (`Neoserra Clients.xlsx`): List of business clients.
- **DSBS Self-Certified SDB** (`Self Certified SDB - DSBS.xlsx`): List of self-certified disadvantaged businesses.

## Installation
To run this analysis, install the required R packages:

```r
install.packages(c("stringdist", "readxl", "dplyr", "data.table", "writexl"))
