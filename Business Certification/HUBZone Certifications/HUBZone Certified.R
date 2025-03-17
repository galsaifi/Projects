library(stringdist)
library(readxl)
library(dplyr)
library(data.table)
library(writexl)


dsbs <- read_excel("DSBS HUBZone.xlsx")
neoserra <- read_excel("Neoserra Clients.xlsx")

# Assigning APEX Consultants
desired_consultants <- c("Charles (Chuck) Beck", "Harold Sargus", "Patrick Guinotte", "Meghann Buresh", "Carlos Garzon",
                         "Quentin Farley")

neoserra <- neoserra %>%
  mutate(
    `Consultant Area` = case_when(
      (`Physical Address County` %in% c("DOUGLAS", "DODGE", "SAUNDERS", "WASHINGTON", "SARPY"))
      ~ "Omaha", 
      (`Physical Address County` %in% c("POLK", "PLATTE", "COLFAX", "BUTLER", "BOYD", "HOLT", "GARFIELD", "WHEELER",
                                        "VALLEY", "GREELEY", "KNOX", "CEDAR", "DIXON", "ANTELOPE", "PIERCE", "WAYNE",
                                        "DAKOTA", "THURSTON", "MADISON", "STANTON", "CUMING", "BURT", "BOONE", 
                                        "NANCE", "MERRICK", "BOONE1"))
      ~ "Norfolk", 
      (`Physical Address County` %in% c("YORK", "SEWARD", "CASS", "CLAY", "FILLMORE", "SALINE", "NUCKOLLS", 
                                        "THAYER", "GAGE", "JEFFERSON", "JOHNSON", "PAWNEE", "NEMAHA", "RICHARDSON", 
                                        "LANCASTER", "OTOE"))
      ~ "Lincoln",
      TRUE ~ "Kearney"
    ),
    `Primary Consultants` = case_when(
      `Primary Consultants` %in% desired_consultants ~ `Primary Consultants`,
      `Consultant Area` == "Omaha" ~ "Omaha",
      `Consultant Area` == "Norfolk" ~ "Meghann Buresh",
      `Consultant Area` == "Lincoln" ~ "Quentin Farley",
      `Consultant Area` == "Kearney" ~ "Charles (Chuck) Beck",
      TRUE ~ `Primary Consultants` 
    )
  )

non_id_clients <- neoserra %>%
  filter(is.na(`Unique Entity Identifier`))

preprocess_name <- function(name) {
  name <- tolower(name)
  name <- gsub("[[:punct:]]", "", name) 
  name <- gsub("[[:space:]]+", " ", name) 
  trimws(name)
}

neoserra$`Company Name` <- sapply(neoserra$`Company Name`, preprocess_name)
dsbs$`Name of Firm` <- sapply(dsbs$`Name of Firm`, preprocess_name)


# Matching clients without a UEI
non_id_clients <- neoserra %>%
  filter(is.na(`Unique Entity Identifier`))

matches <- data.frame(Client_ID = character(),
                      `Company Name` = character(),
                      `Unique Entity Identifier` = character(),
                      `Disadvantage Status` = character(),
                      `Primary Consultant` = character(),
                      `HUBZone Certification Date` = character(),
                      dsbs_name = character(),
                      stringsAsFactors = FALSE)

threshold <- 0.15

for (i in 1:nrow(non_id_clients)) {
  name1 <- non_id_clients$`Company Name`[i]
  min_distance <- Inf
  matched_name <- NA
  matched_exit_date <- NA   # Initialize the exit date for each client in non_id_clients
  
  # Loop through dsbs to find a match
  for (j in 1:nrow(dsbs)) {
    name2 <- dsbs$`Name of Firm`[j]
    distance <- stringdist::stringdistmatrix(name1, name2, method = "jw")
    
    if (distance < min_distance) {
      min_distance <- distance
      matched_name <- name2
      cert_date <- dsbs$`HUBZone Certification Date`[j]
      matched_exit_date <- dsbs$`HUBZone Exit Date`[j]  
      matched_uei <- dsbs$UEI[j]
    }
  }
  
  # If a match is found, add it to the matches dataframe
  if (min_distance <= threshold) {
    matches <- rbind(matches, data.frame(Client_ID = non_id_clients$`Client ID`[i],
                                         `Company Name` = name1,
                                         `Unique Entity Identifier` = matched_uei,
                                         `Disadvantage Status` = non_id_clients$`Disadvantage Status`[i],
                                         `Primary Consultant` = non_id_clients$`Primary Consultants`[i],
                                         `HUBZone Certification Date` = dsbs$`HUBZone Certification Date`[j],
                                         `Exit Date` = matched_exit_date,
                                         dsbs_name = matched_name)) 
  }
}

write_xlsx(matches, "Matches.xlsx") # export the matches data set and clean up manually

filtered_matches <- read_excel("Matches.xlsx")

colnames(filtered_matches) <- gsub("\\.", " ", colnames(matches))
colnames(filtered_matches)[colnames(filtered_matches) == "Client_ID"] <- "Client ID"

# Matching clients with UEIs
uei_clients <- neoserra %>%
  filter(!is.na(`Unique Entity Identifier`))

joined <- left_join(uei_clients, dsbs, join_by(`Unique Entity Identifier` == UEI), multiple = "all")

disadvantaged <- joined %>%
  filter(!is.na(`Name of Firm`)) %>%
  select(`Client ID`, `Company Name`, `Unique Entity Identifier`, `Disadvantage Status`, `Primary Consultants`,
          `HUBZone`, `HUBZone Certification Date.y`)

# Combine the two
combined_certify <- bind_rows(disadvantaged, filtered_matches)

# Export the final data set
write_xlsx(disadvantaged, "HUBZone Certified.xlsx")


# Find certified clients that shouldn't be certified 
# Clients that have a UEI
dont_certify <- uei_clients %>%
  filter(HUBZone == "Certified")
neoserra_not_in_dsbs <- anti_join(dont_certify, dsbs, join_by(`Unique Entity Identifier` == UEI))

# Clients that do not have a UEI
non_id_clients_certified <- non_id_clients %>%
  filter(HUBZone == "Certified")

no_match_id <- data.frame()

for (i in 1:nrow(non_id_clients_certified)) {
  name1 <- non_id_clients_certified$`Company Name`[i]
  has_match <- FALSE
  
  for (name2 in dsbs$`Name of Firm`) {
    distance <- stringdist::stringdistmatrix(name1, name2, method = "jw")
    
    if (distance <= threshold) {
      has_match <- TRUE
      break
    }
  }
  
  if (!has_match) {
    no_match_id <- rbind(no_match_id, non_id_clients_certified[i, ])
  }
}

non_matches <- bind_rows(no_match_id, neoserra_not_in_dsbs)

write_xlsx(non_matches, "Not HUBZone.xlsx")


      
      
      



