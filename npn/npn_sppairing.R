# combine all datasets, species selection and pairing

# load packages
library(tidyverse)


# load growth form data
load("C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/USDA Plants Database/USDAplantsNPNdata2.Rdata")

sp_gh=USDAplantsNPNdata2 %>% select(sciName, speciesId, growthHabit) %>% distinct()

table(sp_gh$growthHabit,useNA = "always")
# Forb/herb     Shrub  Subshrub      Tree      Vine      <NA> 
#   301       234        76       279        30        83 

# export simple species growth habit data
write_csv(sp_gh, file = "C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/USDA Plants Database/NPN_species_growthHabit.csv")




# read growthHabit data
sp_gh=read_csv(file = "C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/USDA Plants Database/NPN_species_growthHabit.csv")


# read data with edited NLCD for each site
site_lc=read_csv("C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN_2009_2021_ecor_siteyear_nlcd_edited.csv")

# extract level 1 NLCD class
site_lc1=site_lc %>% select(siteId, NLCD) %>% 
  mutate(NLCD_L1=as.integer(NLCD/10))

summary(site_lc1)



# read phenology data
npn_all=read_csv("C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN_2009_2021_ecor_all.csv")

colnames(npn_all)
head(npn_all)

# select columns
sp_all=npn_all %>% select(siteId, latitude, longitude, elevationInMeters, sciName, genusName, speciesEpithet, commonName, speciesFunctionalType, speciesCategory, usdaPlantsSymbol, speciesId, invasive, NA_L1CODE, NA_L2CODE, NA_L3CODE) %>% distinct()

summary(sp_all)


# combine land cover and growth habit to species-sites data
sp_site_all=left_join(sp_all, sp_gh) %>% left_join(., site_lc1)

# export combined data
write_csv(sp_site_all, file = "C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN_spp_sites_all.csv")


# read combined data
sp_site_all= read_csv(file = "C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN_spp_sites_all.csv")

table(sp_site_all$growthHabit, useNA="always")
