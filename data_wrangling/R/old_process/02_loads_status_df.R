# loads 2014 to 2023 all status data

# Data provided by Flora in spreadsheet https://docs.google.com/spreadsheets/d/1fAqZn_3U-Nn4FSZmg2nI6PhvqWFBniOl/edit#gid=627135497 
# Here we are loading in the data for each country
gcpt_jan_2024_status_countries_df <- 
  read_excel(file.path(project_data_dir, 
                    "january_2024",
                    "Status Changes_2014-2023_Summaries.xlsx"),
                    sheet = "Country") 

# Here we are loading in the data for each region grouping - also includes global

gcpt_jan_2024_status_regions_df <- 
  read_excel(file.path(project_data_dir, 
                      "january_2024",
                      "Status Changes_2014-2023_Summaries.xlsx"),
                      sheet = "Region_excerpt")
