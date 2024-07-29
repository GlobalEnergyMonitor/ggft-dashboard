# transforms country grouping list into a long dataset to be used for. joining. 
country_grouping_list_long <- 
  country_grouping_list |>
  tidyr::pivot_longer(-`GCPT Country Name`,
                      values_to = "group",
                      names_to = "source")|>
  tidyr::drop_na()

# These country groupings transformation code no longer needed, the country groupings additions are being carried out in the analysis prep code itself
# 
# gcpt_jan_2024_ticker_country_groupings_data <- 
#   gcpt_jan_2024_ticker_data |>
#   tidyr::pivot_longer(-Country, 
#                       names_to = "Status",
#                       values_to = "Capacity") |>
#   dplyr::left_join(country_grouping_list_long,
#                    by = c("Country" = "GCPT Country Name")) |>
#   dplyr::filter(Country != "Global") |>
#   dplyr::group_by(group, source, Status) |>
#   dplyr::summarise(Capacity = sum(Capacity)) |>
#   dplyr::filter(source %in% c("G7", "G20", "EU27", "OECD")) |>
#   dplyr::select(-source) |>
#   tidyr::pivot_wider(id_cols = group, 
#                      names_from = Status,
#                      values_from = Capacity) |>
#   dplyr::select(Country = group, Operating, `All development`, CapacityChange)
# 
# # 
# gcpt_jan_2024_cumulative_df_country_groupings <- 
#   gcpt_jan_2024_cumulative_df |>
#   dplyr::left_join(country_grouping_list_long,
#             by = c("Country" = "GCPT Country Name")) |>
#   dplyr::filter(Country != "Global") |>
#   dplyr::group_by(Year, group, source) |>
#   dplyr::summarise(Capacity = sum(Capacity)) |>
#   dplyr::filter(source %in% c("G7", "G20", "EU27", "OECD")) |>
#   dplyr::select(Country = group, Year, Capacity) |>
#   arrange(Country, Year)
#   




 






