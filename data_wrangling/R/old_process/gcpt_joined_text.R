
GCPT_cumulative_processed_text_unique <-
  coal_cumulative_processed |>
  select(Country, cumulative_text = description) |>
  unique()

GCPT_change_processed_text_unique <-
  GCPT_change_processed_with_text |>
  select(Country, change_text = description) |>
  unique()

GCPT_status_data_text_unique <- 
  GCPT_status_data_processed_with_text |>
  select(Country, status_text = text) |>
  unique()

GCPT_age_data_processed_text_unique <- 
  GCPT_age_data_processed_with_text |>
  select(Country, age_text = text) |>
  unique()


# combining them all together 
GCPT_text_joined_unique <-
GCPT_cumulative_processed_text_unique |>
  left_join(GCPT_change_processed_text_unique,
            by = "Country") |>
  left_join(GCPT_status_data_text_unique,
            by = "Country") |>
  left_join(GCPT_age_data_processed_text_unique,
            by = "Country") |>
  write_excel_csv(file.path(project_data_dir,
                            "GCPT_text_all_joined.csv"))
