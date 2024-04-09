# This script is for assigning the hardiness zones to NPN records



# load packages
library(tidyverse)
library(sf)


# read data (downloaded from https://prism.oregonstate.edu/projects/plant_hardiness_zones.php)
# 2023 USDA Plant Hardiness Zone GIS Datasets
phm_us=st_read(dsn="C:/Users/xiey2/Documents/Data/shapefiles/phzm_us_zones_shp_2023/phzm_us_zones_shp_2023.shp")

phm_us=st_transform(phm_us, crs=4326)

# check data
unique(phm_us$zone)
unique(phm_us$trange)
unique(phm_us$zonetitle)

# fix invalid spatial features
#st_is_valid(phm_us)
phm_us=st_make_valid(phm_us)

# read data from NPN
df=read_csv("C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/elev_naFilled_combo_edited2.csv")

# convert data to sf object with WGS84 crs 
df_sf = st_as_sf(df, coords = c("longitude","latitude"), crs=4326)

# fix invalid spatial features
#st_is_valid(npn_sf)
df_sf=st_make_valid(df_sf)

# spatial join to assign hardiness zones then join back to original data frame
df_phm=st_join(df_sf, phm_us[,c(3:6)]) %>% st_set_geometry(NULL)
df=left_join(df, df_phm)

summary(df)

table(df$zone, useNA = "always")

df %>% filter(is.na(zone)) %>% view()

write_csv(df, file="C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/elev_naFilled_combo_edited2_phm.csv")
