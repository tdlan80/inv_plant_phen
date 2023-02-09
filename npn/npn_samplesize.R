# This script is for calculating sample size from NPN for each species in each year and ecoregion



# load packages
library(tidyverse)
library(foreach)
library(sf)



# read ecoregion data
ecoregion3=st_read(dsn="C:/Users/xiey2/Documents/Data/shapefiles/ecoregions/NA_CEC_Eco_Level3/NA_CEC_Eco_Level3.shp")

# extract ecoregion L1 - L3 dataframe
ecoregion = ecoregion3 %>% select(1:6) %>% st_set_geometry(NULL) %>% distinct()


# process NPN data with edited ecoregion
npn_e=read_csv(file="C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN_2009_2021_NOecor_ed.csv")

# merge to add L2 and L3 code
npn_e$NA_L1CODE=as.character(npn_e$NA_L1CODE)
npn_e=npn_e %>% select(-NA_L2CODE, -NA_L3CODE) %>% left_join(., ecoregion)

# calculate sample size
sms_year_e=npn_e %>% group_by(sciName, year) %>% summarise(n_year=n())
sms_ecor1_e=npn_e %>% group_by(sciName, year, NA_L1CODE) %>% summarise(n_ecor1=n())
sms_ecor2_e=npn_e %>% group_by(sciName, year, NA_L2CODE) %>% summarise(n_ecor2=n())


# process NPN data with ecoregions separated by year
year=2009:2021

# calculate sample size for each species in each year
sms_year <- foreach(i=year, .combine = rbind) %do% 
{
  # read NPN data
  npn=read_csv(file=paste0("C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN", i, "ecor.csv", sep=""))
  
  npn %>% group_by(sciName, year) %>% summarise(n_year=n())
}  
  
# calculate the total sample size for each species
sms_total = rbind.data.frame(sms_year, sms_year_e) %>% group_by(sciName) %>% summarise(n_total=sum(n_year)) %>% arrange(desc(n_total))

write_csv(sms_total, file="C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/NofRecords_total_bySpp.csv")


# combine yearly sample size from two datasets
sms_year = rbind.data.frame(sms_year, sms_year_e) %>% group_by(sciName, year) %>% summarise(n_year=sum(n_year))

write_csv(sms_year, file="C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/NofRecords_bySppYear.csv")


gc()


# calculate sample size for each species in each year in each Level 1 ecoregion
sms_ecor1 <- foreach(i=year, .combine = rbind) %do% 
  {
    # read NPN data
    npn=read_csv(file=paste0("C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN", i, "ecor.csv", sep=""))
    
    npn %>% group_by(sciName, year, NA_L1CODE) %>% summarise(n_ecor1=n())
  }  

# combine yearly sample size from two datasets
sms_ecor1 = rbind.data.frame(sms_ecor1, sms_ecor1_e) %>% group_by(sciName, year, NA_L1CODE) %>% summarise(n_ecor1=sum(n_ecor1))

write_csv(sms_ecor1, file="C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/NofRecords_bySppYearEcor1.csv")

sms_ecor1a = sms_ecor1 %>% group_by(sciName, NA_L1CODE) %>% summarise(n_ecor1=sum(n_ecor1))

write_csv(sms_ecor1a, file="C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/NofRecords_bySppEcor1.csv")



# calculate sample size for each species in each year in each Level 2 ecoregion
sms_ecor2 <- foreach(i=year, .combine = rbind) %do% 
  {
    # read NPN data
    npn=read_csv(file=paste0("C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/plantsNPN", i, "ecor.csv", sep=""))
    
    npn %>% group_by(sciName, year, NA_L2CODE) %>% summarise(n_ecor2=n())
  }  

# combine yearly sample size from two datasets
sms_ecor2 = rbind.data.frame(sms_ecor2, sms_ecor2_e) %>% group_by(sciName, year, NA_L2CODE) %>% summarise(n_ecor2=sum(n_ecor2))

write_csv(sms_ecor2, file="C:/Users/xiey2/Documents/Research/Projects/EREN Biodiversity/NPNdata/NofRecords_bySppYearEcor2.csv")



