# Counseling Requests and GIB/DIB Readiness Analysis

## Overview
This project processes and analyzes **counseling request data**, **client follow-ups**, and **GIB/DIB readiness** using **Python and SQL queries**. The goal is to track **counseling requests over time**, identify **clients without follow-ups**, and determine the **GIB/DIB readiness** of clients.

## Data Sources
- **Counseling Data.xlsx** – Contains counseling session details.
- **Counseling Requests.xlsx** – Includes requests for counseling.
- **Client Data.xlsx** – Stores client information and their GIB/DIB readiness.

## Process

### 1. Load and Filter Data
- Reads data from Excel files using `pandas`.
- Filters counseling data for **specific APEX consultants**.
- Converts dates to **datetime format** and extracts **month names**.

### 2. Counseling Requests by Month
- Uses **SQL queries (pandasql)** to count **counseling requests per month**.
- Outputs a **summary table** showing the number of requests by month.

### 3. Identifying Clients Without Follow-up
- Joins **counseling requests** with **counseling session data**.
- Identifies clients that **haven't received a follow-up**.
- Outputs a **list of clients missing follow-ups** with contact details.

### 4. GIB/DIB Ready Clients
- Filters clients who are **Government Industrial Base (GIB) Ready** or **Defense Industrial Base (DIB) Ready**.
- Extracts **GIB/DIB readiness dates** and groups data **by month**.

### 5. Clients That Did Not Become GIB/DIB Ready
- Identifies clients that **started counseling** but **did not** become **GIB or DIB ready**.
- Filters clients based on **start date and readiness status**.
- Outputs a **list of non-ready clients**.

## Output Files
- **Monthly Requests by Month.xlsx** – Summary of counseling requests.
- **Clients Requests Without Follow-up.xlsx** – List of clients missing follow-ups.
- **GIB Ready Clients.xlsx** – Clients marked as GIB ready.
- **DIB Ready Clients.xlsx** – Clients marked as DIB ready.
- **Clients Not GIB or DIB Ready.xlsx** – Clients that did not reach readiness.

## Technologies Used
- **Python (pandas, pandasql)**
- **SQL queries (pandasql)**
- **Excel (openpyxl)**
- **Jupyter Notebook**
