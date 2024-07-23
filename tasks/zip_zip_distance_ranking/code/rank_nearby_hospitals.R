## This script will rank the closest 3 hospitals to each office facility by ZIP centroid distance. 

library(readr)
library(geosphere)
library(dplyr)
library(stringr)
library(haven)

args <- commandArgs(trailingOnly = TRUE)
year <- args[1]
shortyear <- as.numeric(substr(year, 3, 4))


## Read in CSV with office and hospital. Create two dfs, one for each. Save only the unique ZIPs for each.

if (year <= 2015) {
    centroid_file <- read_csv("../input/gaz2015zcta5centroid.csv")
} else {
    centroid_file <- read_csv(paste0("../input/gaz", year, "zcta5centroid.csv"))
}

centroid_file$zcta5 <- str_pad(centroid_file$zcta5, width=5, side="left", pad="0")  # add zeros in front


office_file <- read_dta(paste0("../input/trimmed_provider_data_", year, ".dta"), col_select = c("Rndrng_Prvdr_Zip5", "Place_Of_Srvc"))
names(office_file)[names(office_file) == 'Rndrng_Prvdr_Zip5'] <- 'zcta5'
office_zips <- office_file %>% filter(Place_Of_Srvc == "O") %>% distinct(zcta5, .keep_all = TRUE)

facility_zips <- read_csv(paste0("../input/MUP_INP_RY24_P04_V10_DY", shortyear, "_Prv.csv"), col_select = c('Rndrng_Prvdr_Zip5'))
names(facility_zips)[names(facility_zips) == 'Rndrng_Prvdr_Zip5'] <- 'zcta5'
facility_zips <- facility_zips %>% distinct(zcta5, .keep_all = TRUE)

## merge files

facility_zips_merged <- facility_zips %>% inner_join(centroid_file, by = "zcta5")
facility_zips_merged$index <- seq.int(nrow(facility_zips_merged))
office_zips_merged <- office_zips %>% inner_join(centroid_file, by = "zcta5")
office_zips_merged$index <- seq.int(nrow(office_zips_merged))


## Loop through each row in the office file to compute and save the top 3 ZIPs by distance

# for this, need to arrange columns so that it goes long, lat

facility_clean <- facility_zips_merged %>% select(c('intptlong', 'intptlat'))
office_clean <- office_zips_merged %>% select(c('intptlong', 'intptlat'))

for(i in 1:nrow(office_clean)){
  #calucate distance against all of B
  distances<-geosphere::distGeo(office_clean[i,], facility_clean)/1000
  #rank the calculated distances
  ranking<-rank(distances, ties.method = "first")
  
  #find the 3 shortest and store the indexes of B back in A
  office_clean$index_1[i]<-which(ranking ==1) #Same as which.min()
  office_clean$index_2[i]<-which(ranking==2)
  office_clean$index_3[i]<-which(ranking ==3)
  
  #store the distances back in A
  office_clean$distance_1[i]<-distances[office_clean$index_1[i]] #Same as min()
  office_clean$distance_2[i]<-distances[office_clean$index_2[i]]
  office_clean$distance_3[i]<-distances[office_clean$index_3[i]]
  
  if (i %% 1000 == 0) {
    print(paste0(i, " Rows completed"))
  }
}

## merge with ZIPs

## clean merged files

facility_zips_only <- facility_zips_merged %>% select(c('index', 'zcta5'))
office_zips_only <- office_zips_merged %>% select(c('index', 'zcta5'))


final_office_file <- office_clean %>% inner_join(facility_zips_only, join_by(index_1 == index)) %>% rename(zcta5_1 = zcta5)
final_office_file <- final_office_file %>% inner_join(facility_zips_only, join_by(index_2 == index)) %>% rename(zcta5_2 = zcta5)
final_office_file <- final_office_file %>% inner_join(facility_zips_only, join_by(index_3 == index)) %>% rename(zcta5_3 = zcta5)
final_office_file <- office_zips_only$zcta5 %>% cbind(final_office_file)
colnames(final_office_file)[1] = "office_zcta"

write_dta(final_office_file, paste0("../output/nearby_hospitals_", year, ".dta"))