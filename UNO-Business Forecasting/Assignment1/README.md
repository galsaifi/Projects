# Trip Demand Forecasting using OLS Regression

This project analyzes hourly trip demand and builds a **linear regression model** using **Ordinary Least Squares (OLS)** to predict trip counts based on temporal features.

## Features
- Loads and preprocesses hourly trip demand data.
- Splits data into **train** (`assignment_data_train.csv`) and **test** (`assignment_data_test.csv`).
- Builds an **OLS regression model** to predict trip counts.
- Evaluates model performance using regression summary statistics.

## Dataset
The dataset includes hourly trip demand records with the following columns:
- `Timestamp`: Date and time of recorded trips.
- `year`: Extracted year from the timestamp.
- `month`: Extracted month from the timestamp.
- `day`: Extracted day from the timestamp.
- `hour`: Extracted hour from the timestamp.
- `trips`: Number of trips recorded in that hour.

## Installation
To run this analysis, install the required Python libraries:

```bash
pip install pandas statsmodels
