
# tidies up and reformats the dataset we loaded in, mainly using dplyr functions, and then saves out a csv file
gcpt_jan_2024_cumulative_df <- 
  gcpt_jan_2024_main_df |>
  dplyr::filter(Status == "Cumulative") |>
  dplyr::select(Country, Year, Capacity) |>
  dplyr::rename(CapacityMW = Capacity) |>
  dplyr::mutate(Capacity = CapacityMW/1000) |>
  dplyr::mutate(Global = case_when(Country == "Global" ~ TRUE,
                                   TRUE ~ FALSE)) |>
  dplyr::arrange(desc(Global), Country) |>
  dplyr::select(-Global, - CapacityMW) |>
  write_csv(file.path(project_data_dir,
                      "january_2024",
                      "gcpt_jan_2024_cumulative_for_flourish.csv"))


  
# turns the dataframe into a json file, using the toJSON function from the jsonlite package
  gcpt_jan_2024_cumulative_json <- jsonlite::toJSON(gcpt_jan_2024_cumulative_df |>
                                                      mutate(across(everything(), as.character)),
                                                    simplifyDataFrame = TRUE,
                                                    pretty = TRUE)
  
writeLines(gcpt_jan_2024_cumulative_json, 
             file.path(project_data_dir,
                       "january_2024",
                       "gcpt_jan_2024_cumulative_for_flourish.json"))
  

gcpt_jan_2024_cumulative_df_with_country_groupings  <- 
  gcpt_jan_2024_cumulative_df |>
  dplyr::filter(Country == "Global") |>
  bind_rows(gcpt_jan_2024_cumulative_df_country_groupings) |>
  bind_rows( gcpt_jan_2024_cumulative_df |>
               dplyr::filter(Country != "Global")) |>
  write_csv(file.path(project_data_dir,
                      "january_2024",
                      "gcpt_jan_2024_cumulative_with_country_groupings_for_flourish.csv"))



# turns the dataframe into a json file, using the toJSON function from the jsonlite package
gcpt_jan_2024_cumulative_df_with_country_groupings_json <- 
  jsonlite::toJSON(gcpt_jan_2024_cumulative_df_with_country_groupings |>
                                                    mutate(across(everything(), as.character)),
                                                  simplifyDataFrame = TRUE,
                                                  pretty = TRUE)

writeLines(gcpt_jan_2024_cumulative_df_with_country_groupings_json, 
           file.path(project_data_dir,
                     "january_2024",
                     "gcpt_jan_2024_cumulative_with_country_groupings_for_flourish.json"))

