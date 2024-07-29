# loads data ticker data original file
gcpt_data_ticker_df_original <- 
  readxl::read_xlsx(file.path(project_data_dir,
                              year_filename,
                              "input",
                              "data ticker.xlsx"))