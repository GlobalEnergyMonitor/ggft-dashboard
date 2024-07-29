## NEW TICKER
## 
# operating 

gcpt_jan_2024_operating_for_ticker_df <- 
gcpt_jan_2024_status_df |>
  dplyr::select(Country, Year, Operating) |>
  dplyr::filter(Year == "2015" | Year == "2023") |>
  tidyr::pivot_wider(id_cols = Country, 
              names_from = Year,
              values_from = Operating) |>
  dplyr::mutate(CapacityChange =  `2023` - `2015`) |>
  dplyr::select(Country, Operating = `2023`, CapacityChange)

# in dev
gcpt_jan_2024_in_development_for_ticker_df <- 
  gcpt_jan_2024_status_df |>
  dplyr::mutate(`All development` =  Announced +`Pre-permit` + Permitted + Construction) |>
  dplyr::select(Country, Year, `All development`) |>
  filter(Year == "2023") |>
  dplyr::select(Country, `All development`)

gcpt_jan_2024_combined_for_ticker_df <- 
  gcpt_jan_2024_operating_for_ticker_df |>
  dplyr::left_join(gcpt_jan_2024_in_development_for_ticker_df,
            by = "Country") |>
  dplyr::select(Country, Operating, `All development`, CapacityChange)



gcpt_jan_2024_ticker_df <- 
  gcpt_jan_2024_combined_for_ticker_df |>
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
  dplyr::mutate(summary_1 = paste0("<span>{{", Operating, "}} GW<", "/", "span><br>operating coal<br>power capacity"),
                summary_1_color = "#bf532c",
                summary_2 = paste0("<span>{{", `All development`, "}} GW</span><br>coal power capacity<br> under development"),
                summary_2_color = "#f27d16",
                summary_3 = paste0("<span>", change_text_symbol, "{{", CapacityChange, "}} GW</span><br>operating coal power <br>capacity from 2015"),
                summary_3_color = change_text_colour
  ) |> 
  dplyr::mutate(Global = case_when(Country == "Global" ~ TRUE,
                                   TRUE ~ FALSE)) |>
  dplyr::arrange(desc(Global), Country) |>
  dplyr::select(-Global) |>
  dplyr::select(Country, 
                summary_1, summary_1_color,
                summary_2, summary_2_color,
                summary_3, summary_3_color) |>
  write_csv(file.path(project_data_dir,
                      "january_2024",
                      "final",
                      "gcpt_jan_2024_data_ticker.csv")) 


# turns the dataframe into a json file, using the toJSON function from the jsonlite package
data_ticker_json <- jsonlite::toJSON(gcpt_jan_2024_ticker_df,
                                     simplifyDataFrame = TRUE,
                                     pretty = TRUE)

writeLines(data_ticker_json, 
           file.path(project_data_dir,
                     "january_2024",
                     "final",
                     "gcpt_jan_2024_data_ticker.json"))

