library(dplyr)
library(tidyverse)
library(readxl)
library(sf)
library(scales)
library(writexl)
library(ggthemes)

dat <- read_xlsx("APEX Economic Impact (FY21 - FY23).xlsx")
county <- st_read("county_boundaries.geojson")

colnames(dat)
unique(dat$`Client/Pre-client Type`)

dat <- dat %>%
  mutate(`Physical Address County` = if_else(
    if_all(c("Mailing Address", "Mailing Address County", "Mailing City",
             "Mailing ZIP Code", "Physical Address", "Physical Address City"), is.na),
    "Wayne",
    `Physical Address County`
  ))


# Merging data
dat_num <- dat %>%
  filter(!is.na(`Physical Address County`)) %>%
  group_by(`Physical Address County`) %>%
  summarise(client_count = n())
  
merged <- left_join(county, dat_num, by = c("NAME" = "Physical Address County"))


# Plotting data
colors <- c("#c6d0df", "#9aaac7", "#305f99")
values <- c(0, 0.3, 0.5)

p <- ggplot(data = merged, aes(fill = client_count))+
  geom_sf(color = "white")+ 
  scale_fill_gradientn(
    colors = colors,
    values = rescale(values),   
    breaks = c(1, 779),
    na.value = "white",
    trans = "log10",
    guide = guide_colourbar(ticks = FALSE, direction = "horizontal")
  ) +
  geom_text(aes(label = client_count,
                x = st_coordinates(st_centroid(geometry))[, 1],
                y = st_coordinates(st_centroid(geometry))[, 2]), 
                color = ifelse(merged$client_count %in% c(1670), "black", "black"), size = 6.3,
            check_overlap = TRUE)+
  theme_void()+
  theme(
    legend.title = element_blank(),
    legend.position = c(0.91, 0.9),
    legend.box.margin = margin(0, 0, 0, 0),
    legend.margin = margin(-10, -10, -10, -10),  
    legend.key.height = unit(1.2, "cm"),
    legend.key.width = unit(1.5, "cm"),
    legend.text = element_text(size = 20, face = "bold"),
    panel.grid.major = element_blank(),
    axis.text = element_blank()
  )
p


# Export plot
#ggsave("APEX Economic Impact 21-23.png", p, width = 22, height = 10, units = "in", dpi = 1500)


# Pie chart data
naics_names <- c(
  "11" = "Agriculture",
  "21" = "Mining & Extraction",
  "22" = "Utilities",
  "23" = "Construction",
  "31" = "Manufacturing",
  "32" = "Manufacturing",
  "33" = "Manufacturing",
  "42" = "Wholesale",
  "44" = "Retail",
  "45" = "Retail",
  "48" = "Transport",
  "49" = "Transport",
  "51" = "Information",
  "52" = "Finance",
  "53" = "Real Estate",
  "54" = "Professional Services",
  "55" = "Management",
  "56" = "Admin & Waste Mgmt",
  "61" = "Education",
  "62" = "Health Care",
  "71" = "Arts & Recreation",
  "72" = "Accommodation & Food",
  "81" = "Other Services",
  "92" = "Public Admin",
  "00" = "Unknown"
)

colnames(dat)

pie <- dat %>%
  filter(`Initial Business Status` != "Pre-venture/Nascent") %>%
  mutate(NAICS = replace(`Primary NAICS`, is.na(`Primary NAICS`), "00"),
         industry_naics = substr(NAICS, start = 1, stop = 2)) %>%
  group_by(industry_naics) %>%
  summarise(client_count = n()) %>%
  arrange(desc(client_count)) 

pie <- pie %>%
  mutate(industry_name = case_when(
    industry_naics %in% names(naics_names) ~ naics_names[industry_naics],
    TRUE ~ "Other")) %>%
  group_by(industry_name) %>%
  summarise(client_count = sum(client_count)) %>%
  arrange(desc(client_count))

write_xlsx(pie, "APEX Pie Data.xlsx")


# Congressional District data
fed_district <- dat %>%
  group_by(`Federal Congressional District`) %>%
  summarise(count = n())

#write_xlsx(fed_district, "Federal Congressional Districts.xlsx")
