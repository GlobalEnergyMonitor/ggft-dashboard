gcpt_jan_2024_raw_units_df <- 
  readxl::read_xlsx(file.path(project_data_dir,
                            "january_2024",
                            "Total operating coal capacity_cumulative coal capacity by year.xlsx"),
                          sheet = "units")
  