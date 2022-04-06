#### Preamble ####
# Purpose: Put together a simulation of regions for the cleaned_data
# Author: Bu Xu
# Data: 30 March 2021
# Contact: bu.xu@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(haven)
library(tidyverse)
library(janitor)
library(tidyr)

#### Real data summary ####
real <- read.csv(file = "outputs/data/cleaned_data.csv")
total_num <- sum(real$num_women)

#### Simulate ####
set.seed(499)

simulated_occupancy_data <- 
  tibble('Rigion' = sample( x = c(
      'Dodoma', 'Arusha', 'Kilimanjaro', 'Tanga', 'Morogoro', 'Coast', 
          'Dar es Salaam', 'Lindi', 'Mtwara', 'Ruvuma', 'Iringa', 'Mbeya', 
          'Singida', 'Tabora', 'Rukwa', 'Kigoma', 'Shinyanga', 'Kagera', 
          'Mwanza'),
      size = 7624, 
      replace = T
    ))

simulated_occupancy_data

# Make a summary and calculate the proportion of every region
table(simulated_occupancy_data)

real["simul"] <- c(426, 395, 388, 393, 395, 387, 388, 393, 418, 400, 388, 399, 
                   417, 394, 396, 428, 413, 396, 410)

real <- real %>% 
  mutate(simu_num_not_working = round(as.numeric(not_working)* as.numeric(simul)/100))

write_csv(real, file = "outputs/data/real.csv")

