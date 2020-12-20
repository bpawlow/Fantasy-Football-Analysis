# Loaded Packages & Other R Scripts----

library(tidyverse)
library(naniar)

### Loading Data Collection R Script & Data Cleaning R Script 

source("data_collection.R")
source("data_cleaning.R")

# Assessing NA Values ----

#Summaries of missing data
summary(complete_ff_data)
vis_dat(complete_ff_data) 
vis_miss(complete_ff_data)

#Analyzing missing data of `y_a`

ggplot(complete_ff_data, 
       aes(x = rush_att, 
           y = y_a)) + 
  geom_miss_point()

ggplot(complete_ff_data, 
       aes(x = rush_yds, 
           y = y_a)) + 
  geom_miss_point()

#Analyzing missing data of `y_r` 
ggplot(complete_ff_data, 
       aes(x = rec, 
           y = y_r)) + 
  geom_miss_point()

ggplot(complete_ff_data, 
       aes(x = rec_yds, 
           y = y_r)) + 
  geom_miss_point()

#Analyzing missing data based on comparison of `y_a` and `y_r`

ggplot(complete_ff_data, 
       aes(x = y_r, 
           y = y_a)) + 
  geom_miss_point()

#Plotting NA patterns in data for y_a and y_r for each position
ggplot(complete_ff_data, 
       aes(x = y_r, 
           y = y_a)) + 
  geom_miss_point() +
  facet_wrap(~fant_pos) + 
  theme_dark()

#Further analysis of NA patterns in data for y_a and y_r

complete_ff_data %>% 
    filter(is.na(y_a) & fant_pos == "RB") %>%
    ggplot(aes(x = g)) + 
    geom_histogram()

complete_ff_data %>% 
    filter(is.na(y_r) & fant_pos == "RB") %>%
    ggplot(aes(x = g)) + 
    geom_histogram()

complete_ff_data %>% 
       filter(is.na(y_a) & fant_pos == "QB") %>%
       ggplot(aes(x = g)) + 
       geom_histogram()

complete_ff_data %>% 
       filter(is.na(y_r) & fant_pos == "WR") %>%
       ggplot(aes(x = g)) + 
       geom_histogram()

complete_ff_data %>% 
  filter(is.na(y_a)) %>%
  ggplot(aes(x = rush_att)) + 
  geom_freqpoly()

complete_ff_data %>% 
  filter(is.na(y_r)) %>%
  ggplot(aes(x = rec)) + 
  geom_freqpoly()

#Analyzing missing data of `fl`

ggplot(complete_ff_data, 
       aes(x = fmb, 
           y = fl)) + 
  geom_jitter()

#Plotting fumbles (both lost and recovered) and fumbles lost to explain why there is NA values
complete_ff_data %>% 
  filter(!is.na(fant_pos)) %>% 
  ggplot(aes(x = fmb, 
             y = fl)) + 
  geom_miss_point(jitter = 1) + 
  facet_wrap(~fant_pos) + 
  theme_dark()

complete_ff_data %>% 
  filter(is.na(fl)) %>%
  ggplot(aes(x = fmb)) + 
  geom_freqpoly()
