GCPT_example_data_capacity_by_status <- 
  read_excel(file.path(project_data_dir,
                       "GCPT_example_processed.xlsx"),
             sheet = "status") 

GCPT_status_data_processed <- 
GCPT_example_data_capacity_by_status |>
  mutate(`Capacity (MW)` = 
           case_when(
             Status == "retired" ~ `Capacity (MW)`*(-1),
             TRUE ~ `Capacity (MW)`
             )
         ) |>
  group_by(Country) |>
  pivot_wider(names_from = Status,
              values_from = `Capacity (MW)`) |>
  dplyr::select(Country, Year,
                operating, construction, permitted,	`pre-permit`,	
                announced, mothballed, shelved, cancelled, retired) |>
  mutate(Country = case_when(Country == "all" ~ "Global", 
                             TRUE ~ Country)) 

GCPT_status_data_processed_text <- 
  GCPT_status_data_processed |>
  filter(Year == 2023) |>
  rowwise() |>
  mutate(text = paste0(Country, 
                       " has ", 
                       format(round(operating, digits = 0), big.mark = ","),
                       " MW of operating coal power capacity and ",
                       format(round(sum(construction, permitted, `pre-permit`, announced), digits = 0), big.mark = ","), 
                             " MW under development")) |>
  dplyr::select(Country, text)
  

GCPT_status_data_processed_with_text <- 
  GCPT_status_data_processed |>
  left_join(GCPT_status_data_processed_text,
            by = "Country") |>
  write_excel_csv(file.path(project_data_dir,
                      "GCPT_status_processed_with_text.csv"))
