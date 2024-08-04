# Objective: To pull data on CPI Urban from BLS

######################
library(rjson)
library(blsR)
library(foreign)
library(dplyr)
library(readr)
library(SaveData)
if (packageVersion("blsR") < '0.5.0') {
  stop("Warning: blsR 0.5.0 or newer is required. Please update your version.")
} 

# Adjust paths as necessary:
data_dir<-"../output"

#### For Future Implementation ####

 #my_key = readline(prompt = "Enter Your BLS Key:
    #If you do not have one, go to https://data.bls.gov/registrationEngine/ ")

my_key <- read_file("./BLS_API_Key.txt")
bls_set_key(my_key)
## Pull the data via the API- second argument is API key
CPI_data <- get_series_table('CUUR0000SA0', bls_get_key(), 2013, 2022)
CPI_data$value <- as.numeric(CPI_data$value)
CPI_annual.df <- CPI_data%>%group_by(year)%>%summarise(mean(value))
names(CPI_annual.df)[names(CPI_annual.df) == "mean(value)"] <- "cpiu"
CPI_annual.df$cpiu_2022 <- subset(CPI_annual.df$cpiu, CPI_annual.df$year == 2022)
CPI_annual.df$cpiu_adj <- (as.numeric(as.character(CPI_annual.df$cpiu))/ as.numeric(as.character(CPI_annual.df$cpiu_2022))) * 100
CPI_annual.df <-  subset(CPI_annual.df, select=c(year, cpiu, cpiu_adj))
CPI_annual.df$year <- as.numeric(as.character(CPI_annual.df$year))

# Export as dta
names(CPI_annual.df)[names(CPI_annual.df) == "value"] <- "cpiu"
SaveData(CPI_annual.df, "year", "../output/CPI-U.dta")
