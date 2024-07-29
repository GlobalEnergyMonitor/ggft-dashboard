
gcpt_data_ticker_df <- 
  gcpt_data_ticker_df_original |>
  dplyr::rename(Country = `Country/Region`) |>
  dplyr::mutate(change_text_colour = case_when(change_in_operating_from_2015 > 0 ~ "#761200", 
                                               change_in_operating_from_2015 < 0 ~ "#3F6950", 
                                               change_in_operating_from_2015 == 0 ~ "#A8A8A8",
                                               TRUE ~ "#000000"),
                change_text_symbol = case_when(change_in_operating_from_2015 > 0 ~ "+",
                                               TRUE ~ "")) |>
  dplyr::mutate(operating = case_when(operating >= 10 ~  round(operating, digits = 0), 
                                      operating < 10 & operating >= 1 ~  round(operating, digits = 1),
                                      operating < 1 & operating > 0 ~  round(operating, digits = 2),
                                      TRUE ~ operating),
                under_development = case_when(under_development >= 10 ~  round(under_development, digits = 0), 
                                              under_development < 10 &  under_development >= 1 ~  round(under_development, digits = 1),
                                              under_development < 1 &  under_development > 0 ~  round(under_development, digits = 2),
                                               TRUE ~  under_development),
                change_in_operating_from_2015 = case_when(change_in_operating_from_2015 >= 10 ~  round(change_in_operating_from_2015, digits = 0), 
                                                          change_in_operating_from_2015 < 10 & change_in_operating_from_2015 >= 1 ~  round(change_in_operating_from_2015, digits = 1),
                                                          change_in_operating_from_2015 < 1 & change_in_operating_from_2015 > 0 ~  round(change_in_operating_from_2015, digits = 2),
                                                          change_in_operating_from_2015 <= -10 ~ round(change_in_operating_from_2015, digits = 0),
                                                          change_in_operating_from_2015 > -10 & change_in_operating_from_2015 <= -1 ~  round(change_in_operating_from_2015, digits = 1),
                                                          change_in_operating_from_2015 > -1 & change_in_operating_from_2015 < 0 ~  round(change_in_operating_from_2015, digits = 2),
                                           TRUE ~ change_in_operating_from_2015)) |>
  dplyr::mutate(summary_1 = paste0("<span>{{", operating, "}} GW<", "/", "span><br>operating coal<br>power capacity"),
                summary_1_color = "#bf532c",
                summary_2 = paste0("<span>{{", under_development, "}} GW</span><br>coal power capacity<br> under development"),
                summary_2_color = "#f27d16",
                summary_3 = paste0("<span>", change_text_symbol, "{{", change_in_operating_from_2015, "}} GW</span><br>operating coal power <br>capacity from 2015"),
                summary_3_color = change_text_colour
  ) |> 
  dplyr::select(Country, 
                summary_1, summary_1_color,
                summary_2, summary_2_color,
                summary_3, summary_3_color) 


# turns the dataframe into a json file, using the toJSON function from the jsonlite package
data_ticker_json <- jsonlite::toJSON(gcpt_data_ticker_df,
                                     simplifyDataFrame = TRUE,
                                     pretty = TRUE)

writeLines(data_ticker_json, 
           file.path(project_data_dir,
                     year_filename,
                     "output",
                     paste0("gcpt_", year_filename, "_data_ticker.json")))
