# no operating or development
gcpt_jan_2024_summary_tables_df |>
filter(Operating == 0 & `Announced + Pre-permit + Permitted` == 0 & Construction == 0) |>
  dplyr::select(Country) |>
  dplyr::mutate(summary_text = paste0(Country, " has no operating coal plants. It also has no coal power under development.")) |>
  write_csv(file.path(project_data_dir,
                       "january_2024",
                      "no_operating_text_for_summary.csv"))

# top 10 for operating
gcpt_jan_2024_summary_tables_df |>
  arrange(desc(Operating)) |>
  dplyr::select(Country, Operating) |>
  filter(Country != "Total") |>
  dplyr::top_n(10) |>
  mutate(rank = c("first", "second", "third", "fourth", "fifth",
                  "sixth", "seventh", "eighth", "ninth", "tenth")) |>
  dplyr::mutate(summary_text = paste0(Country,
                                      " ranks ", 
                                      rank,
                                      " in terms of operating coal power capacity.")) |>
  write_csv(file.path(project_data_dir,
                      "january_2024",
                      "top10_text_for_summary.csv"))

# changes from 2023

"China",
"Indonesia",
"India",
"Vietnam",
"Japan",
"Bangladesh",
"Pakistan",
"South Korea",
"Greece",
"Zimbabwe",

# Decreased 2023
"Canada",
"Chile",
"Slovakia",
"Finland",
"Romania",
"Poland",
"Italy",
"Russia",
"United Kingdom",
"United States"

# Still has coal power capacity under consideration - change to percentage
gcpt_jan_2024_summary_tables_df |>
  dplyr::group_by(Country) |>
  dplyr::filter(Country != "Total",
                Country != "Percent China") |>
  dplyr::summarise(`All development` = `Announced + Pre-permit + Permitted` + Construction) |>
  dplyr::filter(`All development` > 0) |>
  dplyr::select(Country, `All development`) |>
  dplyr::arrange(desc(`All development`)) |>
  dplyr::mutate(summary_text = paste0(Country, " is one of 39 countries that has coal power capacity under development")) 




