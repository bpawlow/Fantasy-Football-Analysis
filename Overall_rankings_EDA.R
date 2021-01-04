# Loaded Packages & Other R Scripts----

library(tidyverse)

### Loading Data Collection R Script & Data Cleaning R Script 

source("data_collection.R")
source("data_cleaning.R")

# Most Consistent Fantasy Players Over Their Career----

# Calculating top career average fantasy points for NFL player

sub_data <- complete_ff_data %>%
  filter(g > 8) %>% 
  group_by(ply_code) %>% 
  summarize(player = player,
            fant_pos = fant_pos,
            g = g, 
            tot_games = sum(g),
            fant_pt = fant_pt,
            year = year,
            tot_ff_pts = sum(fant_pt),
  ) %>% 
  mutate(career_avg_fp = tot_ff_pts / tot_games,
         avg_ff_yr = fant_pt / g) 

box_plot_data <- sub_data %>%
  arrange(desc(career_avg_fp)) %>%
  ungroup(ply_code) %>%
  select(-ply_code)

best_career_avgs <- complete_ff_data %>%
  filter(g > 8) %>% 
  group_by(ply_code) %>% 
  summarize(player = player,
            fant_pos = fant_pos,
            tot_games = sum(g),
            tot_ff_pts = sum(fant_pt)
            ) %>% 
  mutate(career_avg_fp = tot_ff_pts / tot_games) %>%
  unique() %>% 
  arrange(desc(career_avg_fp)) %>%
  ungroup(ply_code) %>%
  select(-ply_code)

# Rankings of best QBs by career averages
best_career_avgs %>% 
  filter(fant_pos == "QB", tot_games >= 100) %>% 
  head(10) %>% 
  ggplot(aes(x = reorder(player, career_avg_fp), y = career_avg_fp)) + 
    geom_bar(stat="identity", width=.5, fill="tomato3") +
    coord_flip()

box_plot_data %>% 
  filter(fant_pos == "QB", tot_games >= 100) %>% 
  select(player, year, avg_ff_yr) %>% 
  head(125) %>% 
  ggplot(aes(x = fct_rev(player), y = avg_ff_yr)) + 
  geom_boxplot(aes(group = player)) +
  geom_jitter() +
  coord_flip()


# Rankings of best RBs by career averages
best_career_avgs %>% 
  filter(fant_pos == "RB", tot_games >= 50) %>% 
  head(25) %>% 
  ggplot(aes(x = reorder(player, career_avg_fp), y = career_avg_fp)) + 
    geom_bar(stat="identity", width=.5, fill="tomato3") +
    coord_flip()

box_plot_data %>% 
  filter(fant_pos == "RB", tot_games >= 50) %>% 
  select(player, year, fant_pt, avg_ff_yr) %>% 
  head(172) %>% 
  ggplot(aes(x = fct_rev(player), y = avg_ff_yr)) + 
  geom_boxplot(aes(group = player)) +
  geom_jitter() +
  coord_flip()

# Rankings of best WRs by career averages
best_career_avgs %>% 
  filter(fant_pos == "WR", tot_games >= 50) %>% 
  head(25) %>% 
  ggplot(aes(x = reorder(player, career_avg_fp), y = career_avg_fp)) + 
    geom_bar(stat="identity", width=.5, fill="tomato3") +
    coord_flip()

box_plot_data %>% 
  filter(fant_pos == "WR", tot_games >= 50) %>% 
  select(player, year, avg_ff_yr) %>% 
  head(201) %>% 
  ggplot(aes(x = fct_rev(player), y = avg_ff_yr)) + 
  geom_boxplot(aes(group = player)) +
  geom_jitter() +
  coord_flip()

# Rankings of best TEs by career averages
best_career_avgs %>% 
  filter(fant_pos == "TE", tot_games >= 50) %>% 
  head(10) %>% 
  ggplot(aes(x = reorder(player, career_avg_fp), y = career_avg_fp)) + 
    geom_bar(stat="identity", width=.5, fill="tomato3") +
    coord_flip()

box_plot_data %>% 
  filter(fant_pos == "TE", tot_games >= 50) %>% 
  select(player, year, avg_ff_yr) %>% 
  head(90) %>% 
  ggplot(aes(x = fct_rev(player), y = avg_ff_yr)) + 
  geom_boxplot(aes(group = player)) +
  geom_jitter() +
  coord_flip()

# Most Top Ten Fantasy Finishes at Each Position----

most_top_finishes <- complete_ff_data %>%
  filter(pos_rank <= 10) %>% 
  group_by(ply_code) %>% 
  summarize(player = player,
            fant_pos = fant_pos,
            top_ten_finishes = n()
  ) %>%
  unique() %>% 
  arrange(desc(top_ten_finishes)) %>%
  ungroup(ply_code) %>%
  select(-ply_code)

#Top 10 QBs

most_top_finishes %>%
  filter(fant_pos == "QB") %>% 
  slice(1:10)

#Top 10 RBs

most_top_finishes %>%
  filter(fant_pos == "RB") %>% 
  slice(1:15)

#Top 10 WRs

most_top_finishes %>%
  filter(fant_pos == "WR") %>% 
  slice(1:15)

#Top 10 TEs

most_top_finishes %>%
  filter(fant_pos == "TE") %>% 
  slice(1:10)

# Greatest Seasonal Performances of All Time ---

best_seasons <- complete_ff_data %>%
  arrange(desc(fant_pt)) %>%
  select(player, year, fant_pos, g, fant_pt) %>%
  group_by(fant_pos) %>% 
  slice(1:5) %>%
  mutate(
    avg_fp = fant_pt / g
  ) 

#Top 5 performances for QBs

best_seasons %>%
  filter(fant_pos == "QB")

#Top 5 performances for RBs

best_seasons %>%
  filter(fant_pos == "RB")

#Top 5 performances for WRs

best_seasons %>%
  filter(fant_pos == "WR")

#Top 5 performances for TEs

best_seasons %>%
  filter(fant_pos == "TE")

# Consistency/Seasonal Performances of Bear's Players Over the Last 20 Years----

#Career average rankings 

top_bears_plyrs <- complete_ff_data %>%
  filter(g > 8) %>% 
  group_by(ply_code, tm) %>% 
  summarize(player = player,
            fant_pos = fant_pos,
            tot_games = sum(g),
            tot_ff_pts = sum(fant_pt)
  ) %>% 
  mutate(career_avg_fp = tot_ff_pts / tot_games) %>%
  unique() %>% 
  arrange(desc(career_avg_fp)) %>%
  ungroup(ply_code) %>%
  select(-ply_code)

bears_plyrs_by_pos <- top_bears_plyrs %>% 
  filter(tm == "CHI", tot_games >= 16) %>% 
  group_by(fant_pos) %>% 
  slice(1:3)

#Top 3 Bear's QBs

bears_plyrs_by_pos %>%
  filter(fant_pos == "QB")

#Top 3 Bear's RBs

bears_plyrs_by_pos %>%
  filter(fant_pos == "RB")

#Top 3 Bear's WRs

bears_plyrs_by_pos %>%
  filter(fant_pos == "WR")

#Top 3 Bear's TEs

bears_plyrs_by_pos %>%
  filter(fant_pos == "TE")

#Top Seasonal Performances by Bear's Players at Each Position 

bears_top_season <- complete_ff_data %>%
  arrange(desc(fant_pt)) %>%
  select(player, tm, year, fant_pos, g, fant_pt) %>%
  filter(tm == "CHI") %>% 
  group_by(fant_pos) %>% 
  slice(1) %>% 
  mutate(
    avg_fp = fant_pt / g
  ) %>% 
  filter(!is.na(fant_pos))
