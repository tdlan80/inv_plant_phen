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



# read data with family and native status from NEON
sp_neon=read_csv(file="C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/nOfRec_bySppYrEcor1Nativity2_1.csv")


# combine family name and native status, and remove invasive column
sp_site_all1=left_join(sp_site_all[, -13], sp_neon[, c(1, 6:7)]) %>% distinct()

sp_site_all1=sp_site_all1[, c(1:5, 19, 6:8, 11:12, 9:10, 20, 13:18)]
colnames(sp_site_all1)[6]="familyName"

summary(sp_site_all1)

write_csv(sp_site_all1, file = "C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN_spp_sites_all_20230802.csv")


table(sp_site_all1$nativeStatusCode, useNA = "always")
#     A     I     N    NI  <NA> 
#   141  4017 24373   630   542 

table(sp_site_all1$growthHabit, useNA="always")
# Forb/herb     Shrub  Subshrub      Tree      Vine      <NA> 
#   5376      7265       854     14794       323      1091 

table(sp_site_all1$speciesFunctionalType, useNA="always")
# Algae                      Cactus         Deciduous broadleaf           Deciduous conifer 
#    9                          10                       20508                         238 
# Drought deciduous broadleaf         Evergreen broadleaf           Evergreen conifer              Evergreen forb 
#                         75                        1222                         576                          36 
# Forb                   Graminoid                        Pine    Semi-evergreen broadleaf 
# 5823                         313                         586                         291 
# Semi-evergreen forb                        <NA> 
#                 16                           0 

sp_site_all1 %>% filter(is.na(growthHabit)) %>% view()

sp_site_all1 %>% filter(is.na(nativeStatusCode)) %>% view()
