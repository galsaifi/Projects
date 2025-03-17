library(stringdist)
library(readxl)
library(dplyr)
library(data.table)
library(writexl)


dsbs <- read_excel("Self Certified SDB - DSBS.xlsx")
neoserra <- read_excel("Neoserra Clients.xlsx")

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
                      dsbs_name = character(),
                      stringsAsFactors = FALSE)

threshold <- 0.15

for (i in 1:nrow(non_id_clients)) {
  name1 <- non_id_clients$`Company Name`[i]
  min_distance <- Inf
  matched_name <- NA
  
  for (name2 in dsbs$`Name of Firm`) {
    distance <- stringdist::stringdistmatrix(name1, name2, method = "jw")
    
    if (distance < min_distance) {
      min_distance <- distance
      matched_name <- name2
    }
  }
  
  if (min_distance <= threshold) {
    matches <- rbind(matches, data.frame(Client_ID = non_id_clients$`Client ID`[i],
                                         `Company Name` = name1,
                                         `Unique Entity Identifier` = non_id_clients$`Unique Entity Identifier`[i],
                                         `Disadvantage Status` = non_id_clients$`Disadvantage Status`[i],
                                         `Primary Consultant` = non_id_clients$`Primary Consultants`[i],
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
  select(`Client ID`, `Company Name`, `Unique Entity Identifier`, `Disadvantage Status`, `Primary Consultants`)

# Combine the two
combined_certify <- bind_rows(disadvantaged, filtered_matches)

# Export the final data set
write_xlsx(combined_certify, "Final Self Certified SDB.xlsx")


# Find certified clients that shouldn't be certified 
# Clients that have a UEI
dont_certify <- uei_clients %>%
  filter(`Disadvantage Status` == "Self-certified Disadvantaged/Minority Owned" | 
           `Disadvantage Status` == "Certified SDB (Legacy)" | 
           `Disadvantage Status` == "DBE Certified" | 
           `Disadvantage Status` == "SBA 8(a) Certified")
neoserra_not_in_dsbs <- anti_join(dont_certify, dsbs, join_by(`Unique Entity Identifier` == UEI))

# Clients that do not have a UEI
non_id_clients_certified <- non_id_clients %>%
  filter(`Disadvantage Status` == "Self-certified Disadvantaged/Minority Owned" | 
           `Disadvantage Status` == "Certified SDB (Legacy)" | 
           `Disadvantage Status` == "DBE Certified" | 
           `Disadvantage Status` == "SBA 8(a) Certified")

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

write_xlsx(non_matches, "Not Self Certified SDB.xlsx")






