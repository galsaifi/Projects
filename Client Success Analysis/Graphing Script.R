library(tidyverse)
library(readxl)
library(sf)
library(scales)
library(ggthemes)
library(writexl)


# Client count mapping by county and consultant area
clients <- read_xlsx("Uncleaned.xlsx")
counties <- read_sf("county_boundaries.geojson")

counties <- counties %>%
  select(
    OBJECTID, STATEFP, COUNTYFP, COUNTYNS, GEOID, NAME,
    NAMELSAD, LSAD, CLASSFP, MTFCC, CSAFP, CBSAFP, METDIVFP,
    FUNCSTAT, ALAND, AWATER, INTPTLAT, INTPTLON, COUNTY, 
    SUMLEV, GEOCODE, NAME_1, BASENAME, SDE_STATE_ID, Shape_Length, Shape_Area
  )

### Primary Consultant Cleaning
# apex <- c("Charles (Chuck) Beck", "Harold Sargus", "Meghann Buresh", "Patrick Guinotte", "Carlos Garzon", "Quentin Farley")
# clients$`Physical Address County` <- toupper(clients$`Physical Address County`)
# 
# uncleanedClients <- clients %>%
#   filter(`Physical Address State` != "Nebrasak")%>%
#   mutate(
#     consultant = case_when(
#       `Physical Address County` %in% c("DOUGLAS", "DODGE", "SAUNDERS", "WASHINGTON", "SARPY") ~ "Omaha",
#       `Physical Address County` %in% c("POLK", "PLATTE", "COLFAX", "BUTLER", "BOYD", "HOLT", "GARFIELD", "WHEELER",
#                      "VALLEY", "GREELEY", "KNOX", "CEDAR", "DIXON", "ANTELOPE", "PIERCE", "WAYNE",
#                      "DAKOTA", "THURSTON", "MADISON", "STANTON", "CUMING", "BURT", "BOONE", "NANCE", "MERRICK", "BOONE1") ~ "Norfolk",
#       `Physical Address County` %in% c("YORK", "SEWARD", "CASS", "CLAY", "FILLMORE", "SALINE", "NUCKOLLS", "THAYER",
#                      "GAGE", "JEFFERSON", "JOHNSON", "PAWNEE", "NEMAHA", "RICHARDSON", "LANCASTER", "OTOE") ~ "Lincoln",
#       TRUE ~ "Kearney"
#     )
#   )
# 
# write_xlsx(uncleanedClients, "Uncleaned.xlsx")

counties$NAME <- toupper(counties$NAME)

groupedClients <- clients %>%
  filter(!is.na("Physical Address County")) %>%
  group_by(`Physical Address County`) %>%
  summarise(clientCount = n())%>%
  arrange(desc(clientCount))

mapData <- left_join(counties, groupedClients, by = c("NAME" = "Physical Address County"))

mapData$nameCap <- toupper(mapData$NAME)

mapData <- mapData %>%
  mutate(
    consulting = case_when(
      nameCap == "DOUGLAS" | nameCap == "DODGE" | nameCap == "SAUNDERS" | nameCap == "WASHINGTON" | nameCap == "SARPY" ~ "Omaha", 
      nameCap %in% c("POLK", "PLATTE", "COLFAX", "BUTLER", "BOYD", "HOLT", "GARFIELD", "WHEELER",
                     "VALLEY", "GREELEY", "KNOX", "CEDAR", "DIXON", "ANTELOPE", "PIERCE", "WAYNE",
                     "DAKOTA", "THURSTON", "MADISON", "STANTON", "CUMING", "BURT", "BOONE", "NANCE", "MERRICK", "BOONE1") ~ "Norfolk", 
      nameCap %in% c("YORK", "SEWARD", "CASS", "CLAY", "FILLMORE", "SALINE", "NUCKOLLS", "THAYER",
                     "GAGE", "JEFFERSON", "JOHNSON", "PAWNEE", "NEMAHA", "RICHARDSON", "LANCASTER", "OTOE") ~ "Lincoln",
      TRUE ~ "Kearney"
    ),
    consultant = case_when(
      consulting == "Omaha" ~ "Omaha",
      consulting == "Norfolk" ~ "Meghann Buresh",
      consulting == "Lincoln" ~ "Quentin Farley",
      TRUE ~ "Charles (Chuck) Beck"
    )
  )

consultingCount <- mapData %>%
  group_by(consulting) %>%
  summarize(clients = sum(clientCount, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(label = paste(consulting, " (", clients, " clients)", sep = "")) %>%
  `$`('label')

consultantCount <- clients %>%
  group_by(`Primary Consultants`)%>%
  summarize(count = n())

mapData$geometry_centroid <- st_centroid(mapData$geometry)

map1 <- ggplot(mapData) +
  geom_sf(aes(fill = consulting), color = "white") + 
  geom_text(aes(
    x = st_coordinates(geometry_centroid)[, 1], 
    y = st_coordinates(geometry_centroid)[, 2], 
    label = clientCount, 
    color = "black"),
  size = 5.5, show.legend = FALSE) +
  scale_fill_manual(values = c("Omaha" = "#626A9D",
                               "Norfolk" = "#9D6288",
                               "Lincoln" = "#9D9562",
                               "Kearney" = "#629D77"),
                    name = "1793 Total Clients:",
                    labels = c("Kearney (400 clients)", "Lincoln (258 clients)", "Norfolk (410 clients)", 
                               "Omaha (725 clients)")) +
  scale_color_identity()+
  theme_void()+
  labs(
    title = "Reportalble/Non-Reportable Clients by Consulting Area (Jan 1, 2023 - Mar 31, 2024)"
  ) +
  theme(
    plot.title = element_text(size = 25, hjust = 0.33, vjust = 0.3, margin = margin(b = 5)),
    legend.position = "bottom",
    legend.title = element_text(size = 18, face = "bold"),
    legend.title.align = 0.5, 
    legend.text = element_text(size = 16),
    plot.margin = margin(r = 15, b = 20, t = 15, l = 15),
    legend.key.size = unit(1.5, 'lines'),
    legend.margin = margin(t = -10, b = -10),
    panel.border = element_blank(),
    plot.background = element_rect(fill = "beige", color = NA), 
    panel.background = element_rect(fill = "beige", color = NA)
  )+
  guides(fill = guide_legend(override.aes = list(size = 10)))

map1

#ggsave("Final Graphs/Clients by Consultant.jpg", plot = map1, width = 17, height = 8, dpi = 1000)

# Awards mapping by county
awards <- read_xlsx("Awards (Jan 23 - March 24).xlsx")
awardClients <- read_xlsx("Awarded Clients.xlsx")

neAwards <- left_join(awards, awardClients, by = "Client ID")
neAwards <- neAwards %>% filter(`Physical Address State` == "Nebraska")

totalAwards <- awards %>%
  group_by(`Client ID`) %>%
  summarize(total = sum(`Contract Amount`))
  
awarded <- left_join(awardClients, totalAwards, by = "Client ID")

groupedAwards <- awarded %>%
  filter(!is.na("Physical Address County") & `Physical Address State` == "Nebraska") %>%
  group_by(`Physical Address County`) %>%
  summarise(total = sum(total, na.rm = TRUE),
            numContracts = n())


groupedAwards$`Physical Address County` <- toupper(groupedAwards$`Physical Address County`)
mapData2 <- left_join(counties, groupedAwards, by = c("NAME" = "Physical Address County"))
mapData2$geometry_centroid <- st_centroid(mapData$geometry)

mapData2$total[mapData2$total == 0] <- NA

mapData2 <- mapData2 %>%
  mutate(
    consulting = case_when(
      NAME == "DOUGLAS" | NAME == "DODGE" | NAME == "SAUNDERS" | NAME == "WASHINGTON" | NAME == "SARPY" ~ "Omaha", 
      NAME %in% c("POLK", "PLATTE", "COLFAX", "BUTLER", "BOYD", "HOLT", "GARFIELD", "WHEELER",
                     "VALLEY", "GREELEY", "KNOX", "CEDAR", "DIXON", "ANTELOPE", "PIERCE", "WAYNE",
                     "DAKOTA", "THURSTON", "MADISON", "STANTON", "CUMING", "BURT", "BOONE", "NANCE", "MERRICK", "BOONE1") ~ "Norfolk", 
      NAME %in% c("YORK", "SEWARD", "CASS", "CLAY", "FILLMORE", "SALINE", "NUCKOLLS", "THAYER",
                     "GAGE", "JEFFERSON", "JOHNSON", "PAWNEE", "NEMAHA", "RICHARDSON", "LANCASTER", "OTOE") ~ "Lincoln",
      TRUE ~ "Kearney"
    ),
    consultant = case_when(
      consulting == "Omaha" ~ "Omaha",
      consulting == "Norfolk" ~ "Meghann Buresh",
      consulting == "Lincoln" ~ "Quentin Farley",
      TRUE ~ "Charles (Chuck) Beck"
    )
  )

color_palette <- colorRampPalette(c("#AED6F1", "#85C1E9", "#154360", "#10324B"))(100)

format_labels <- function(x) {
  sapply(x, function(n) {
    if(is.na(n)){
      return(NA)
    }
    if(n >= 1e6) {
      paste0("$", round(n / 1e6, 1), "M")
    } else {
      dollar(round(n, 0))
    }
  })
}

break_label <- function(x){
  paste(round(x / 1e6, 2), "M")
}

total_award_amounts <- sum(mapData2$total, na.rm = TRUE)
total_award_counts <- nrow(neAwards)

min_value <- min(mapData2$total, na.rm = TRUE)
max_value <- max(mapData2$total, na.rm = TRUE)

break_labels <- c(min(mapData2$total, na.rm = TRUE), break_label(max(mapData2$total, na.rm = TRUE)))

consulting_regions <- mapData2 %>%
  group_by(consulting) %>%
  summarize(
    geometry = st_union(geometry),
    total_sum = sum(total, na.rm = TRUE),
    .groups = 'drop'
  )

consulting_borders <- consulting_regions %>%
  st_boundary()

mapData2 <- mapData2 %>%
  mutate(centroid = st_centroid(geometry),
         centroid_x = st_coordinates(centroid)[, 1],
         centroid_y = st_coordinates(centroid)[, 2])

customer_legend <- c("Omaha" = paste0("Omaha ($", format(113762720, big.mark = ",", scientific = FALSE), ")"), 
                     "Norfolk" = paste0("Norfolk ($", format(118792397, big.mark = ",", scientific = FALSE), ")"), 
                     "Lincoln" = paste0("Lincoln ($", format(21286574, big.mark = ",", scientific = FALSE), ")"), 
                     "Kearney" = paste0("Kearney ($", format(45252779, big.mark = ",", scientific = FALSE), ")"))

map2 <- ggplot(mapData2) +
  geom_sf(aes(fill = total), color = "white") +
  scale_color_manual(values = c("#EAEDED", "#EAEDED","#EAEDED","#EAEDED"), name = "\n",
                     labels = customer_legend)+
  scale_fill_gradientn(colors = color_palette, 
                       na.value = "#cfd8dc", 
                       trans = "log10",
                       labels = c("", ""),
                       breaks = c(min_value, max_value)) +
  geom_sf(data = consulting_borders, aes(color = consulting), fill = NA, lwd = 2.5) +
  geom_text(aes(x = centroid_x, y = centroid_y, label = format_labels(total)),
            color = "white", size = 3, show.legend = FALSE) +
  theme_void() +
  labs(title = "Reportable/Non-Reportable Total Client Awards by County (Jan 1, 2023 - March 31, 2024)") +
  theme(plot.title = element_text(size = 20, hjust = 0.65, vjust = -0.2, margin = margin(b = 5), face = "bold"),
        legend.position = "bottom",
        legend.box = "vertical",
        legend.title = element_text(size = 10, face = "bold"),
        legend.title.align = 0.5, 
        legend.text = element_text(size = 12),
        plot.margin = margin(r = 15, b = 40, t = 15, l = 15),
        legend.key.size = unit(1.5, 'lines'),
        legend.margin = margin(t = 0, b = 0, l = 0, r = 0),
        legend.spacing.y = unit(0.4, 'cm'),
        legend.spacing.x = unit(0.5, 'cm'),
        panel.border = element_blank(),
        plot.background = element_rect(fill = "#EAEDED", color = NA), 
        panel.background = element_rect(fill = "#EAEDED", color = NA)) +
  guides(fill = guide_colorbar(title = paste("Total Award Amounts:", dollar(total_award_amounts), 
                                             "\nTotal Award Count:", total_award_counts), 
                               barheight = unit(1, "cm"), 
                               barwidth = unit(7, "cm"),
                               title.position = "left", 
                               title.hjust = 0.5,
                               title.vjust = 0.8,
                               label.hjust = 0.5))

map2

#ggsave("Final Graphs/Awards by County.jpg", plot = map2, width = 13, height = 8, dpi = 1000)

# Bar plot showing most awardedgeometry_centroid# Bar plot showing most awarded client NAICS codes
awardedNaics <- awarded %>%
  filter(`Physical Address State` == "Nebraska") %>%
  group_by(`Primary NAICS`) %>%
  summarise(total = sum(total, na.rm = TRUE)) %>%
  arrange(desc(total)) %>%
  top_n(10, total)

awardedNaics$`Primary NAICS`[4] <- "R & D in the Physical, Engineering, and Life Sciences (Except Biotechnology)"

get_industry <- function(x){
  paste(str_extract_all(x, "[A-Za-z]+|\\&|\\([^)]*\\)")[[1]], collapse = " ")
}

awardedNaics$industry <- sapply(awardedNaics$`Primary NAICS`, get_industry)

awardedNaics <- awardedNaics %>%
  mutate(industry_wrapped = str_wrap(industry, width = 5))

wrap_text <- function(x) {
  sapply(x, function(item) paste(strwrap(item, width = 30), collapse = "\n"))
}

x_labels <- function(x){
  ifelse(x != 0, paste(x / 1e6, "M"), "0")
}

industryPlot <- ggplot(awardedNaics, aes(x = total, y = reorder(industry, total)))+
  geom_bar(stat = "identity", fill = "#B2AC88")+
  geom_label(label = format_labels(awardedNaics$total), hjust = -0.15, size = 5)+
  scale_y_discrete(labels = wrap_text) +
  scale_x_continuous(limits = c(0, sum(awardedNaics$total, na.rm = TRUE) / 2), labels = x_labels)+
  labs(
    title = "Reportable/Non-Reportable Top Client Industries by Awarded Amount (Jan 1, 2023 - March 31, 2024)",
    x = "Total Award Amount", 
    y = "Industry"
  )+
  theme_economist_white()+
  theme(
    plot.margin = margin(l = 30, r = 100, t = 30, b = 30),
    plot.title = element_text(margin = margin(b = 40), face = "bold", size = 19, hjust = -0),
    axis.title.x = element_text(margin = margin(t = 30), size = 18),
    axis.title.y = element_text(margin = margin(r = 40), size = 18),
    axis.text.y = element_text(size = 13, margin = margin(r = 20, l = 10), hjust = 0)
  )

industryPlot
    
#ggsave("Final Graphs/Client Awards by Industry.jpg", plot = industryPlot, width = 18, height = 10, dpi = 1000)

























