# USAspending.gov Bulk Download Automation

## Overview
This project automates the **bulk downloading of federal contract awards data** from the [USAspending.gov API](https://api.usaspending.gov/). The script:
- **Requests bulk award data** for multiple fiscal years.
- **Filters data** by recipient types (HUBZone firms, Small Businesses).
- **Splits requests into monthly intervals** for more manageable downloads.
- **Implements retry logic** for failed API requests.
- **Generates download links** for requested data.

## Data Sources
- **USAspending API Endpoint**: `https://api.usaspending.gov/api/v2/bulk_download/awards/`
- **Filters Applied**:
  - **Prime Award Types**: A, B, C, D (All contract types)
  - **Date Type**: `action_date`
  - **Recipient Types**:
    - Historically Underutilized Business (HUBZone) Firm
    - Small Business
  - **Date Range**: Monthly intervals within each fiscal year
  - **File Format**: CSV

## Process

### 1. Defining Fiscal Years & Recipient Types
- The script fetches **five fiscal years (FY19–FY23)**:
  - **FY19 Partial**: Mar 1, 2019 – Sep 30, 2019
  - **FY20**: Oct 1, 2019 – Sep 30, 2020
  - **FY21**: Oct 1, 2020 – Sep 30, 2021
  - **FY22**: Oct 1, 2021 – Sep 30, 2022
  - **FY23**: Oct 1, 2022 – Sep 30, 2023
- It targets **HUBZone Firms** and **Small Businesses**.

### 2. Configuring API Requests
- The script:
  - **Splits data requests into monthly intervals**.
  - **Implements retry logic** (5 retries, exponential backoff) to handle failed requests.
  - **Uses a session-based approach** for improved performance.

### 3. Requesting Download URLs
- For each **monthly interval**, the script:
  - **Submits a request** to the API.
  - **Checks the response for a status URL**.
  - **Polls the status URL** until the download file is ready.

### 4. Handling Download Status
- The script continuously checks:
  - `"status": "finished"` → Fetches the **file download URL**.
  - `"status": "failed"` → Logs an **error message**.
  - `"status": "in progress"` → Waits **10 seconds** before retrying.

### 5. Storing Download Links
- The script:
  - **Generates a list of file URLs**.
  - Logs **failed attempts** for later debugging.
  - Prints **file URLs** for manual downloads.

---

## Technologies Used
- **Python (`requests`, `datetime`, `time`)**
- **USAspending.gov API**
- **HTTP Handling (`requests.adapters`, `urllib3.retry`)**
- **Exponential Backoff for Retries**
- **Polling Mechanism for Download Status**

## Output
- **Download Links** for each month stored in `download_links` list.
- **Error Messages** for failed requests.
- **Monthly Logs** indicating which data was successfully fetched.

This automation simplifies **bulk contract data retrieval** and ensures **resilient data fetching**. 🚀
