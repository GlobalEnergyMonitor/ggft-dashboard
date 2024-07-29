coal_cumulative_original <- 
  read_csv(file.path(project_data_dir, 
                          "coal_cumulative_for_flourish_dropdown.csv"))

countries_with_zero_all_years <-
  coal_cumulative_original |>
  group_by(Country) |>
  summarise(total = sum(Capacity)) |>
  filter(total == 0) |>
  pull(Country)

coal_2000 <- 
  coal_cumulative_original |>
  filter(Year == 2000) |>
  select(Country, Capacity_2000 = Capacity)


coal_2023 <- 
  coal_cumulative_original |>
  filter(Year == 2023) |>
  select(Country, Capacity_2023 = Capacity)

coal_capacity_change_2000_2023_full <- 
  coal_2000 |>
  left_join(coal_2023,
            by = "Country") |>
  mutate(diff_2000 = Capacity_2023 -Capacity_2000,
         factor_diff_2000 = Capacity_2023/Capacity_2000) |>
  mutate(description = case_when(
    Country %in% countries_with_zero_all_years ~ "has no operating coal power",
    diff_2000 > 0 & Capacity_2000 == 0 ~ "added coal power capacity since 2000",
    diff_2000 < 0 & Capacity_2023 == 0 ~ "retired all its coal power capacity from 2000",
    diff_2000 < 0 & factor_diff_2000 < 1 & factor_diff_2000 > 0.5 ~ "reduced its coal power capacity from 2000",
    diff_2000 < 0 & factor_diff_2000 < 0.5 ~ "more than halved its coal power capacity from 2000",
    diff_2000 == 0 ~ "has the same coal power capacity as it did in 2000",
    diff_2000 > 0 & factor_diff_2000 < 1.9 ~ "increased its coal power capacity from 2000",
    diff_2000 > 0 & factor_diff_2000 > 1.9 & factor_diff_2000 < 2  ~ "almost doubled its coal power capacity from 2000",
    diff_2000 > 0 & factor_diff_2000 > 2  ~ "more than doubled its coal power capacity from 2000",
    TRUE ~ NA
  ))

coal_capacity_change_2000_2023_for_join <- 
  coal_capacity_change_2000_2023_full |>
  dplyr::select(Country, description)

coal_cumulative_joined <- 
  coal_cumulative_original |>
  left_join(coal_capacity_change_2000_2023_for_join,
            by = "Country") 

coal_cumulative_joined_global <- 
  coal_cumulative_joined |>
  filter(Country == "Global") |>
  mutate(description = "coal capacity has almost doubled from 2000")

coal_cumulative_processed <- 
coal_cumulative_joined_global |>
  bind_rows(coal_cumulative_joined |>
  filter(Country != "Global"))|>
  readr::write_csv(file.path(project_data_dir, 
                          "coal_cumulative_for_flourish_dropdown_processed.csv"))
