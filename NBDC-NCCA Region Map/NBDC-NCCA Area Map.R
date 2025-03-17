library(ggplot2)
library(sf)
library(dplyr)
library(ggthemes)
library(ggpattern)
library(gridSVG)


counties <- st_read("Doubledd.geojson")

counties <- counties %>% rename(County = Cnty_Name)

counties$County <- toupper(counties$County)


counties <- counties %>%
  mutate(
    `Consultant Area` = case_when(
      (County == "DOUGLAS" | County == "DODGE" | County == "SAUNDERS" | County == "WASHINGTON" | County == "SARPY")
      ~ "Omaha", 
      (County == "POLK" | County == "PLATTE" | County == "COLFAX" | County == "BUTLER" | County == "BOYD" | County == "HOLT" | County == "GARFIELD" | County == "WHEELER" |
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

counties <- counties %>%
  mutate(
    borders = case_when(
      (County == "KEYA PAHA" | County == "BROWN" | County == "ROCK" | County == "BOYD" | County == "HOLT" | 
         County == "GARFIELD" | County == "WHEELER" | County == "KNOX" | County == "ANTELOPE" | County == "BOONE" |
         County == "PIERCE" | County == "MADISON" | County == "CEDAR" | County == "WAYNE" | County == "STANTON" |
         County == "CUMING" | County == "DIXON" | County == "DAKOTA" | County == "THURSTON" | County == "BURT") ~ "Northeast Community College",
      (County == "DODGE" | County == "WASHINGTON" | County == "DOUGLAS" | County == "SARPY") ~ "None",
      (County == "SAUNDERS" | County == "CASS" | County == "YORK" | County == "SEWARD" | County == "LANCASTER" |
          County == "OTOE" | County == "FILLMORE" | County == "SALINE" | County == "THAYER" | County == "JEFFERSON" |
          County == "GAGE" | County == "JOHNSON" | County == "NEMAHA" | County == "PAWNEE" | County == "RICHARDSON") ~ "Southeast Community College",
      (County == "SIOUX" | County == "DAWES" | County == "BOX BUTTE" | County == "GRANT" | County == "SHERIDAN" |
          County == "SCOTTS BLUFF" | County == "BANNER" | County == "KIMBALL" | County == "CHEYENNE" | County == "DEUEL" |
          County == "MORRILL" | County == "GARDEN" | County == "ARTHUR 1" | County == "CHERRY1") ~ "Western Nebraska Community College",
      (County == "CHERRY" | County == "HOOKER" | County == "THOMAS" | County == "BLAINE" | County == "LOUP" |
          County == "ARTHUR" | County == "MCPHERSON" | County == "LOGAN" | County == "CUSTER" | County == "KEITH" |
          County == "LINCOLN" | County == "PERKINS" | County == "CHASE" | County == "HAYES" | County == "FRONTIER" |
          County == "DUNDY" | County == "HITCHCOCK" | County == "RED WILLOW") ~ "Mid-Plains Community College",
      (County == "VALLEY" | County == "GREELEY" | County == "NANCE" | County == "PLATTE" | County == "COLFAX" | 
          County == "BUTLER" | County == "POLK" | County == "MERRICK" | County == "HOWARD" | County == "SHERMAN" |
          County == "DAWSON" | County == "BUFFALO" | County == "HALL" | County == "HAMILTON" | County == "GOSPER" | 
          County == "PHELPS" | County == "KEARNEY" | County == "ADAMS" | County == "CLAY" | County == "FURNAS" | 
          County == "HARLAN" | County == "FRANKLIN" | County == "WEBSTER" | County == "NUCKOLLS" | 
         County == "BOONE1") ~ "Central Community College"
    )
  )

  
city_data <- data.frame(
  name = c("Omaha", "Lincoln", "Norfolk", "Kearney"),
  lon = c(-96.010521, -96.699997, -97.416400, -99.096480), 
  lat = c(41.257771, 40.817638, 42.032470, 40.699900),
  vjust = c(-0.4, -0.4, -0.4, 1.3)
)

legend_fill_title <- "Consultant Area"
legend_color_title <- "NCCA College Area"


ggplot(data = counties) + 
  geom_sf(aes(fill = `Consultant Area`, color = borders), lwd = 1) +
  geom_sf_text(data = subset(counties, !(County %in% c("BOONE1", "CHERRY1"))),
               aes(label = County), size = 2, check_overlap = TRUE) +
  geom_point(data = city_data, aes(x = lon, y = lat), color = "red", size = 3) +
  geom_label(data = city_data, aes(x = lon, y = lat, label = name, vjust = vjust), 
             color = "white", fontface = "bold", fill = "black", size = 3) +
  ggtitle("Nebraska Counties by Consulting and Community College Area") + 
  theme_minimal()+
  theme(axis.text = element_blank(), 
        axis.ticks = element_blank(), 
        axis.title = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_blank(),
        legend.position = "right") +
  scale_fill_manual(values = c("Omaha" = "#EAE7E2",
                               "Norfolk" = "#D3D3D9",
                               "Lincoln" = "#B3BFD7",
                               "Kearney" = "#838DB1"),
                    name = legend_fill_title) +
  scale_color_manual(values = c("Northeast Community College" = "#FF0000",
                                "Southeast Community College" = "#0000FF",
                                "Western Nebraska Community College" = "#FF00FF",
                                "Mid-Plains Community College" = "#00FF00",
                                "Central Community College" = "purple"),
                     name = legend_color_title) +
  guides(color = guide_legend(override.aes = list(fill = NA)),
         fill = guide_legend(override.aes = list(color = NA)))


# Flipping the two categories counties and consultant area.
aggregated_counties <- counties %>%
  group_by(`Consultant Area`) %>%
  summarize(geometry = st_union(geometry), .groups = "drop")

ggplot() + 
  geom_sf(data = counties, aes(fill = borders)) + 
  geom_sf(data = aggregated_counties, aes(color = `Consultant Area`), fill = NA, lwd = 1.1) + 
  geom_sf_text(data = subset(counties, !(County %in% c("BOONE1", "CHERRY1"))),
               aes(label = County), size = 2, check_overlap = TRUE) +
  geom_point(data = city_data, aes(x = lon, y = lat), color = "red", size = 3) +
  geom_label(data = city_data, aes(x = lon, y = lat, label = name, vjust = vjust), 
             color = "white", fontface = "bold", fill = "black", size = 5) +
  ggtitle("Nebraska Counties by Community College and Consulting Area") + 
  theme_minimal() +
  theme(axis.text = element_blank(), 
        axis.ticks = element_blank(), 
        axis.title = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_blank(),
        legend.position = "right") +
  scale_color_manual(values = c("Omaha" = "#FF0000",
                                "Norfolk" = "#0000FF",
                                "Lincoln" = "#FF00FF",
                                "Kearney" = "#00FF00"),
                     name = "Consultant Area") +
  scale_fill_manual(values = c("Northeast Community College" = "#2874A6",
                               "Southeast Community College" = "#117A65",
                               "Western Nebraska Community College" = "#D68910",
                               "Mid-Plains Community College" = "#76448A",
                               "Central Community College" = "#B03A2E",
                               "None" = "#F0F0F0"),
                    name = "NCCA College Area") +
  guides(color = guide_legend(override.aes = list(fill = NA)),
         fill = guide_legend(override.aes = list(color = NA)))











  


