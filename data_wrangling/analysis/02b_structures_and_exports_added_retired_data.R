gcpt_added_retired_df <- 
  gcpt_added_retired_df_original |>
  dplyr::rename(Country = `Country/Region`) |>
  dplyr::mutate(Year = as.character(Year)) |>
  dplyr::mutate(Year = stringr::str_replace(Year, pattern = full_year, replacement = year_variable))


  writexl::write_xlsx(gcpt_added_retired_df,
                      file.path(project_data_dir,
                                year_filename,
                                "download_files",
                                paste0("gcpt_", year_filename, "_added_retired.xlsx")))


# turns the dataframe into a json file, using the toJSON function from the jsonlite package
gcpt_added_retired_json <- 
  jsonlite::toJSON(gcpt_added_retired_df |>
                     mutate(across(everything(), as.character)),
                   simplifyDataFrame = TRUE,
                   pretty = TRUE)

# Saves out the final data as a json file, to be uploaded to the dashboard folder
writeLines(gcpt_added_retired_json, 
           file.path(project_data_dir,
                     year_filename,
                     "output",
                     paste0("gcpt_", year_filename, "_added_retired.json")))
