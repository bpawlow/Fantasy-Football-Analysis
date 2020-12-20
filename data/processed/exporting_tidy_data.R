# Loaded Packages & Other R Scripts----

library(tidyverse)
library(xlsx)

### Loading Data Collection R Script & Data Cleaning R Script 

source("data_collection.R")
source("data_cleaning.R")

# Exporting Data into Excel Spreadsheet----

write.xlsx(complete_ff_data, "data/processed/complete_ff_data.xlsx", 
           sheetName = "FF Data 2000-2019")

### Split into 3 separate excel files due to memory capacity 

i <- 1
while (i < 9) {
  if (i == 1){
    write.xlsx(file_list[[i]], "data/processed/2000_to_2007.xlsx",
               sheetName = toString(i + 1999))
  }else {
    write.xlsx(file_list[[i]], "data/processed/2000_to_2007.xlsx",
             sheetName = toString(i + 1999), append = TRUE)
  }
  i = i + 1
}

i <- 9
while (i < 17) {
  if (i == 9){
    write.xlsx(file_list[[i]], "data/processed/2008_to_2015.xlsx",
               sheetName = toString(i + 1999))
  }else {
    write.xlsx(file_list[[i]], "data/processed/2008_to_2015.xlsx",
               sheetName = toString(i + 1999), append = TRUE)
  }
  i = i + 1
}

i <- 17
while (i < 21) {
  if (i == 17){
    write.xlsx(file_list[[i]], "data/processed/2016_to_2019.xlsx",
               sheetName = toString(i + 1999))
  }else {
    write.xlsx(file_list[[i]], "data/processed/2016_to_2019.xlsx",
               sheetName = toString(i + 1999), append = TRUE)
  }
  i = i + 1
}

?flights
