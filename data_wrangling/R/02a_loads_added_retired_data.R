# loads added and retired data original file
gcpt_added_retired_df_original <- 
  readxl::read_xlsx(file.path(project_data_dir,
                              year_filename,
                              "input",
                              "added_retired.xlsx"))
