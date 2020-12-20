# Loaded Packages ----

library(tidyverse)

# Data Importing ---- 

### Establish vector of rankings from 2000-2019

file_vector <- dir("data/unprocessed/", pattern = "\\.txt$", full.names = TRUE)

### Store ranking tables in a list

file_list <- list()

for (i in file_vector) {
  file_list[[i]] <- read_csv(i)
}

# Testing ---- 

### Verifying that the list includes the data frames of various years

import_2000 <- file_list[[1]]
import_2005 <- file_list[[6]]
import_2010 <- file_list[[11]]
import_2015 <- file_list[[16]]
import_2019 <- file_list[[20]]

#Testing random sample of individual datasets for each year to ensure proper 
#import

head(import_2000)
head(import_2005)
head(import_2010)
head(import_2015)
head(import_2019)

### Checking that `file_vector` has proper files 

file_vector
