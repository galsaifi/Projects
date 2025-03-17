library(dplyr)
library(data.table)
library(readxl)
library(stringr)
library(writexl)



clients <- read_excel("Clients.xlsx")
contracts <- fread("DOD Contracts FY22-24.csv")

contracts_to_keep <- c("contract_award_unique_key", "total_outlayed_amount_for_overall_award", "federal_action_obligation","action_date", 
                       "period_of_performance_current_end_date", "awarding_agency_name", "awarding_office_name", "total_dollars_obligated",
                       "funding_agency_name", "funding_office_name", "recipient_uei", "recipient_name", "recipient_city_name", 
                       "recipient_county_name", "recipient_state_name", "primary_place_of_performance_city_name", 
                       "primary_place_of_performance_state_name", "award_or_idv_flag", "award_type", "product_or_service_code", 
                       "product_or_service_code_description", "naics_code", "naics_description", "type_of_set_aside","local_area_set_aside")

contracts$recipient_county_name <- toupper(contracts$recipient_county_name)
contracts <- contracts %>%
  select(all_of(contracts_to_keep)) %>% 
  rename(County = recipient_county_name) %>%
  mutate(
    `Consultant Area` = case_when(
      (County == "DOUGLAS" | County == "DODGE" | County == "SAUNDERS" | County == "WASHINGTON" | County == "SARPY")
      ~ "Omaha", 
      (County == "POLK" | County == "PLATTE" | County == "COLFAX" | County == "BUTLER" | County == "BOYD" | County == "HOLT" | 
         County == "GARFIELD" | County == "WHEELER" |
         County == "VALLEY" | County == "GREELEY" | County == "KNOX" | County == "CEDAR" |
         County == "DIXON" | County == "ANTELOPE" | County == "PIERCE" | County == "WAYNE" |
         County == "DAKOTA" | County == "THURSTON" | County == "MADISON" | County == "STANTON" |
         County == "CUMING" | County == "BURT" | County == "BOONE" | County == "NANCE" | County == "MERRICK" |
         County == "BOONE1") ~ "Norfolk", 
      (County == "YORK" | County == "SEWARD" | County == "CASS" | County == "CLAY" | 
         County == "FILLMORE" | County == "SALINE" | County == "NUCKOLLS" | County == "THAYER" |
         County == "GAGE" | County == "JEFFERSON" | County == "JOHNSON" | County == "PAWNEE" |
         County == "NEMAHA" | County == "RICHARDSON" | County == "LANCASTER" | County == "OTOE") ~ "Lincoln",
      TRUE ~ "Kearney"
    )
  )

# Getting unique contractors
unique_contractors <- contracts %>% 
  group_by(recipient_name) %>%
  summarise(
    total_dollars_obligated = sum(total_dollars_obligated, na.rm = TRUE),
    `Award Count` = n(),
    awarding_agency_name = first(awarding_agency_name),
    awarding_office_name = first(awarding_office_name),
    recipient_uei = first(recipient_uei),
    recipient_city_name = first(recipient_city_name),
    County = first(County),
    recipient_state_name = first(recipient_state_name),
    `Consultant Area` = first(`Consultant Area`),
    .groups = 'drop'
  )


# matching clients by UEI
uei_clients <- clients %>%
  filter(!is.na(`Unique Entity Identifier`))

uei_matches <- left_join(unique_contractors, uei_clients, by = c("recipient_uei" = "Unique Entity Identifier"))

columns <- c(
  "Client ID", "Phone", "Email", "Company Name",
  "Physical Address", "Primary Consultants", "recipient_uei",
  "Primary Contact", "DIB Ready Date", "GIB Ready Date", "Last Counseling",
  "total_dollars_obligated", "Award Count", "Consultant Area"
)


uei_matches <- uei_matches %>% select(all_of(columns))

# Matching clients by name
non_uei_clients <- clients %>%
  filter(is.na(`Unique Entity Identifier`))

matched_non_uei <- data.frame(
  `Client ID` = character(),
  `Company Name` = character(),
  `Contract Name` = character(),
  `Unique Entity Identifier` = character(),
  `Awards Count` = character(),
  `Total Awards Value` = character(),
  `Primary Contact` = character(),
  Email = character(),
  Phone = character(), 
  `GIB Ready Date` = character(),
  `DIB Ready Date` = character(), 
  `Last Counseling` = character(),
  Address = character(),
  `Primary Consultant` = character()
)

for (i in 1:nrow(unique_contractors)) {
  nameContracts <- unique_contractors$recipient_name[i]
  
  for (j in 1:nrow(non_uei_clients)) {
    nameClient <- non_uei_clients$`Company Name`[j]
    distance <- stringdist::stringdist(nameClient, nameContracts, method = "jw")
    
    if (distance <= 0.15) {
      primary_consultant_field <- ifelse(!is.na(non_uei_clients$`Primary Consultants`[j]), 
                                         non_uei_clients$`Primary Consultants`[j], 
                                         unique_contractors$`Consultant Area`[j])
      
      matched_row <- data.frame(
        `Client ID` = non_uei_clients$`Client ID`[j], 
        `Company Name` = non_uei_clients$`Company Name`[j],
        `Contract Name` = unique_contractors$recipient_name[i],
        `Unique Entity Identifier` = non_uei_clients$`Unique Entity Identifier`[j],
        `Awards Count` = unique_contractors$`Award Count`[i],
        `Total Awards Value` = unique_contractors$total_dollars_obligated[i],
        `Primary Contact` = non_uei_clients$`Primary Contact`[j],
        Email = non_uei_clients$Email[j],
        Phone = non_uei_clients$Phone[j], 
        `GIB Ready Date` = non_uei_clients$`GIB Ready Date`[j],
        `DIB Ready Date` = non_uei_clients$`DIB Ready Date`[j], 
        `Last Counseling` = non_uei_clients$`Last Counseling`[j],
        Address = non_uei_clients$`Physical Address`[j],
        `Primary Consultant` = primary_consultant_field
      )
      matched_non_uei <- rbind(matched_non_uei, matched_row)
    }
  }
}

write_xlsx(matched_non_uei, "Matches.xlsx")
filtere_matches <- read_excel("Matches.xlsx")

columns <- colnames(filtere_matches)
columns <- gsub('\\.', " ", columns)
colnames(filtere_matches) <- columns

matches <- rbind(matched_uei, filtere_matches)

write_xlsx(matches, "DoD Contracted Clients (November 2021 - November 2023).xlsx")

