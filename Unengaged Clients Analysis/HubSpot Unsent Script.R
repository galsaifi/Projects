library(dplyr)
library(readxl)
library(stringdist)
library(stringr)
library(writexl)


hubspot <- read_excel("HubSpot Unsent.xlsx", sheet = "HubSpot")
neoserra <- read_excel("neoserra.xlsx")
contacts <- read_excel("Contacts.xlsx")

hubspot$Recipient <- trimws(tolower(hubspot$Recipient))
neoserra$Email <- trimws(tolower(neoserra$Email))
contacts$`Email Address` <- trimws(tolower(contacts$`Email Address`))

hubspot_unsent <- hubspot %>%
  filter(Sent == "FALSE") 
  

# Matching clients using contact records
contacts_hub <- left_join(contacts, hubspot_unsent, by = c("Email Address" = "Recipient"))

contacts_hub <- contacts_hub %>%
  filter(!is.na(`Hub ID`))

consultant_contacts <- left_join(contacts_hub, neoserra, by = c("Email Address" = "Email"), multiple = "all")

columns_to_keep <- c("Contact", "Email Address", "Work Phone Number", "Phone Number.x", "Sent", "Not Sent Reason", 
                     "Company Name.x", "Subscribe to emails?.x", "Business Type","Address", "County", "State", "Primary Consultants")

apex_consultants <- c("Charles (Chuck) Beck", "Patrick Guinotte", "Harold Sargus", "Meghann Buresh", "Veronica Doga",
                      "Quentin Farley")

consultant_contacts$County <- toupper(consultant_contacts$County)

consultant_contacts <- consultant_contacts %>%
  select(all_of(columns_to_keep)) %>%
  mutate(
    `Consultant Area` = case_when(
      State != "Nebraska" ~ "Veronica Doga",
      !(`Primary Consultants` %in% apex_consultants) & County %in% c("DOUGLAS", "DODGE", "SAUNDERS", "WASHINGTON", "SARPY") ~ "Omaha",
      !(`Primary Consultants` %in% apex_consultants) & County %in% c("POLK", "PLATTE", "COLFAX", "BUTLER", "BOYD", "HOLT", "GARFIELD", "WHEELER", 
                                                                     "VALLEY", "GREELEY", "KNOX", "CEDAR", "DIXON", "ANTELOPE", "PIERCE", "WAYNE", 
                                                                     "DAKOTA", "THURSTON", "MADISON", "STANTON", "CUMING", "BURT", "BOONE", "NANCE", 
                                                                     "MERRICK", "BOONE1") ~ "Meghann Buresh",
      !(`Primary Consultants` %in% apex_consultants) & County %in% c("YORK", "SEWARD", "CASS", "CLAY", "FILLMORE", "SALINE", "NUCKOLLS", "THAYER", 
                                                                     "GAGE", "JEFFERSON", "JOHNSON", "PAWNEE", "NEMAHA", "RICHARDSON", "LANCASTER", 
                                                                     "OTOE") ~ "Quentin Farley",
      !(`Primary Consultants` %in% apex_consultants) ~ "Charles (Chuck) Beck",
      TRUE ~ `Primary Consultants`
    )
  )

# Matching using client records
neoserra_hub <- left_join(neoserra, hubspot_unsent, by = c("Email" = "Recipient"))

columns_to_keep <- c("Company Name", "Primary Contact", "Email", "Phone", "Sent", "Not Sent Reason", "Company Status",
                     "Last Counseling","Physical Address", "Primary Consultants", "Physical Address County", "Physical Address State",
                     "Subscribe to emails?")


neoserra_hub$`Physical Address County` <- toupper(neoserra_hub$`Physical Address County`)

neoserra_hub <- neoserra_hub %>%
  select(all_of(columns_to_keep)) %>%
  filter(!is.na(Sent) & Sent == "FALSE") %>%
  rename(County = `Physical Address County`) %>%
  mutate(
    `Consultant Area` = case_when(
      `Physical Address State` != "Nebraska" ~ "Veronica Doga",
      !(`Primary Consultants` %in% apex_consultants) & County %in% c("DOUGLAS", "DODGE", "SAUNDERS", "WASHINGTON", "SARPY") ~ "Omaha",
      !(`Primary Consultants` %in% apex_consultants) & County %in% c("POLK", "PLATTE", "COLFAX", "BUTLER", "BOYD", "HOLT", "GARFIELD", "WHEELER", 
                                                                     "VALLEY", "GREELEY", "KNOX", "CEDAR", "DIXON", "ANTELOPE", "PIERCE", "WAYNE", 
                                                                     "DAKOTA", "THURSTON", "MADISON", "STANTON", "CUMING", "BURT", "BOONE", "NANCE", 
                                                                     "MERRICK", "BOONE1") ~ "Meghann Buresh",
      !(`Primary Consultants` %in% apex_consultants) & County %in% c("YORK", "SEWARD", "CASS", "CLAY", "FILLMORE", "SALINE", "NUCKOLLS", "THAYER", 
                                                                     "GAGE", "JEFFERSON", "JOHNSON", "PAWNEE", "NEMAHA", "RICHARDSON", "LANCASTER", 
                                                                     "OTOE") ~ "Quentin Farley",
      !(`Primary Consultants` %in% apex_consultants) ~ "Charles (Chuck) Beck",
      TRUE ~ `Primary Consultants`
    )
  )



# Removing clients that are already in our contacts list
consultant_contacts <- anti_join(consultant_contacts, neoserra_hub, by = c("Email Address" = "Email"))


# Getting marketing contacts that are not in Neoserra
hub_contact_missing <- anti_join(hubspot, contacts, by = c("Recipient" = "Email Address"))
hub_client_missing <- anti_join(hubspot, neoserra, by = c("Recipient" = "Email"))

hub_client_missing <- anti_join(hub_client_missing, hub_contact_missing, by = "Recipient")

# Changing unsent reason
consultant_contacts <- consultant_contacts %>%
  mutate(
    `Unsent Reason` = case_when(
      `Not Sent Reason` == "GRAYMAIL_SUPPRESSED" ~ "Low Engagement Suppression",
      `Not Sent Reason` == "PREVIOUSLY_UNSUBSCRIBED_PORTAL" ~ "Unsubscribed via Portal",
      `Not Sent Reason` == "NON_MARKETABLE_CONTACT" ~ "Non-Marketable Contact",
      `Not Sent Reason` == "PREVIOUSLY_UNSUBSCRIBED_MESSAGE" ~ "Unsubscribed from Message",
      `Not Sent Reason` == "MTA_IGNORE" ~ "Ignored by Mail Transfer Agent",
      `Not Sent Reason` == "QUARANTINED_ADDRESS" ~ "Quarantined Email Address",
      `Not Sent Reason` == "PREVIOUS_SPAM" ~ "Previously Marked as Spam",
      TRUE ~ `Not Sent Reason`  
    )
  ) %>%
  select(c("Contact", "Email Address", "Work Phone Number", "Phone Number.x", "Company Name.x", "Unsent Reason",
           "Subscribe to emails?.x", "Primary Consultants", "Consultant Area"))


neoserra_hub <- neoserra_hub %>%
  mutate(
    `Unsent Reason` = case_when(
      `Not Sent Reason` == "GRAYMAIL_SUPPRESSED" ~ "Low Engagement Suppression",
      `Not Sent Reason` == "PREVIOUSLY_UNSUBSCRIBED_PORTAL" ~ "Unsubscribed via Portal",
      `Not Sent Reason` == "NON_MARKETABLE_CONTACT" ~ "Non-Marketable Contact",
      `Not Sent Reason` == "PREVIOUSLY_UNSUBSCRIBED_MESSAGE" ~ "Unsubscribed from Message",
      `Not Sent Reason` == "MTA_IGNORE" ~ "Ignored by Mail Transfer Agent",
      `Not Sent Reason` == "QUARANTINED_ADDRESS" ~ "Quarantined Email Address",
      `Not Sent Reason` == "PREVIOUS_SPAM" ~ "Previously Marked as Spam",
      TRUE ~ `Not Sent Reason`  
    )
  ) %>%
  select(c("Primary Contact", "Email", "Phone", "Company Name", "Subscribe to emails?", "Consultant Area", "Unsent Reason"))

hub_contact_missing <- hub_contact_missing %>%
  mutate(
    `Unsent Reason` = case_when(
      `Not Sent Reason` == "GRAYMAIL_SUPPRESSED" ~ "Low Engagement Suppression",
      `Not Sent Reason` == "PREVIOUSLY_UNSUBSCRIBED_PORTAL" ~ "Unsubscribed via Portal",
      `Not Sent Reason` == "NON_MARKETABLE_CONTACT" ~ "Non-Marketable Contact",
      `Not Sent Reason` == "PREVIOUSLY_UNSUBSCRIBED_MESSAGE" ~ "Unsubscribed from Message",
      `Not Sent Reason` == "MTA_IGNORE" ~ "Ignored by Mail Transfer Agent",
      `Not Sent Reason` == "QUARANTINED_ADDRESS" ~ "Quarantined Email Address",
      `Not Sent Reason` == "PREVIOUS_SPAM" ~ "Previously Marked as Spam",
      TRUE ~ `Not Sent Reason`  
    )
  )
  
hub_client_missing <- hub_client_missing %>%
  mutate(
    `Unsent Reason` = case_when(
      `Not Sent Reason` == "GRAYMAIL_SUPPRESSED" ~ "Low Engagement Suppression",
      `Not Sent Reason` == "PREVIOUSLY_UNSUBSCRIBED_PORTAL" ~ "Unsubscribed via Portal",
      `Not Sent Reason` == "NON_MARKETABLE_CONTACT" ~ "Non-Marketable Contact",
      `Not Sent Reason` == "PREVIOUSLY_UNSUBSCRIBED_MESSAGE" ~ "Unsubscribed from Message",
      `Not Sent Reason` == "MTA_IGNORE" ~ "Ignored by Mail Transfer Agent",
      `Not Sent Reason` == "QUARANTINED_ADDRESS" ~ "Quarantined Email Address",
      `Not Sent Reason` == "PREVIOUS_SPAM" ~ "Previously Marked as Spam",
      TRUE ~ `Not Sent Reason`  
    )
  )
  
  
# Export data sets
write_xlsx(consultant_contacts, "Contacts HubSpot.xlsx")
write_xlsx(neoserra_hub, "Clients HubSpot.xlsx")
write_xlsx(hub_contact_missing, "Missing Contacts.xlsx")
write_xlsx(hub_client_missing, "Missing Clients.xlsx")


