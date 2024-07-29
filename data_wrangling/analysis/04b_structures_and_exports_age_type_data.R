gcpt_age_type_df <- 
  gcpt_age_type_df_original |>
  dplyr::rename(Country = `Country/Region`) |>
  dplyr::arrange(Country, desc(`Age group`)) 


writexl::write_xlsx(gcpt_age_type_df,
                    file.path(project_data_dir,
                              year_filename,
                              "download_files",
                              paste0("gcpt_", year_filename, "_age_type.xlsx")))


# turns the dataframe into a json file, using the toJSON function from the jsonlite package
gcpt_age_type_json <- 
  jsonlite::toJSON(gcpt_age_type_df |>
                     mutate(across(everything(), as.character)),
                   simplifyDataFrame = TRUE,
                   pretty = TRUE)

# Saves out the final data as a json file, to be uploaded to the dashboard folder
writeLines(gcpt_age_type_json, 
           file.path(project_data_dir,
                     year_filename,
                     "output",
                     paste0("gcpt_", year_filename, "_age_type.json")))
