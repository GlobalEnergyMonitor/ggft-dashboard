# loads age and type data original file
gcpt_age_type_df_original <- 
  readxl::read_xlsx(file.path(project_data_dir,
                              year_filename,
                              "input",
                              "plant age_type.xlsx"))
