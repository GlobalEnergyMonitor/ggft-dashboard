# loads status over time data original file
gcpt_status_over_time_df_original <- 
  readxl::read_xlsx(file.path(project_data_dir,
                              year_filename,
                              "input",
                              "status over time.xlsx"))
