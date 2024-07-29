
# Clean up the column names 
colnames(gcpt_jan_2024_status_countries_df) <- 
  c("Country", "Status", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023")

colnames(gcpt_jan_2024_status_regions_df) <- 
  c("Country", "Status", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023")

# filters the Global total df from the region groupings, so that we can have it at the top
gcpt_jan_2024_status_global_df <- 
  gcpt_jan_2024_status_regions_df |>
  dplyr::filter(Country == "Global")

# filters the four country groupings we are using, EU27, G7, G20 and OECD
gcpt_jan_2024_status_country_grouping_df <- 
  gcpt_jan_2024_status_regions_df |>
  dplyr::filter(Country %in% c("EU27", "G7", "G20", "OECD"))

# combines all togther, starting with the global df and then joining the countries and country groupings data, turning the data into GW and reshaping them. 
gcpt_jan_2024_status_df <- 
  gcpt_jan_2024_status_global_df |>
  dplyr::bind_rows(gcpt_jan_2024_status_countries_df) |>
  dplyr::bind_rows(gcpt_jan_2024_status_country_grouping_df) |>
  tidyr::pivot_longer(-c(Country, Status),
               names_to = "Year",
               values_to = "CapacityMW") |>
  dplyr::mutate(Capacity = CapacityMW/1000) |>
  dplyr::select(-CapacityMW) |>
  tidyr::pivot_wider(id_cols = c(Country, Year),
              names_from = Status,
              values_from = Capacity) |>
  dplyr::select(Country, Year, Retired, Operating, Mothballed, Construction,  Permitted, `Pre-permit`, Announced, Shelved, Cancelled) |>
 write_csv(file.path(project_data_dir,
                      "january_2024",
                     "final",
                      "gcpt_jan_2024_status.csv"))

# Renames each relevant numeric column to indicate the capacity unit and rounds to 3 decimal places, exporting a file to make available for download
gcpt_jan_2024_status_df |>
  dplyr::mutate(`Retired (GW)` =  round(Retired, digits = 3)) |>
  dplyr::mutate(`Operating (GW)` =  round(Operating, digits = 3)) |>
  dplyr::mutate(`Mothballed (GW)` =  round(Mothballed, digits = 3)) |>
  dplyr::mutate(`Construction (GW)` =  round(Construction, digits = 3)) |>
  dplyr::mutate(`Permitted (GW)` =  round(Permitted, digits = 3)) |>
  dplyr::mutate(`Pre-permit (GW)` =  round(`Pre-permit`, digits = 3)) |>
  dplyr::mutate(`Announced (GW)` =  round(Announced, digits = 3)) |>
  dplyr::mutate(`Shelved (GW)` =  round(Shelved, digits = 3)) |>
  dplyr::mutate(`Cancelled (GW)` =  round(Cancelled, digits = 3)) |>
  dplyr::select(-c(Retired, Operating, Mothballed, 
                   Construction, Permitted, `Pre-permit`, Announced,
                   Shelved, Cancelled)) |>
  write_csv(file.path(project_data_dir,
                      "january_2024",
                      "final",
                      "gcpt_jan_2024_status_download_data.csv")) 


# turns the dataframe into a json file, using the toJSON function from the jsonlite package
gcpt_jan_2024_status_df_json <- 
  jsonlite::toJSON(gcpt_jan_2024_status_df |>
                     mutate(across(everything(), as.character)),
                   simplifyDataFrame = TRUE,
                   pretty = TRUE)

writeLines(gcpt_jan_2024_status_df_json, 
           file.path(project_data_dir,
                     "january_2024",
                     "final",
                     "gcpt_jan_2024_status.json"))
