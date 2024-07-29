gcpt_jan_2024_operating_indevelopment <-
  gcpt_jan_2024_summary_tables_df |>
  dplyr::filter(Country != "Percent China") |>
  dplyr::mutate(Country = case_when(Country == "Total" ~ "Global",
                                    TRUE ~ Country)) |>
  dplyr::mutate(`All development` = Announced +`Pre-permit` + Permitted + Construction) |>
  dplyr::select(Country, Operating, `All development`) |>
  dplyr::mutate(Operating = Operating/1000,
         `All development` = (`All development`)/1000)

gcpt_jan_2024_cumulative_change_from_2015 <- 
  gcpt_jan_2024_main_df |>
  dplyr::filter(Year == 2023 & Status == "Cumulative") |>
  dplyr::rename(Capacity2023 = Capacity) |>
  dplyr::select(-Year, -Status) |>
  dplyr::left_join(gcpt_jan_2024_main_df |>
              dplyr::filter(Year == 2015 & Status == "Cumulative") |>
              dplyr::rename(Capacity2015 = Capacity) |>
              dplyr::select(-Year, -Status),
            by = "Country") |>
  dplyr::mutate(CapacityChange = (Capacity2023 - Capacity2015)/1000) |>
  dplyr::select(Country, CapacityChange)

gcpt_jan_2024_ticker_data <- 
gcpt_jan_2024_operating_indevelopment |>
  dplyr::left_join(gcpt_jan_2024_cumulative_change_from_2015,
            by = "Country") 

gcpt_jan_2024_ticker_df <-
  gcpt_jan_2024_ticker_data |>
  dplyr::mutate(change_text_colour = case_when(CapacityChange > 0 ~ "#761200", 
                                        CapacityChange < 0 ~ "#3F6950", 
                                        CapacityChange == 0 ~ "#A8A8A8",
                                        TRUE ~ "#000000"),
                change_text_symbol = case_when(CapacityChange > 0 ~ "+",
                                               TRUE ~ "")) |>
  dplyr::mutate(Operating = case_when(Operating >= 10 ~  round(Operating, digits = 0), 
                                      Operating < 10 & Operating >= 1 ~  round(Operating, digits = 1),
                                      Operating < 1 & Operating > 0 ~  round(Operating, digits = 2),
                                      TRUE ~ Operating),
                `All development` = case_when( `All development` >= 10 ~  round( `All development`, digits = 0), 
                                               `All development` < 10 &  `All development` >= 1 ~  round( `All development`, digits = 1),
                                               `All development` < 1 &  `All development` > 0 ~  round( `All development`, digits = 2),
                                               TRUE ~  `All development`),
                CapacityChange = case_when(CapacityChange >= 10 ~  round(CapacityChange, digits = 0), 
                                           CapacityChange < 10 & CapacityChange >= 1 ~  round(CapacityChange, digits = 1),
                                           CapacityChange < 1 & CapacityChange > 0 ~  round(CapacityChange, digits = 2),
                                           CapacityChange <= -10 ~ round(CapacityChange, digits = 0),
                                           CapacityChange > -10 & CapacityChange <= -1 ~  round(CapacityChange, digits = 1),
                                           CapacityChange > -1 & CapacityChange < 0 ~  round(CapacityChange, digits = 2),
                                           TRUE ~ CapacityChange)) |>
  dplyr::mutate(summary_1 = paste0("<span>{{", Operating, "}} GW<", "/", "span><br>operating coal power capacity"),
         summary_1_color = "#bf532c",
         summary_2 = paste0("<span>{{", `All development`, "}} GW</span><br>coal power under development"),
         summary_2_color = "#f27d16",
         summary_3 = paste0("<span>", change_text_symbol, "{{", CapacityChange, "}} GW</span><br>operating coal power from 2015"),
         summary_3_color = change_text_colour
         ) |> 
  dplyr::mutate(Global = case_when(Country == "Global" ~ TRUE,
                                  TRUE ~ FALSE)) |>
  dplyr::arrange(desc(Global), Country) |>
  dplyr::select(-Global) |>
  dplyr::select(Country, 
                summary_1, summary_1_color,
                summary_2, summary_2_color,
                summary_3, summary_3_color)
         
  
# turns the dataframe into a json file, using the toJSON function from the jsonlite package
data_ticker_json <- jsonlite::toJSON(gcpt_jan_2024_ticker_df,
                                       simplifyDataFrame = TRUE,
                                       pretty = TRUE)

writeLines(data_ticker_json, 
           file.path(project_data_dir,
                     "january_2024",
                     "data_ticker_for_flourish.json"))
  
gcpt_jan_2024_ticker_country_groupings_df <-
  gcpt_jan_2024_ticker_country_groupings_data |>
  dplyr::mutate(change_text_colour = case_when(CapacityChange > 0 ~ "#761200", 
                                               CapacityChange < 0 ~ "#3F6950", 
                                               CapacityChange == 0 ~ "#A8A8A8",
                                               TRUE ~ "#000000"),
                change_text_symbol = case_when(CapacityChange > 0 ~ "+",
                                               TRUE ~ "")) |>
  dplyr::mutate(Operating = case_when(Operating >= 10 ~  round(Operating, digits = 0), 
                                      Operating < 10 & Operating >= 1 ~  round(Operating, digits = 1),
                                      Operating < 1 & Operating > 0 ~  round(Operating, digits = 2),
                                               TRUE ~ Operating),
                `All development` = case_when( `All development` >= 10 ~  round( `All development`, digits = 0), 
                                      `All development` < 10 &  `All development` >= 1 ~  round( `All development`, digits = 1),
                                      `All development` < 1 &  `All development` > 0 ~  round( `All development`, digits = 2),
                                      TRUE ~  `All development`),
                CapacityChange = case_when(CapacityChange >= 10 ~  round(CapacityChange, digits = 0), 
                                           CapacityChange < 10 & CapacityChange >= 1 ~  round(CapacityChange, digits = 1),
                                           CapacityChange < 1 & CapacityChange > 0 ~  round(CapacityChange, digits = 2),
                                           CapacityChange <= -10 ~ round(CapacityChange, digits = 0),
                                           CapacityChange > -10 & CapacityChange >= -1 ~  round(CapacityChange, digits = 1),
                                           CapacityChange > -1 & CapacityChange < 0 ~  round(CapacityChange, digits = 2),
                                      TRUE ~ CapacityChange)) |>
  
  dplyr::mutate(summary_1 = paste0("<span>{{", Operating, "}} GW<", "/", "span><br>operating coal power capacity"),
                summary_1_color = "#bf532c",
                summary_2 = paste0("<span>{{", `All development`, "}} GW</span><br>coal power under development"),
                summary_2_color = "#f27d16",
                summary_3 = paste0("<span>", change_text_symbol, "{{", CapacityChange, "}} GW</span><br>operating coal power from 2015"),
                summary_3_color = change_text_colour
  ) |> 
  dplyr::select(Country, 
                summary_1, summary_1_color,
                summary_2, summary_2_color,
                summary_3, summary_3_color)

gcpt_jan_2024_ticker_df_with_country_groupings <- 
  gcpt_jan_2024_ticker_df |>
  dplyr::filter(Country == "Global") |>
  dplyr::bind_rows(gcpt_jan_2024_ticker_country_groupings_df) |>
  dplyr::bind_rows(gcpt_jan_2024_ticker_df |>
                     dplyr::filter(Country != "Global"))

# turns the dataframe into a json file, using the toJSON function from the jsonlite package
data_ticker_with_country_groupings_json <- jsonlite::toJSON(gcpt_jan_2024_ticker_df_with_country_groupings,
                                     simplifyDataFrame = TRUE,
                                     pretty = TRUE)

writeLines(data_ticker_with_country_groupings_json, 
           file.path(project_data_dir,
                     "january_2024",
                     "data_ticker_with_country_groupings_for_flourish.json"))
