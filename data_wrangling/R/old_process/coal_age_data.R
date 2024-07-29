GCPT_age_data <- 
  read_excel(file.path(project_data_dir,
                       "GCPT_example_processed.xlsx"),
             sheet = "age")  |>
  dplyr::select(-`Subcritical/ccs`)

GCPT_age_data_all_countries <- 
  GCPT_age_data |>
  filter(Country != "all") |>
  arrange(Country, desc(decade)) 

GCPT_age_data_processed <- 
  GCPT_age_data |>
  filter(Country == "all") |>
  mutate(Country = case_when(Country == "all" ~ "Global", 
                             TRUE ~ Country)) |>
  arrange(desc(decade)) |>
  bind_rows(GCPT_age_data_all_countries) |>
  dplyr::select(Country, decade, `Ultra-supercritical`,	Supercritical, Subcritical, CFB, IGCC, Unknown) 

countries_with_zero <- 
  GCPT_age_data_processed |>
  select(-decade) |>
  pivot_longer(-c(Country),
               names_to = "Type",
               values_to = "Value")  |>
  group_by(Country) |>
  summarise(total = sum(Value)) |>
  filter(total == 0) 

countries_with_zero_list <- 
  countries_with_zero |>
  pull(Country)

GCPT_age_data_processed_text <- 
  GCPT_age_data_processed |>
  filter(Country %!in% countries_with_zero_list) |>
  pivot_longer(-c(Country, decade),
               names_to = "Type",
               values_to = "Value") |>
  group_by(Country, decade) |>
  summarise(total = sum(Value)) |>
  ungroup() |>
  arrange(Country, desc(total)) |>
  group_by(Country) |>
  filter(row_number()==1) |>
  mutate(text = paste0("The largest share of coal power in ", Country, " is ", decade, " old")) |>
  select(Country, text)
 
countries_with_zero_with_text <-  
countries_with_zero |>
  dplyr::select(-total) |>
  mutate(text = paste0(Country, " does not have any operating coal power"))

GCPT_age_data_processed_text_all <- 
  GCPT_age_data_processed_text |>
  bind_rows(countries_with_zero_with_text)


GCPT_age_data_processed_with_text <- 
  GCPT_age_data_processed |>
  left_join(GCPT_age_data_processed_text_all, 
            by = "Country") |>
  write_excel_csv(file.path(project_data_dir,
                            "GCPT_age_data_processed_with_text.csv"))
