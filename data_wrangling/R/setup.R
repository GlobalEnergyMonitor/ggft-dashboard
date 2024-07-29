# The first step here is to load the packages that we will need to work with the data and create the visualisations
library(tidyverse) # loads in tidyverse packages, used in a variety of projects
library(googlesheets4) # used to load in data from Google Spreadsheets
library(readxl) # used to load in xlsx files
library(gemplot) # loads in the gemplot package for GEM style graphics
library(jsonlite) # loads library to turn R objects into json files, needed in our dashboard
library(writexl)

# Sets scientific notation criteria
options(scipen = 999)

# sets data directory path
project_data_dir <- "~/data/dashboards/GCPT"
 
# Defines not in function in a slightly easier format for use in filter functions
`%!in%` <- Negate(`%in%`)
