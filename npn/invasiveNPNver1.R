
# accessing NPN status data from rnpn
# for eastern US

setwd('C:/Users/tsurasinghe/OneDrive - Bridgewater State University/Research2019/invasiveNPN')

library(readr)
library(readxl)
library(magrittr)
library(tidyverse)
library(tibble)
library(janitor)
library(rnpn)
library(googledrive)
library(googlesheets4)
library(data.table)
library(writexl)
library(vroom)

load("eastUS0921_P1_CSV.RData")
load("eastUS0921_P2_CSV.RData")
load("eastUS0921_P3_CSV.RData")
load("eastUS0921_CSV.RData")
load("plantsNPNdata.RData")
load("allplants.RData")
load("allPhenophases.RData")
# Load("allNPNdata.RData")
load("allNPNdata.RData")
load("phenotables.RData" )
load("plantsNPNdata2.RData")


# Create destination data folder (if there isn't one)
if(!dir.exists('ecoreg')) dir.create('ecoreg')

# online resources
# plant functional types
browseURL("https://docs.google.com/document/d/1eavZ5UzZxiRmfxlmA6t023Z1UD1ggzPbjxBBjPynB0E/pub")

# API/webservice documentation 
browseURL("https://docs.google.com/document/d/1yNjupricKOAXn6tY1sI7-EwkcfwdGUZ7lxYv7fcPjO8/edit")

# rnpn vignette
browseURL("https://github.com/usa-npn/rnpn")

# npn documentation
browseURL("https://pubs.usgs.gov/of/2017/1003/ofr20171003.pdf")
browseURL("https://pubs.usgs.gov/of/2018/1060/ofr20181060.pdf")

# # Download the shapefiles for all ecoregions, level I, II, III.

# default time out is too short
options(timeout = max(3000, getOption("timeout")))

download.file(url = "https://gaftp.epa.gov/EPADataCommons/ORD/Ecoregions/cec_na/na_cec_eco_l1.zip", 
              destfile = "C:/Users/tsurasinghe/OneDrive - Bridgewater State University/Research2019/invasiveNPN/ecoreg/level1.zip", 
              method = "auto", quiet = FALSE, mode = "wb", # for comrpessed files
              cacheOK = TRUE, # Is a server-side cached value acceptable?
              )

download.file(url = "https://gaftp.epa.gov/EPADataCommons/ORD/Ecoregions/cec_na/na_cec_eco_l2.zip", 
              destfile = "C:/Users/tsurasinghe/OneDrive - Bridgewater State University/Research2019/invasiveNPN/ecoreg/level2.zip", 
              method = "auto", quiet = FALSE, mode = "wb", # for comrpessed files
              cacheOK = TRUE, # Is a server-side cached value acceptable?
)

download.file(url = "https://gaftp.epa.gov/EPADataCommons/ORD/Ecoregions/cec_na/NA_CEC_Eco_Level3.zip", 
              destfile = "C:/Users/tsurasinghe/OneDrive - Bridgewater State University/Research2019/invasiveNPN/ecoreg/level3.zip", 
              method = "auto", quiet = FALSE, mode = "wb", # for comrpessed files
              cacheOK = TRUE, # Is a server-side cached value acceptable?
)


# Unzip all folders using unzip 
unzip(zipfile = "ecoreg/level1.zip", #pathname of the zip file with tilde expansion
      files = NULL, # a character vector of recorded filepaths to be extracted: the default (NULL) extracts all files.
      list = FALSE, # If TRUE, list the files and extract none. 
      overwrite = TRUE, junkpaths = FALSE, exdir = "ecoreg", # wxtraction dir
      unzip = "internal", setTimes = FALSE)

unzip(zipfile = "ecoreg/level2.zip", #pathname of the zip file with tilde expansion
      files = NULL, # a character vector of recorded filepaths to be extracted: the default (NULL) extracts all files.
      list = FALSE, # If TRUE, list the files and extract none. 
      overwrite = TRUE, junkpaths = FALSE, exdir = "ecoreg", # wxtraction dir
      unzip = "internal", setTimes = FALSE)

unzip(zipfile = "ecoreg/level3.zip", #pathname of the zip file with tilde expansion
      files = NULL, # a character vector of recorded filepaths to be extracted: the default (NULL) extracts all files.
      list = FALSE, # If TRUE, list the files and extract none. 
      overwrite = TRUE, junkpaths = FALSE, exdir = "ecoreg", # wxtraction dir
      unzip = "internal", setTimes = FALSE)

# The Status and Intensity data type is the most direct presentation of the unprocessed phenology data 
# Each row is comprised of a single record of the status (1/present/“Yes”, 0/absent/“No” or -1/uncertain/“?”) or intensity
# of a single phenophase on an individual plant or species of animal at a site on a single site visit, 
# AND the estimated intensity or abundance (e.g., percent canopy fullness)

# accessing data as a CSV
# without functional_types or species_types defined
# with additional fields included
# since we are pipelineing too much data so need to break it down into smaller chunks 
# split into multiple different years and re-run the same code
# i think the default for most args is NULL
eastUS0921_P1 <-
  npn_download_status_data(
    request_source = "ERENbiodiversity", # who is requesting data
    years = c(2009:2013),
    coords = c ( lower_left_lat = 24.10487, lower_left_long = -95.1356, upper_right_lat = 48.73317, upper_right_long = -61.56138),
    species_ids = NULL, genus_ids = NULL, family_ids = NULL, order_ids = NULL,class_ids = NULL, station_ids = NULL,
    species_types = NULL, network_ids = NULL,
    phenophase_ids = NULL,
    functional_types = NULL,
    additional_fields = c("dataset_id", "site_name", "species_functional_type", "species_category", "usda_plants_symbol", 
                          "phenophase_category", "phenophase_name"),
    climate_data = 1,
    ip_address = NULL,
    dataset_ids = NULL,
    email = "tsurasinghe@bridgew.edu",
    download_path = "eastUS0921_P1.csv",
    six_leaf_layer = FALSE,
    six_bloom_layer = FALSE,
    agdd_layer = NULL,
    six_sub_model = NULL,
    additional_layers = NULL,
    pheno_class_ids = NULL,
    wkt = NULL
  )


eastUS0921_P2 <-
  npn_download_status_data(
    request_source = "ERENbiodiversity", # who is requesting data
    years = c(2014:2017),
    coords = c ( lower_left_lat = 24.10487, lower_left_long = -95.1356, upper_right_lat = 48.73317, upper_right_long = -61.56138),
    species_ids = NULL, genus_ids = NULL, family_ids = NULL, order_ids = NULL,class_ids = NULL, station_ids = NULL,
    species_types = NULL, network_ids = NULL,
    phenophase_ids = NULL,
    functional_types = NULL,
    additional_fields = c("dataset_id", "site_name", "species_functional_type", "species_category", "usda_plants_symbol", 
                          "phenophase_category", "phenophase_name"),
    climate_data = 1,
    ip_address = NULL,
    dataset_ids = NULL,
    email = "tsurasinghe@bridgew.edu",
    download_path = "eastUS0921_P2.csv",
    six_leaf_layer = FALSE,
    six_bloom_layer = FALSE,
    agdd_layer = NULL,
    six_sub_model = NULL,
    additional_layers = NULL,
    pheno_class_ids = NULL,
    wkt = NULL
  )

eastUS0921_P3 <-
  npn_download_status_data(
    request_source = "ERENbiodiversity", # who is requesting data
    years = c(2018:2021),
    coords = c ( lower_left_lat = 24.10487, lower_left_long = -95.1356, upper_right_lat = 48.73317, upper_right_long = -61.56138),
    species_ids = NULL, genus_ids = NULL, family_ids = NULL, order_ids = NULL,class_ids = NULL, station_ids = NULL,
    species_types = NULL, network_ids = NULL,
    phenophase_ids = NULL,
    functional_types = NULL,
    additional_fields = c("dataset_id", "site_name", "species_functional_type", "species_category", "usda_plants_symbol", 
                          "phenophase_category", "phenophase_name"),
    climate_data = 1,
    ip_address = NULL,
    dataset_ids = NULL,
    email = "tsurasinghe@bridgew.edu",
    download_path = "eastUS0921_P3.csv",
    six_leaf_layer = FALSE,
    six_bloom_layer = FALSE,
    agdd_layer = NULL,
    six_sub_model = NULL,
    additional_layers = NULL,
    pheno_class_ids = NULL,
    wkt = NULL
  )


# read back the CSV since the original vector is temp
eastUS0921_P1_CSV <- read_csv(file = "eastUS0921_P1.csv", col_names = TRUE, trim_ws = TRUE, skip = 0, n_max = Inf,  
                              name_repair = "unique", skip_empty_rows = TRUE)
save(eastUS0921_P1_CSV, file = "eastUS0921_P1_CSV.RData")


eastUS0921_P2_CSV <- read_csv(file = "eastUS0921_P2.csv", col_names = TRUE, trim_ws = TRUE, skip = 0, n_max = Inf,  
                              name_repair = "unique", skip_empty_rows = TRUE)
save(eastUS0921_P2_CSV, file = "eastUS0921_P2_CSV.RData")


eastUS0921_P3_CSV <- read_csv(file = "eastUS0921_P3.csv", col_names = TRUE, trim_ws = TRUE, skip = 0, n_max = Inf,  
                              name_repair = "unique", skip_empty_rows = TRUE)
save(eastUS0921_P3_CSV, file = "eastUS0921_P3_CSV.RData")


# bind the data sets together
allNPNdata = rbindlist(list(eastUS0921_P1_CSV, eastUS0921_P2_CSV, eastUS0921_P3_CSV))
save(allNPNdata, file = "allNPNdata.RData")



# filter plant data only
plantsNPNdata2 =  allNPNdata %>% dplyr::filter(kingdom == "Plantae") %>% 
  unite(col= "sciName", c("genus", "species"), sep = " " , remove = F) %>% # make scientific names col
  mutate(invasive = str_detect(string = species_category, pattern = "Invasive", negate = F ) ) %>%  # ID invasive species
  mutate(year = lubridate::year(observation_date) ) # year extracted 

save(plantsNPNdata2, file = "plantsNPNdata2.RData")

# save the cleaned plants-only NPN dataset as a csv
readr::write_csv(x = plantsNPNdata2, file = "plantsNPNdataCSV.csv", append = FALSE, col_names = T)

  
# how many species
plantsNPNdata$common_name %>% as.factor() %>% nlevels() 
plantsNPNdata$species_id %>% as.factor() %>% nlevels()
plantsNPNdata2$sciName %>% as.factor() %>% nlevels() # 777 species 

# how many records of invasive vs native species in the datatset?
plantsNPNdata2 %>% 
  group_by(invasive) %>% 
  dplyr::summarise('no of records' = n() )
#  
# invasive `no of records`
# <lgl>              <int>
# 1 not invasive        12227203
# 2 invasive              754717 

# how many species per invasive vs native in the datatset?
plantsNPNdata2 %>% 
  group_by(invasive) %>% 
  dplyr::summarise('no of species' = n_distinct(sciName) )
#  
# A tibble: 2 × 2
# invasive `no of species`
# <lgl>              <int>
# 1 FALSE              694
# 2 TRUE                  83

# how many records per both native and invasive species
perSpeciesRecrds = plantsNPNdata2 %>% 
  group_by(invasive, sciName) %>% 
  dplyr::summarise('no of records' = n() )

# for each year, how many native vs invasive species
perSpeciesYearRecrds = plantsNPNdata2 %>% 
  group_by(invasive, year, sciName) %>% 
  dplyr::summarise('no of records' = n() )

# how many different phenophase types were observed per species
perSpeciesPhenophaseRecrds = plantsNPNdata2 %>% 
  group_by(invasive, sciName, phenophase_category) %>% 
  dplyr::summarise('no of records' = n() )

# site_ID, year
# how many records per site, year, per species, per phenophase category
# switch the order-- species, sites, in which years
perSiteYrSpeciesPhenoRecrds = plantsNPNdata2 %>% 
  group_by(site_id, year, invasive, sciName, phenophase_category) %>% 
  dplyr::summarise('no of records' = n() )

# save above objects as xl files 
write_xlsx(x = perSpeciesRecrds, path = "perSpeciesRecrds.xlsx", col_names = TRUE, format_headers = TRUE)
write_xlsx(x = perSpeciesYearRecrds, path = "perSpeciesYearRecrds.xlsx", col_names = TRUE, format_headers = TRUE)
write_xlsx(x = perSpeciesPhenophaseRecrds, path = "perSpeciesPhenophaseRecrds.xlsx", col_names = TRUE, format_headers = TRUE)
write_xlsx(x = perSiteYrSpeciesPhenoRecrds, path = "perSiteYrSpeciesPhenoRecrds.xlsx", col_names = TRUE, format_headers = TRUE)

save(perSpeciesRecrds, perSpeciesYearRecrds, perSpeciesPhenophaseRecrds, file ="phenotables.RData" )

# look at all the plant species at NPN, this will contain a functional_type category
allplants <- npn_species(kingdom = "Plantae", start_date = "01-01-2009", end_date = "12-31-2021" )
save(allplants, file = "allplants.RData")

# look at all the plant phenophases at NPN
allPhenophases <- npn_phenophases(kingdom = "Plantae" )
save(allPhenophases, file = "allPhenophases.RData")

# check out the data from the web portal
# should be the same as those coming from the API
# did not work
eastUS <- read_csv(file = "webPortalData/datasheet_1669510180895/status_intensity_observation_data.csv", 
                   col_names = TRUE, trim_ws = TRUE, skip = 0, n_max = Inf,  name_repair = "unique", skip_empty_rows = TRUE)
# didnot work
eastUS <- vroom(file = "webPortalData/datasheet_1669510180895/status_intensity_observation_data.csv",
                delim = NULL,  col_names = TRUE, col_select = NULL,
                id = NULL, skip = 0, n_max = Inf,  skip_empty_rows = TRUE,
                trim_ws = TRUE, .name_repair = "unique")

# worked
webPlantsNPN2 <- fread(file = "webPortalData/datasheet_1669510180895/status_intensity_observation_data.csv", 
                       sep="auto", sep2="auto", # auto-detect the separator 
                       dec=".", nrows=Inf, header= T,
                       na.strings=getOption("datatable.na.strings","NA"),  # character vector of strings which are to be interpreted as NA values
                       stringsAsFactors=FALSE, skip= 0, select=NULL, drop=NULL, colClasses=NULL,
                       check.names=T, # names of the variables in the data.table are checked to ensure that they are syntactically valid variable names. 
                       strip.white=TRUE, fill=T, # If TRUE, in case  rows have unequal length, blank fields are implicitly filled. 
                       blank.lines.skip=FALSE, #  If TRUE blank lines in the input are ignored.
                       data.table=getOption("datatable.fread.datatable", TRUE), # TRUE returns a data.table. FALSE returns a data.frame. 
                       logical01=getOption("datatable.logical01", FALSE),  # If TRUE a column containing only 0s and 1s will be read as logical, otherwise as integer.
                       keepLeadingZeros = getOption("datatable.keepLeadingZeros", FALSE), # If TRUE a column containing numeric data with leading zeros will be read as character, 
)
save(webPlantsNPN2, file = "webPlantsNPN2.RData")

# worked
webPlantsNPN = read.csv(file = "webPortalData/datasheet_1669510180895/status_intensity_observation_data.csv", header = TRUE, sep = ",", quote = "\"",
                        dec = ".", fill = TRUE)
save(webPlantsNPN, file = "webPlantsNPN.RData")
