library(tidyverse)
library(readxl)
library(sf)
library(ggmap)
library(writexl)


awards <- read_xlsx("Nebraska_SBIRdata.xlsx")
counties <- st_read("county_boundaries.geojson")

# Filter Nebraska Awards
awards <- awards %>%
  filter(!(City %in% c("New York", "Albuquerque", "Port Washington")))


# Google API Key
register_google(key = "AIzaSyC5GT0c6_xLRWpqCxcIXtZl5OYrr8odSlw")

# Function to create county, lon, and lat columns 
getGeom <- function(x){
  full_address <- paste(x["Address1"], x["City"], "Nebraska", x["Zip"], "United States", sep = ", ")
  full_address <- gsub(", ,", ",", full_address)
  
  geo <- tryCatch({
    geocode(full_address, output = "more")
  }, error = function(e) {
    return(NA)  
  })
  
  reverse_geo <- revgeocode(c(geo$lon, geo$lat), output = "all")
  
  specific_counties <- c("Scotts Bluff", "Box Butte", "Red Willow", "Keya Paha")
  pattern <- paste0("(", paste(specific_counties, collapse = "|"), "|\\w+) County")
  
  county <- str_extract(reverse_geo, pattern)
  county <- gsub(" County", "", county[2])
  
  result <- data.frame(county = county, lon = geo$lon, lat = geo$lat)
  
  return(result)
}

# Apply the functions 
awards <- cbind(awards, do.call(rbind, lapply(split(awards, seq(nrow(awards))), getGeom)))

# Grouping by the count of awards
countyAwards <- awards %>%
  group_by(county) %>%
  summarize(count = n(),
            lat = first(lat),
            lon = first(lon)) %>%
  arrange(desc(count))

# Group with the county data
mapData <- left_join(counties, countyAwards, by = c("NAME" = "county"))
mapData <- st_as_sf(mapData)
mapData$centroid <- st_centroid(mapData$geometry)

mapData$label_point <- st_centroid(mapData$geometry)
mapData$label_lon <- st_coordinates(mapData$label_point)[, 1]
mapData$label_lat <- st_coordinates(mapData$label_point)[, 2]

# Plotting the map
break_points <- c(5, 10, 20, 50, 100)
transformed_breaks <- break_points^(1/3) 

sbir <- ggplot() +
  geom_sf(data = mapData, fill = "#2c3e53", color = "black") +  
  geom_point(data = mapData, aes(x = lon, y = lat, size = count^(1/3)), color = "green4", alpha = 0.6) +  
  scale_size(
    range = c(5, 20), 
    name = "Award Count",
    breaks = transformed_breaks,  
    labels = break_points
  ) + 
  geom_text(data = mapData, aes(x = label_lon, y = label_lat, label = NAME), size = 3, check_overlap = TRUE, color = "white") + 
  labs(title = "Nebraska SBIR Award Counts by County") +  
  theme_void() +  
  theme(
    plot.title = element_text(hjust = 0.085, size = 20), 
    plot.subtitle = element_text(hjust = 0.08, size = 13),  
    plot.background = element_rect(fill = "lightgrey", color = NA),
    panel.background = element_rect(fill = "lightgrey", color = NA),
    legend.position = "bottom",
    plot.margin = unit(c(0.1, 0.1, 0.1, 0.1), "cm")
  )

sbir

# Export the map
#ggsave("SBIR Awards Map.png", plot = sbir, width = 11, height = 6, dpi = 300)

# Grouping the awards by agency
agencyAwards <- awards %>%
  group_by(Agency)%>%
  summarize(total = sum(`Award Amount`))%>%
  arrange(desc(total))

#write_xlsx(agencyAwards, "SBIR Awards by Agency.xlsx")

# Grouping awards by agency (total & count)
countySummury <- awards %>%
  group_by(county) %>%
  summarize(count = n(),
            total = sum(`Award Amount`)) %>%
  arrange(desc(count))

#write_xlsx(countySummury, "SBIR Awards by County.xlsx")




