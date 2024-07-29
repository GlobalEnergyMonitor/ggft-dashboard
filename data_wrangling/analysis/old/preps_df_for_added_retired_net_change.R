
# tidies up and reformats the dataset we loaded in, mainly using dplyr functions, to get a dataframe with capacity added, retired and net change by country
gcpt_jan_2024_added_retired_net_change_df_countries <- 
gcpt_jan_2024_main_df |>
  dplyr::filter(Status == "Operating" | Status == "Retired") |>
  dplyr::select(Country, Year, Status, Capacity) |>
  dplyr::rename(CapacityMW = Capacity) |>
  dplyr::mutate(Capacity = CapacityMW/1000) |>
  dplyr::select(-CapacityMW) |>
  tidyr::pivot_wider(id_cols = c(Country, Year),
                     names_from = Status,
                     values_from = Capacity) |>
  dplyr::rename(Added = Operating) |>
  mutate(`Net change` = Added + Retired, .after = Year) |>
  dplyr::mutate(Global = case_when(Country == "Global" ~ TRUE,
                                   TRUE ~ FALSE)) |>
  dplyr::arrange(desc(Global), Country) |>
  dplyr::select(-Global)

# Using the country grouping list, we summarise the retired, added and net change data for each country grouping, creating a df that includes only the groups
gcpt_jan_2024_added_retired_net_change_df_country_groupings <- 
  gcpt_jan_2024_added_retired_net_change_df_countries |>
  tidyr::pivot_longer(-c(Country, Year),
                      names_to = "Status",
                      values_to = "Capacity") |>
  dplyr::left_join(country_grouping_list_long,
                   by = c("Country" = "GCPT Country Name")) |>
  dplyr::filter(Country != "Global") |>
  dplyr::group_by(Year, group, source, Status) |>
  dplyr::summarise(Capacity = sum(Capacity)) |>
  dplyr::filter(source %in% c("G7", "G20", "EU27", "OECD")) |>
  dplyr::select(-source) |>
  tidyr::pivot_wider(id_cols = c(group, Year), 
                     names_from = Status,
                     values_from = Capacity) |>
  dplyr::select(Country = group, Year, `Net change`, Added, Retired) |>
  arrange(Country, Year) 

# We join the datasets together, putting Global at the top, then the country groupings and then all countries. We then save out the data as a CSV. 
gcpt_jan_2024_added_retired_net_change_df <- 
  gcpt_jan_2024_added_retired_net_change_df_countries |>
  dplyr::filter(Country == "Global") |>
  bind_rows(gcpt_jan_2024_added_retired_net_change_df_country_groupings) |>
  bind_rows( gcpt_jan_2024_added_retired_net_change_df_countries |>
               dplyr::filter(Country != "Global")) |>
  write_csv(file.path(project_data_dir,
                      "january_2024",
                      "final",
                      "gcpt_jan_2024_added_retired_net_change.csv"))

# We create a dataset for download that references the capacity unit and rounds data to 3 decimal places, saving it out to be included with our graphic in Flourish
gcpt_jan_2024_added_retired_net_change_df |>
  dplyr::mutate(`Net change (GW)` =  round(`Net change`, digits = 3)) |>
  dplyr::mutate(`Added (GW)` =  round(Added, digits = 3)) |>
  dplyr::mutate(`Retired (GW)` =  round(Retired, digits = 3)) |>
  dplyr::select(-c(`Net change`, Added, Retired)) |>
  write_csv(file.path(project_data_dir,
                      "january_2024",
                      "final",
                      "gcpt_jan_2024_added_retired_net_change_download_data.csv")) 

# turns the dataframe into a json file, using the toJSON function from the jsonlite package
gcpt_jan_2024_added_retired_net_change_df_json <- 
  jsonlite::toJSON(gcpt_jan_2024_added_retired_net_change_df |>
                     mutate(across(everything(), as.character)),
                   simplifyDataFrame = TRUE,
                   pretty = TRUE)

# Saves out the final json file
writeLines(gcpt_jan_2024_added_retired_net_change_df_json, 
           file.path(project_data_dir,
                     "january_2024",
                     "final",
                     "gcpt_jan_2024_added_retired_net_change.json"))
