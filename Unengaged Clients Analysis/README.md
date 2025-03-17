# HubSpot & Neoserra Client Matching for Marketing Outreach

## Overview
This project automates **client email matching and filtering** between **HubSpot, Neoserra, and Contacts datasets**. It identifies:
- **Unsent emails** from HubSpot
- **Matching contacts in Neoserra and Contacts datasets**
- **Clients missing from marketing lists**
- **Consultant assignment for clients**
- **Reasons for unsent emails**

## Data Sources
- **HubSpot Unsent (`HubSpot Unsent.xlsx`)** - List of clients in HubSpot and their email sent status.
- **Neoserra (`neoserra.xlsx`)** - Contains detailed client records, including assigned consultants.
- **Contacts (`Contacts.xlsx`)** - Contains additional email records for businesses.

## Process

### 1. Data Cleaning & Standardization
- **Lowercases & trims whitespace** for all email fields.
- Filters **HubSpot** for **unsent emails** (`Sent == FALSE`).

### 2. Matching HubSpot Clients with Contact Records
- Joins **Contacts** dataset with **HubSpot Unsent** list.
- Filters only **valid matches** where **Hub ID is available**.
- Merges with **Neoserra** to enrich client information.

### 3. Assigning Consultant Areas
- Clients are assigned to **consultant areas** based on:
  - **State (Nebraska vs. Out-of-State)**
  - **County Location**
  - **Predefined Consultant Assignments**
- **Consultant Areas Include**:
  - **Omaha**
  - **Meghann Buresh**
  - **Quentin Farley**
  - **Charles (Chuck) Beck**
  - **Veronica Doga (Out-of-State)**
  - **Primary Consultants (if assigned in Neoserra)**

### 4. Matching HubSpot Clients with Neoserra Records
- Left joins **Neoserra** with **HubSpot Unsent** data.
- Filters **only clients with `Sent == FALSE`**.
- Assigns consultant areas based on **physical address county**.

### 5. Filtering Out Existing Clients
- Removes contacts already found in **Neoserra** from **consultant_contacts** dataset.

### 6. Identifying Missing Marketing Contacts
- Finds **HubSpot contacts missing from the Contacts dataset**.
- Finds **HubSpot contacts missing from Neoserra**.
- Removes duplicates to ensure accurate tracking.

### 7. Updating "Unsent Reason"
- Transforms **HubSpot email suppression reasons** into **readable categories**, including:
  - **Low Engagement Suppression**
  - **Unsubscribed via Portal**
  - **Non-Marketable Contact**
  - **Previously Marked as Spam**
  - **Quarantined Email Address**
  - **Ignored by Mail Transfer Agent (MTA)**

### 8. Exporting Final Datasets
📌 **Contacts Matched in HubSpot** → `Contacts HubSpot.xlsx`  
📌 **Clients Matched in Neoserra** → `Clients HubSpot.xlsx`  
📌 **Missing Contacts from HubSpot** → `Missing Contacts.xlsx`  
📌 **Missing Clients from HubSpot** → `Missing Clients.xlsx`  

---

## Technologies Used
- **R (dplyr, readxl, stringdist, stringr, writexl)**
- **Excel for dataset storage & exports**
- **SQL-style joins in R (`left_join`, `anti_join`)**
- **Data cleaning, transformation, and filtering using dplyr**

This project ensures **efficient marketing outreach** by properly **matching**, **categorizing**, and **segmenting clients** across multiple datasets. 🚀
