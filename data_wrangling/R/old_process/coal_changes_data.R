GCPT_change_processed <- 
  read_excel(file.path(project_data_dir,
                       "GCPT_example_processed.xlsx"),
  sheet = "additions") |>
  dplyr::select(Country, Year, `Net change` = `Net added (MW)`, Added = `Added (MW)`, Retired = `Retired (MW)`) |>
  mutate(Country = case_when(Country == "all" ~ "Global", 
                             TRUE ~ Country)) 

# create categories 
# - 0 in every year neither added or retired any coal since 2000
# all above 0: "added more coal than it retired every year since 2000"
# all 0 or below - not added coal 
# all 0 or above, not retired any coal since 2000

GCPT_change_processed_with_text <- 
  GCPT_change_processed |>
  group_by(Country) |>
mutate(description = case_when(
  all(Added == 0) & all(Retired == 0) ~ "neither added or retired any coal",
  all(Added <= 0) ~ "has not added any coal since 2000",
  all(Retired <= 0) ~ "has not retired any coal since 2000",
  all(`Net change` > 0) ~ "added more coal than it retired every year since 2000",
  TRUE ~ paste0("Need to develop a sentence for ", Country) 
)) |>
  mutate(Retired = Retired*-1)


GCPT_change_processed_with_text |>
  write_excel_csv(file.path(project_data_dir, 
                           "coal_change_for_flourish_dropdown_processed.csv"))
