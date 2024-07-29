# takes raw data and creates an age group column with the relevant age brackets needed, then summarising the data to total by country, age group bracket and technology type - as well as turning capacity into gigawtts
gcpt_jan_2024_plant_age_type_by_country_df <- 
  gcpt_jan_2024_plant_age_type_raw_df |>
  dplyr::mutate(`Age group` = case_when(`Plant Age` < 10 ~ "0-9 years",
                                 `Plant Age` >= 10 & `Plant Age` < 20 ~ "10-19 years",
                                 `Plant Age` >= 20 & `Plant Age` < 29 ~ "20-29 years",
                                 `Plant Age` >= 30 & `Plant Age` < 40 ~ "30-39 years",
                                 `Plant Age` >= 40 & `Plant Age` < 50 ~ "40-49 years",
                                 `Plant Age` >= 50 ~ "50+ years",
                                 TRUE ~ NA)) |>
  dplyr::group_by(Country, `Age group`, `Combustion technology`) |>
  dplyr::summarise(Capacity = sum(`Capacity (MW)`/1000))|>
  arrange(Country, desc(`Age group`))

# Creates a global total for age and technology type, same method as code above. 
gcpt_jan_2024_plant_age_type_by_global_df <- 
  gcpt_jan_2024_plant_age_type_raw_df |>
  dplyr::mutate(`Age group` = case_when(`Plant Age` < 10 ~ "0-9 years",
                                 `Plant Age` >= 10 & `Plant Age` < 20 ~ "10-19 years",
                                 `Plant Age` >= 20 & `Plant Age` < 29 ~ "20-29 years",
                                 `Plant Age` >= 30 & `Plant Age` < 40 ~ "30-39 years",
                                 `Plant Age` >= 40 & `Plant Age` < 50 ~ "40-49 years",
                                 `Plant Age` >= 50 ~ "50+ years",
                                 TRUE ~ NA)) |>
  dplyr::group_by(`Age group`, `Combustion technology`) |>
  dplyr::summarise(Capacity = sum(`Capacity (MW)`/1000)) |>
  dplyr::mutate(Country = "Global", .before = 1) |>
  arrange(desc(`Age group`))

# Turns any NAs to 0 to clean up the data and remove that which doesnt include an age and tech type. 
gcpt_jan_2024_plant_age_type_df <- 
  gcpt_jan_2024_plant_age_type_by_global_df |>
  dplyr::bind_rows(gcpt_jan_2024_plant_age_type_by_country_df) |>
  tidyr::pivot_wider(id_cols = c(Country, `Age group`),
                     names_from = `Combustion technology`,
                     values_from = Capacity) |>
  mutate_if(is.numeric, funs(ifelse(is.na(.), 0, .))) 

gcpt_jan_2024_plant_age_type_df_clean <-
  gcpt_jan_2024_plant_age_type_df[rowSums(is.na(gcpt_jan_2024_plant_age_type_df)) == 0, ]


country_names_list_colnames <- 
  colnames(gcpt_jan_2024_plant_age_type_df_clean |> 
             dplyr::select(-Country)) 

country_names_list[,country_names_list_colnames] <- NA

country_names_list[is.na(country_names_list)] <- 0

# From the country list, finds the country that do not have any entries in this data, suggesting they have no operating coal plants. We need to identify them here in order to make sure they are included in the chart, so it shows an empty chart
missing_countries_to_join_age_data <- 
  anti_join(country_names_list,
          gcpt_jan_2024_plant_age_type_df_clean, 
          by = "Country")

# Creastes 6 rows for each country and matches the age groups, one for each row as in our main dataset
missing_countries_to_join_age_data <- 
  missing_countries_to_join_age_data[rep(seq_len(nrow(missing_countries_to_join_age_data)), 
                                       each = 6), ]
missing_countries_to_join_age_data$`Age group` <- 
  rep(c(
"0-9 years",
"10-19 years",
"20-29 years",
"30-39 years",
"40-49 years",
"50+ years"), 
times = length(unique(missing_countries_to_join_age_data$Country)))

# Takes our dataset created above and adds the missing coutnries df we created and formatted above, so that we have a complete dataset. We also created a global column so that we can order and move global to the top. 
gcpt_jan_2024_plant_age_type_df_clean_final <-
  gcpt_jan_2024_plant_age_type_df_clean |>
  bind_rows(missing_countries_to_join_age_data) |>
   dplyr::select(Country, 
                `Age group`,
                "Ultra-supercritical" = `Ultra-Supercritical`,
                Supercritical,
                Subcritical,
                CFB,
                IGCC,
                Unknown) |>
  dplyr::mutate(Global = case_when(Country == "Global" ~ TRUE,
                                   TRUE ~ FALSE)) |>
  dplyr::arrange(desc(Global), Country) |>
  dplyr::select(-Global) 

# 
# # turns the dataframe into a json file, using the toJSON function from the jsonlite package
# gcpt_jan_2024_plant_age_type_df_clean_final_json <- jsonlite::toJSON(gcpt_jan_2024_plant_age_type_df_clean_final |>
#                                                     mutate(across(everything(), as.character)),
#                                                   simplifyDataFrame = TRUE,
#                                                   pretty = TRUE)
# 
# writeLines(gcpt_jan_2024_plant_age_type_df_clean_final_json, 
#            file.path(project_data_dir,
#                      "january_2024",
#                      "gcpt_jan_2024_plant_age_type_for_flourish.json"))

# We can now create a dataset with the country groupings we need by summarising the totals for the different countries based on the groupings they are in. We use the original groupings list we have loaded in an earlier step
# 
gcpt_jan_2024_plant_age_type_df_country_groupings <- 
gcpt_jan_2024_plant_age_type_df_clean_final |>
  tidyr::pivot_longer(-c(Country, `Age group`),
                      names_to = "Status",
                      values_to = "Capacity") |>
  dplyr::left_join(country_grouping_list_long,
                   by = c("Country" = "GCPT Country Name")) |>
  dplyr::filter(Country != "Global") |>
  dplyr::group_by(`Age group`, group, source, Status) |>
  dplyr::summarise(Capacity = sum(Capacity)) |>
  dplyr::filter(source %in% c("G7", "G20", "EU27", "OECD")) |>
  dplyr::select(-source) |>
  tidyr::pivot_wider(id_cols = c(group,  `Age group`),
                     names_from = Status,
                     values_from = Capacity) |>
  dplyr::select(Country = group, `Age group`,
                `Ultra-supercritical`, Supercritical, Subcritical, CFB, IGCC, Unknown) |>
  arrange(Country, desc(`Age group`))

# We then join the data together, taking the country dataset that includes global, binding the country groupings data to it and filtering out the global capacity we created to avoid having it in twice
gcpt_jan_2024_plant_age_type_final_df <- 
  gcpt_jan_2024_plant_age_type_df_clean_final |>
  dplyr::filter(Country == "Global") |>
  dplyr::bind_rows(gcpt_jan_2024_plant_age_type_df_country_groupings) |>
  dplyr::bind_rows(gcpt_jan_2024_plant_age_type_df_clean_final |>
                     dplyr::filter(Country != "Global")) |>
  write_csv(file.path(project_data_dir,
                      "january_2024",
                      "final",
                      "gcpt_jan_2024_plant_age_type.csv")) 



gcpt_jan_2024_plant_age_type_final_df |>
  dplyr::mutate(`Ultra-supercritical (GW)` =  round(`Ultra-supercritical`, digits = 3)) |>
  dplyr::mutate(`Supercritical (GW)` =  round(Supercritical, digits = 3)) |>
  dplyr::mutate(`Subcritical (GW)` =  round(Subcritical, digits = 3)) |>
  dplyr::mutate(`CFB (GW)` =  round(CFB, digits = 3)) |>
  dplyr::mutate(`IGCC (GW)` =  round(IGCC, digits = 3)) |>
  dplyr::mutate(`Unknown (GW)` =  round(Unknown, digits = 3)) |>
  dplyr::select(-c(`Ultra-supercritical`, 
                   Supercritical,
                   Subcritical,
                   CFB,
                   IGCC,
                   Unknown)) |>
  write_csv(file.path(project_data_dir,
                      "january_2024",
                      "final",
                      "gcpt_jan_2024_age_type_download_data.csv")) 


# turns the dataframe into a json file, using the toJSON function from the jsonlite package
gcpt_jan_2024_plant_age_type_final_json <- 
  jsonlite::toJSON(gcpt_jan_2024_plant_age_type_final_df,
                   simplifyDataFrame = TRUE,
                   pretty = TRUE)

writeLines(gcpt_jan_2024_plant_age_type_final_json, 
           file.path(project_data_dir,
                     "january_2024",
                     "final",
                     "gcpt_jan_2024_plant_age_type.json"))
