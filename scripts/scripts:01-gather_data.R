#### Preamble ####
# Purpose: OCR or parse the PDF
# Author: Bu Xu
# Data: 30 March 2021
# Contact: bu.xu@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the DHS data of Egypt and saved it to inputs/data
# - Don't forget to gitignore it!



#### Workspace setup ####
# Use R Projects, not setwd().
library(haven)
library(tidyverse)
library(rvest)
library(pdftools)
library(tibble)

# Read in the raw data. 

download.file(url = "https://dhsprogram.com/pubs/pdf/FR83/FR83.pdf", destfile = "1996.pdf")
dhs1996 <- pdf_text("1996.pdf")
dhs1996 <- tibble(raw_data = dhs1996)











