
# turns NA cells into empty text strings
gcpt_country_summary_text_df_original[is.na(gcpt_country_summary_text_df_original)] <- ""
  

# turns the dataframe into a json file, using the toJSON function from the jsonlite package
gcpt_summary_text_json <- 
  jsonlite::toJSON(gcpt_country_summary_text_df_original,
                   simplifyDataFrame = TRUE,
                   pretty = TRUE)

# Saves out the final data as a json file, to be uploaded to the dashboard folder
writeLines(gcpt_summary_text_json, 
           file.path(project_data_dir,
                     year_filename,
                     "output",
                     paste0("gcpt_", year_filename, "_summary_text.json")))
