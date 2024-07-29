# step 1 - load all countries and create a df to match up on
country_names_list <- 
  readr::read_csv(file.path(project_data_dir, 
                   "country_list.csv"))
# step 2 - loads the country grouping list, with details about OECD, EU27 and other country groupings
country_grouping_list <- 
  readxl::read_excel(file.path(project_data_dir,
                            "gcpt_country_groupings_gem.xlsx")) 
