# loads cumulative data original file
gcpt_cumulative_df_original <- 
  readxl::read_xlsx(file.path(project_data_dir,
                              year_filename,
                              "input",
                              "cumulative.xlsx")) 
