# Loaded Packages & Other R Scripts----

library(tidyverse)
library(janitor)
library(visdat)
library(hablar)

### Loading Data Collection R Script

source("data_collection.R")

# Data Cleaning ---- 

### Modify the column names to the correct names (2nd row)

for (i in file_vector) {
  file_list[[i]] <- 
    file_list[[i]] %>%
      row_to_names(row_number = 1)
}

### Rename column names appropriately

for (i in file_vector) {
    names(file_list[[i]])[9] <- "Pass_Att"
    names(file_list[[i]])[13] <- "Rush_Att"
    names(file_list[[i]])[10] <- "Pass_Yds"
    names(file_list[[i]])[14] <- "Rush_Yds"
    names(file_list[[i]])[19] <- "Rec_Yds"
    names(file_list[[i]])[11] <- "Pass_TD"
    names(file_list[[i]])[16] <- "Rush_TD"
    names(file_list[[i]])[21] <- "Rec_TD"
    names(file_list[[i]])[24] <- "Score_TD"
}
### Adding the season year column to all tables

i <- 1
while (i < 21) {
    file_list[[i]]$Year <- rep(c(i + 1999))
    file_list[[i]] <-
      select(file_list[[i]], Rk, Player, Year, everything())
  i = i + 1
}

### Joining all datasets vertically & adjusting player names/codes 

complete_ff_data <- file_list %>% 
  map_df(bind_rows) %>%
  mutate(
    ply_code = str_extract(Player, "\\\\.*$") %>% 
      str_remove_all("\\\\") %>% 
      str_trim(side = "both"),
    Player = str_extract(Player, "^.*\\\\") %>% 
      str_remove_all("\\\\|\\*|\\+") %>% 
      str_trim(side = "both"),
    Tm = str_replace_all(Tm, "STL", "LAR")
  ) %>% 
  mutate(Tm = str_replace_all(Tm, "SDG", "LAC")) %>% 
  select(Rk, Player, ply_code, everything()) 

### Clean column names

complete_ff_data <- 
  complete_ff_data %>% 
  clean_names()

### Remove unnecessary column(s)

complete_ff_data <- 
  complete_ff_data %>% 
  select(-rk)

### Scratch Work For String Modification of Players (Unused)

# for (i in file_vector) {
#   file_list[[i]] <- 
#     file_list[[i]][!duplicated(file_list[[i]]$Player), ]
# }
# 
# for (i in file_vector) {
#   file_list[[i]] <-
#     file_list[[i]] %>%
#       mutate(
#         Player = unlist(strsplit(Player, c('*', '+', '\\'),
#           fixed = TRUE))[1]
#       )
# }
# 
# View(file_list[[1]])
# View(file_list[[20]])

# Assessing and Modifying Type Values ---- 

#Many columns are characters and not integers/numeric
vis_dat(complete_ff_data) 

#Convert necessary columns to be numeric values
complete_ff_data <-
  complete_ff_data %>% 
    convert(num(year),
          num(age:ov_rank))

# Testing ---- 

#Testing random sample of individual datasets for each year to ensure a more
#tidy version 

head(file_list[[1]])
head(file_list[[5]])
head(file_list[[10]])
head(file_list[[15]])
head(file_list[[20]])

vis_dat(complete_ff_data) 

complete_ff_data

