# Amazon Purchases Data Analysis

This project analyzes **Amazon purchase data** by merging transactional records with survey responses to extract insights about customer behavior, product sales, and regional trends.

## Features
- **Data Cleaning & Merging**: Combines Amazon purchases with survey data for a comprehensive dataset.
- **Exploratory Data Analysis (EDA)**: Identifies missing values, unique value counts, and descriptive statistics.
- **Sales Analysis**:
  - Total revenue by category
  - Average purchase amount per category
  - Monthly purchase trends
  - State-wise purchase distribution
- **Data Visualization**:
  - Heatmaps for correlation analysis
  - Bar charts for top-selling categories and states
  - Scatter plots for price vs. quantity relationships
  - Time series analysis for monthly sales trends

## Dataset
This project utilizes **two datasets**:
1. `amazon-purchases.csv` - Contains Amazon transaction details.
2. `survey.csv` - Contains survey responses linked via `Survey ResponseID`.

## Installation
To run this analysis, install the required Python libraries:

```bash
pip install pandas matplotlib seaborn
