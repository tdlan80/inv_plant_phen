# This script is for assigning EPA ecoregion to NPN dataset



# load packages
library(tidyverse)
library(sf)
library(foreach)

# add ecoregion -----------------------------------------
ecoregion3=st_read(dsn="C:/Users/xiey2/Documents/Data/shapefiles/ecoregions/NA_CEC_Eco_Level3/NA_CEC_Eco_Level3.shp")

ecor=st_transform(ecoregion3, crs=4326)

# fix invalid spatial features
#st_is_valid(ecor)
ecor=st_make_valid(ecor)

# process NPN data separated by year
year=2009:2021

for (i in year)
{
  # read NPN data
  npn=read_csv(file=paste0("C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN", i, ".csv", sep=""))
  
  # convert both data to WGS84 crs 
  npn_sf = st_as_sf(npn, coords = c("longitude","latitude"), crs=4326)
  
  # fix invalid spatial features
  #st_is_valid(npn_sf)
  npn_sf=st_make_valid(npn_sf)
  
  # spatial join to assign ecoregion then join back to original NPN data frame
  npn_eco=st_join(npn_sf, ecor[,c(1:6)]) %>% st_set_geometry(NULL)
  npn=left_join(npn, npn_eco)
  
  #summary(npn)
  
  # check records with no ecoregion assigned
  #npn %>% filter(is.na(NA_L2CODE)) %>% view()
  
  # export data with matched ecoregion
  write_csv(npn %>% filter(!is.na(NA_L3CODE)), 
            file= paste0("C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN", i, "ecor.csv", sep=""))
  
  # export data with no ecoregion matched
  write_csv(npn %>% filter(is.na(NA_L3CODE)), 
            file= paste0("C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN", i, "NOecor.csv", sep=""))
  
}


# read and combine data with no ecoregion matched
npn_noecor <- foreach(i=year, .combine = rbind) %do%
  {
    read_csv(paste0("C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN", i, "NOecor.csv", sep=""))
  }

# export to one csv file
write_csv(npn_noecor, 
          file= paste0("C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN_2009_2021_NOecor.csv", sep=""))


# combine data with ecoregion for all years
npn_ecor <- foreach(i=year, .combine = rbind) %do%
  {
    read_csv(paste0("C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN", i, "ecor.csv", sep=""))
  }

# read data with manually assigned ecoregion
npn_noecor=read_csv("C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN_2009_2021_NOecor_ed.csv")
summary(npn_noecor)
unique(npn_noecor$NA_L2CODE)

ecor = ecoregion3 %>% st_drop_geometry() %>% select(1:4) %>% distinct()

npn_noecor1=npn_noecor %>% select(-NA_L2CODE, -NA_L3CODE)
npn_noecor1=left_join(npn_noecor1, ecor)
summary(npn_noecor1)
unique(npn_noecor1$NA_L2CODE)

# combine data with ecoregion and data with manually-assigned ecoregion
npn_ecor_all=rbind.data.frame(npn_ecor, npn_noecor1)

# assign -9999 to NA
npn_ecor_all[npn_ecor_all==-9999]=NA

write_csv(npn_ecor_all, 
          file= paste0("C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN_2009_2021_ecor_all.csv", sep=""))

# select location-year columns
npn_ecor_sy=npn_ecor_all %>% select(4:9,52:58) %>% distinct()
npn_ecor_sy=npn_ecor_sy %>% arrange(year, siteId)

write_csv(npn_ecor_sy, 
          file= paste0("C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN_2009_2021_ecor_siteyear.csv", sep=""))
