#### Preamble ####
# Purpose: Clean and prepare the dataset from raw_data folder
# Author: Bu Xu
# Data: 30 March 2021
# Contact: bu.xu@mail.utoronto.ca
# License: MIT



#### Workspace setup ####
library(haven)
library(tidyverse)
library(rvest)
library(pdftools)
library(tibble)
library(pointblank)
library(testthat)

# Read in the raw data. 

download.file(url = "https://dhsprogram.com/pubs/pdf/FR83/FR83.pdf", destfile = "1996.pdf")
dhs1996 <- pdf_text("1996.pdf")
dhs1996 <- tibble(raw_data = dhs1996)


# Grab the page that is of interest 
dhs1996 <- dhs1996 %>% 
  slice(50)

# Separate the rows
dhs1996 <- dhs1996 %>% 
  separate_rows(raw_data, sep = "\\n", convert = FALSE)

# Select needed rows
dhs1996 <- dhs1996[c(13:19, 32:51, 54:57),]

# Separate the states from the data
dhs1996 <- dhs1996 %>%  
  separate(col = raw_data, 
           into = c("chara", "data"), 
           sep = "\\s{16,}", 
           remove = FALSE,
           fill = "right")

# Separate the data based on spaces, squish spaces more than one into one
dhs1996 <- dhs1996 %>% 
  mutate(data = str_squish(data)) %>%  
  tidyr::separate(col = data, 
                  into = c("not_working",
                           "self_any",
                           "self_agri",
                           "self_wild_prod",
                           "self_food_process",
                           "self_craft",
                           "self_shop_taxi",
                           "self_agri_other",
                           "others_any",
                           "others_agri",
                           "agri_selfother",
                           "missing",
                           "num_women"), 
                  sep = "\\s", 
                  remove = FALSE)

dhs1996 <- dhs1996 %>% 
  select(-raw_data, -data)

# Select values we need
dhs1996 <- dhs1996[8:26,]

dhs1996 <- dhs1996 %>% 
  rename(region = chara)

# Correct some miss-converted values to the real values
dhs1996[dhs1996 == "41,0"] <- "41.0"
dhs1996[dhs1996 == "2,7"] <- "2.7"
dhs1996[dhs1996 == "17,3"] <- "17.3"
dhs1996[dhs1996 == "3,5"] <- "3.5"
dhs1996[dhs1996 == "42,2"] <- "42.2"
dhs1996[dhs1996 == "11,9"] <- "11.9"
dhs1996[dhs1996 == "6,5"] <- "6.5"
dhs1996[dhs1996 == "4,3"] <- "4.3"
dhs1996[dhs1996 == "(I.4"] <- "0.4"
dhs1996[dhs1996 == "ll.5"] <- "11.5"
dhs1996[dhs1996 == "1(1.2"] <- "10.2"
dhs1996[dhs1996 == "I1.1"] <- "11.1"
dhs1996[dhs1996 == "4,1"] <- "4.1"
dhs1996[dhs1996 == "3,2"] <- "3.2"
dhs1996[dhs1996 == "3,2"] <- "3.2"
dhs1996[dhs1996 == "9,6"] <- "9.6"
dhs1996[dhs1996 == "I.t"] <- "1.1"
dhs1996[dhs1996 == "5,3"] <- "5.3"
dhs1996[dhs1996 == "(1.5"] <- "0.5"
dhs1996[dhs1996 == "00"] <- "0.0"
dhs1996[dhs1996 == "0.(1"| dhs1996 == "(I,0" |dhs1996 == "0,0"] <- "0.0"
dhs1996[dhs1996 == "1,8"] <- "1.8"
dhs1996[dhs1996 == "03"] <- "0.3"
dhs1996[dhs1996 == "5,3"] <- "5.3"
dhs1996[dhs1996 == "5,3"] <- "5.3"
dhs1996[dhs1996 == "152"] <- "15.2"

# Rename the regions that is unclear
dhs1996[3, 1] = " Kilimanjaro"
dhs1996[6, 1] = " Coast"
dhs1996[7, 1] = " Dar es Salaam"

# Select columns
dhs1996 <- dhs1996 %>% 
  mutate(num_not_working = round(as.numeric(not_working)* as.numeric(num_women)/100)) %>% 
  select(-self_agri_other)

# Write the dataset into inputs 
write_csv(dhs1996, file = "outputs/data/cleaned_data.csv" )


