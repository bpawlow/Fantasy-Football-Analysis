# Loaded Packages & Other R Scripts----

library(tidyverse)
library(modelr)
library(splines)

### Loading Data Collection R Script & Data Cleaning R Script 

source("data_collection.R")
source("data_cleaning.R")
source("Overall_rankings_EDA.R")

# Fantasy Talent for NFL Teams Over The Last 5 Years----

#For QBs, RBs, WRs, and TEs based on total fantasy points

team_fantasy_prod <- complete_ff_data %>%
  filter(fant_pos == "RB" | fant_pos == "Wr" | 
           fant_pos == "TE" | fant_pos == "QB", year > 2014) %>% 
  mutate(
    fant_pt = replace_na(fant_pt, 0)
  ) %>% 
  group_by(tm, year) %>% 
  summarize(
    total_ff_pts = sum(fant_pt)
  ) %>% 
  filter(tm != "2TM" & tm != "3TM")

team_fantasy_prod %>% 
  ggplot(aes(x = year, y = total_ff_pts)) +
  geom_smooth(size = 1) + 
  facet_wrap(~tm , scales="free")

#Assessing trends of growth or decay using various models
#Teams selected based on apparent visual patterns: 
#BAL (Exponential trend)
#CIN, DAL, HOU, MIA, MIN, NOR, NWE, PHI, SFO, WAS (Linear trends)

#Linear trends 

team_fantasy_prod %>% 
  filter(tm == "CIN" | tm == "DAL" | tm == "HOU" | tm == "MIA" | tm == "MIN" | 
      tm == "NOR" |  tm == "NWE" | tm == "PHI" | tm == "SFO" | tm == "WAS") %>% 
  ggplot(aes(x = year, y = total_ff_pts)) +
  geom_point(size = 1) + 
  facet_wrap(~tm, scales = "free") +
  stat_smooth(method = "lm", col = "red") 

#Exponential Trend with BAL

bal_fantasy_prod <- team_fantasy_prod %>% 
  filter(tm == "BAL") %>% 
  mutate(log_ff_pts = log2(total_ff_pts))

model <- lm(log_ff_pts ~ year, data = bal_fantasy_prod)

grid <- bal_fantasy_prod %>% 
  data_grid(year) %>% 
  add_predictions(model, "log_ff_pts") %>% 
  mutate(total_ff_pts = 2 ^ log_ff_pts)

ggplot(bal_fantasy_prod, aes(x = year, y = total_ff_pts)) +
  geom_smooth(size = 1) + 
  geom_line(data = grid, colour = "red", size = 1)

bal_fantasy_prod %>% 
  add_residuals(model) %>% 
  ggplot(aes(year, resid)) +
    geom_line()

### Scratch Work ###

# #Fit a loess model to BAL data
# exp_mod <- loess(total_fp_pts ~ year, data = bal_fantasy_prod)
# 
# #Add predictions and residuals to BAL data
# mod_data <- bal_fantasy_prod %>%
#   add_predictions(model = exp_mod, var = "pred_loess") %>%
#   add_residuals(exp_mod, "resid_loess")
# 
# mod_data %>% 
#   ggplot(aes(x = year)) +
#   geom_line(aes(y = total_fp_pts), size = 1) + 
#   geom_line(aes(y = pred_loess), color = "red")
  

#The top 10 teams sustaining the most top-25 players, in total at each position 
#(duplicate players included)

#Over the last 20 years
complete_ff_data %>%
  filter(pos_rank <= 25) %>% 
  group_by(tm) %>% 
  summarize(top25_players = n()) %>%
  unique() %>% 
  mutate(avg_num_players = top25_players / 20) %>% 
  arrange(desc(top25_players)) %>% 
  head(10) %>% 
  ggplot(aes(x = reorder(tm, top25_players), y = top25_players)) + 
  geom_bar(stat="identity", width=.5, fill="blue") +
  coord_flip()

#Over the last 5 years 

complete_ff_data %>%
  filter(pos_rank <= 25, year > 2014) %>% 
  group_by(tm) %>% 
  summarize(top25_players = n()) %>%
  unique() %>% 
  mutate(avg_num_players = top25_players / 5) %>% 
  arrange(desc(top25_players)) %>% 
  head(10) %>% 
  ggplot(aes(x = reorder(tm, top25_players), y = top25_players)) + 
  geom_bar(stat="identity", width=.5, fill="cornflowerblue") +
  coord_flip()

#Worst teams for fantasy production over the last 20 years 

complete_ff_data %>%
  filter(pos_rank <= 25, tm != "2TM" & tm != "3TM") %>% 
  group_by(tm) %>% 
  summarize(top25_players = n()) %>%
  mutate(avg_num_players = top25_players / 20) %>% 
  unique() %>% 
  arrange(top25_players) %>% 
  head(10)

#Worst teams for fantasy production over the last 5 years 

complete_ff_data %>%
  filter(pos_rank <= 25, year > 2014, tm != "2TM" & tm != "3TM") %>% 
  group_by(tm) %>% 
  summarize(top25_players = n()) %>%
  mutate(avg_num_players = top25_players / 5) %>% 
  unique() %>% 
  arrange(top25_players) %>% 
  head(10) 

### Scratch Work ###

# View(complete_ff_data %>%
#   filter(fant_pos == "RB" | fant_pos == "Wr" | fant_pos == "TE") %>% 
#   mutate(
#     fant_pt = replace_na(fant_pt, 0)
#   ) %>% 
#   group_by(tm, year) %>% 
#   summarize(
#     total_fp_pts = sum(fant_pt)
#   ) %>% 
#   filter(tm != "2TM" & tm != "3TM")) %>% 
#   head(80) %>% 
#   ggplot(aes(x = year, y = total_fp_pts, color = tm)) +
#     geom_line(size = 1)
# 
# complete_ff_data %>%
#   filter(fant_pos == "RB" | fant_pos == "Wr" | fant_pos == "TE") %>% 
#   mutate(
#     fant_pt = replace_na(fant_pt, 0)
#   ) %>% 
#   group_by(tm, year) %>% 
#   summarize(
#     total_fp_pts = sum(fant_pt)
#   ) %>% 
#   filter(tm != "2TM" & tm != "3TM") %>% 
#   slice(81:160) %>% 
#   ggplot(aes(x = year, y = total_fp_pts, color = tm)) +
#   geom_line(size = 1)
# 
#   
# View(complete_ff_data %>%
#        filter(fant_pos == "RB" | fant_pos == "Wr" | fant_pos == "TE") %>% 
#        group_by(tm, year) %>% 
#        summarize(
#          total_fp_pts = sum(fant_pt)
#        ) %>% 
#        filter(tm != "2TM" & tm != "3TM"))
# 
# View(complete_ff_data %>%
#        filter(fant_pos == "RB" | fant_pos == "Wr" | fant_pos == "TE") %>% 
#        mutate(
#          tm = str_replace_all(tm, "STL", "LAR"),
#          fant_pt = replace_na(fant_pt, 0)
#        ) %>% 
#        mutate(
#          tm = str_replace_all(tm, "SDG", "LAC")
#        ) %>% 
#        group_by(tm, year) %>% 
#        summarize(
#          total_fp_pts = sum(fant_pt)
#        ))

# Player Analysis and Possible Trends----

# Assessing fantasy potential of young players

top_young_players <- complete_ff_data %>%
  filter(year >= 2018, age <= 24) %>% 
  group_by(ply_code) %>% 
  summarize(
    player = player,
    fant_pos = fant_pos,
    tot_games = sum(g),
    total_ff_pts = sum(fant_pt),
    avg_ff_pts = total_ff_pts / tot_games
    ) %>%
  unique() %>% 
  drop_na() %>% 
  group_by(fant_pos) %>% 
  slice_max(order_by = total_ff_pts, n = 5) %>% 
  select(-ply_code)

top_young_players %>% 
  filter(fant_pos == "QB")

top_young_players %>% 
  filter(fant_pos == "RB")

top_young_players %>% 
  filter(fant_pos == "WR")

top_young_players %>% 
  filter(fant_pos == "TE")

#Most Risky QBs (most interceptions and fumbles)

complete_ff_data %>%
  filter(year >= 2015, fant_pos == "QB") %>% 
  group_by(ply_code) %>% 
  summarize(player = player,
            tot_games = sum(g),
            tot_turnovers = sum(fmb) + sum(int),
            avg_tos_per_game = tot_turnovers / tot_games) %>% 
  unique() %>% 
  ungroup(ply_code) %>% 
  select(-ply_code) %>% 
  arrange(desc(tot_turnovers)) %>% 
  head(10) %>% 
  ggplot(aes(x = reorder(player, tot_turnovers), y = tot_turnovers)) + 
  geom_bar(stat="identity", width=.5, fill="tomato3") +
  coord_flip()
  
# Positional Trends----

#QB Production
complete_ff_data %>%
  filter(vbd > 0, fant_pos == "QB") %>% 
  ggplot(aes(x = year, y = fant_pt)) +
  geom_point(size = 1) + 
  geom_jitter() +
  stat_smooth(method = "lm", col = "red") 

#Are more QBs rushing than before? 

complete_ff_data %>%
  filter(vbd > 0, fant_pos == "QB") %>% 
  ggplot(aes(x = year, y = rush_yds)) +
  geom_point(size = 1) + 
  geom_jitter() +
  stat_smooth(method = "lm", col = "red")

#Are more QBs passing than before? 

complete_ff_data %>%
  filter(vbd > 0, fant_pos == "QB") %>% 
  ggplot(aes(x = year, y = pass_yds)) +
  geom_point(size = 1) + 
  geom_jitter() +
  stat_smooth(method = "lm", col = "red")


#QBs are passing more!

#RB Production
complete_ff_data %>%
  filter(vbd > 0, fant_pos == "RB") %>% 
  ggplot(aes(x = year, y = fant_pt)) +
  geom_point(size = 1) + 
  geom_jitter() +
  stat_smooth(method = "lm", col = "red")

#Are RBs racking up more receiving yards? 
complete_ff_data %>%
  filter(vbd > 0, fant_pos == "RB") %>% 
  ggplot(aes(x = year, y = rec_yds)) +
  geom_point(size = 1) + 
  geom_jitter() +
  stat_smooth(method = "lm", col = "red")

#WR Production
complete_ff_data %>%
  filter(vbd > 0, fant_pos == "WR") %>% 
  ggplot(aes(x = year, y = fant_pt)) +
  geom_point(size = 1) + 
  geom_jitter() +
  stat_smooth(method = "lm", col = "red") 

#For PPR leagues (Points Per Reception additional scoring)
complete_ff_data %>%
  filter(vbd > 0, fant_pos == "WR") %>% 
  ggplot(aes(x = year, y = ppr)) +
  geom_point(size = 1) + 
  geom_jitter() +
  stat_smooth(method = "lm", col = "red") 

#TE Production
complete_ff_data %>%
  filter(vbd > 0, fant_pos == "TE") %>% 
  ggplot(aes(x = year, y = fant_pt)) +
  geom_point(size = 1) + 
  geom_jitter() +
  stat_smooth(method = "lm", col = "red") 

complete_ff_data %>%
  filter(vbd > 0, fant_pos == "TE") %>% 
  ggplot(aes(x = year, y = rec_yds)) +
  geom_point(size = 1) + 
  geom_jitter() +
  stat_smooth(method = "lm", col = "red")

#Receiving vs rushing for fantasy production

#rushing 
complete_ff_data %>%
  filter(rush_yds > 500) %>% 
  ggplot(aes(x = rush_yds, y = fant_pt)) +
  geom_point(size = 1) +
  stat_smooth(method = "lm", col = "red") 

#receiving
complete_ff_data %>%
  filter(rec_yds > 500) %>% 
  ggplot(aes(x = rec_yds, y = fant_pt)) +
  geom_point(size = 1) +
  stat_smooth(method = "lm", col = "blue") 

#Highest average VBD for top 10 players, at each position, over time 
data1 <- complete_ff_data %>%
  group_by(fant_pos, year) %>% 
  slice_max(order_by = vbd, n = 15) %>% 
  filter(fant_pos == "RB" || fant_pos == "WR")

data2 <- complete_ff_data %>%
  group_by(fant_pos, year) %>% 
  slice_max(order_by = vbd, n = 10) %>% 
  filter(fant_pos == "QB" || fant_pos == "TE")

vbd_data <- bind_rows(data1, data2)

vbd_data %>% 
  group_by(year, fant_pos) %>% 
  summarize(avg_vbd = mean(vbd, trim = 0.1)) %>% 
  ggplot(aes(x = year, y = avg_vbd)) +
  geom_smooth(aes(color = fant_pos), size = 1, se = FALSE) 


#CONCLUSION: RBs are the most valuable to target during fantasy drafts (non-ppr)

