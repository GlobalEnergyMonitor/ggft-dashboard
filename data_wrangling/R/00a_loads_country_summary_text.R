# loads country text data original file
gcpt_country_summary_text_df_original <- 
  readxl::read_xlsx(file.path(project_data_dir,
                              year_filename,
                              "input",
                              "summary_text.xlsx")) 
