library(httr)
library(jsonlite)
library(dplyr)
library(readr)
## maximum size is 5000. So for each year of about 10 million obs, this needs to run 2k times. 
download_cms_data <- function(key, year, size = 5000) {
  base_url <- paste0("https://data.cms.gov/data-api/v1/dataset/", key, "/data")
  offset <- 0
  all_data <- list()
  
  while (TRUE) {
    url <- paste0(base_url, "?offset=", offset, "&size=", size)
    response <- GET(url, add_headers('accept' = 'application/json'))
    
    if (status_code(response) == 200) {
      data <- content(response, as = "text")
      if (length(data) == 0) {
        break
      }
      all_data <- fromJSON(data) %>% as.data.frame() %>% bind_rows(all_data)
      
      offset <- offset + size
      
    } else {
      print(paste("Failed to retrieve data:", status_code(response)))
      break
    }
    
    if (offset %% 100000 == 0) {
      print(paste("Rows Downloaded:", offset))
    }
    
  }
  
  all_data$year <- year
  write_csv(all_data, paste0("../output/medicare_provider_data_", year, ".csv"))
  return(all_data)
}


download_cms_data("4f307be4-6868-4a9e-ae92-acf3fd4b5543", 2022)
download_cms_data("5c67d835-3862-4f63-897d-85d3eac82d5b", 2021)
download_cms_data("862ed658-1f38-4b2f-b02b-0b359e12c78a", 2020)
download_cms_data("5fccd951-9538-48a7-9075-6f02b9867868", 2019)
download_cms_data("02c0692d-e2d9-4714-80c7-a1d16d72ec66", 2018)
download_cms_data("7ebc578d-c2c7-46fd-8cc8-1b035eba7218", 2017)
download_cms_data("5055d307-4fb3-4474-adbb-a11f4182ee35", 2016)
download_cms_data("0ccba18d-b821-47c6-bb55-269b78921637", 2015)
download_cms_data("e6aacd22-1b89-4914-855c-f8dacbd2ec60", 2014)
download_cms_data("4ebaf67d7-1572-4419-a053-c8631cc1cc9b", 2013)

