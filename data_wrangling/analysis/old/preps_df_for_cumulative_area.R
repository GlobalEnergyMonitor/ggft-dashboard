gcpt_jan_2024_units_long_df <- 
  gcpt_jan_2024_raw_units_df |>
  dplyr::select(`Plant name`, Country, Region, OECD, Region, G20, G7, `Capacity (MW)`,
                16:ncol(gcpt_jan_2024_raw_units_df)) |>
  dplyr::mutate(Country = case_when(Country == "T√ºrkiye" ~ "Türkiye", 
                                    TRUE ~ Country)) |> 
  tidyr::pivot_longer(-c(`Plant name`, Country, Region, OECD, Region, G20, G7, `Capacity (MW)`),
                      names_to = "Year",
                      values_to = "status")

# Removes H1 references, to include only data for full year
gcpt_jan_2024_units_long_full_year_df <- 
  gcpt_jan_2024_units_long_df |>
  filter(!grepl('H1', Year)) 

# remove the H2 reference from the year column, which will mean that column now has just  full years
gcpt_jan_2024_units_long_full_year_df$Year <- 
  stringr::str_remove_all(gcpt_jan_2024_units_long_full_year_df$Year, "H2")

# Now our year column can be converted to a numeric column
gcpt_jan_2024_units_long_full_year_numeric_df <- 
  gcpt_jan_2024_units_long_full_year_df |>
  mutate(Year = as.numeric(Year))

# filters data to just operating
gcpt_jan_2024_units_operating_df <-
  gcpt_jan_2024_units_long_full_year_numeric_df |>
  filter(status == "operating")


# create empty df with 0 capacity for each year for each country, in order to capture the countries which have years with no operating capacity 
# Starts by creating a df with the country names, with the number of rows being the number of years we have in our dataset (24)
all_country_names_list_with_rows <- 
  country_names_list[rep(seq_len(nrow(country_names_list)), 
                                                each = 24), ]

# Adds year and capacity column to the rows created above, so each country now has a row with each year from 2000 to 2023 and 0 for capacity. 
all_country_names_list_with_rows_full_empty_df <- 
  all_country_names_list_with_rows |>
  dplyr::group_by(Country) |>
  dplyr::mutate(Year = c(2000:2023)) |>
  dplyr::mutate(Capacity = 0)

# Takes the data with the operating units we created above and summarises the total capacity by country and year. We then add the empty dataset we created above with 0 for each country and year, and we add this together to the summarised data with actual capacity. We then combine the two datasets for a total operating capacity. By adding the empty dataset, we ensure that we have rows for countries that have either no operating data at all, as well as for coutnries which have some years without operating data (showing up as 0).
gcpt_jan_2024_units_operating_country_all_df <- 
  gcpt_jan_2024_units_operating_df |>
  group_by(Country, Year) |>
  summarise(Capacity = sum(`Capacity (MW)`)) |>
  bind_rows(all_country_names_list_with_rows_full_empty_df) |>
  group_by(Country, Year) |>
  summarise(Capacity = sum(Capacity))

# Checks the number of rows for each country, to make sure that they all have 24 rows, for the number of years, so that we're not missing any years
gcpt_jan_2024_units_operating_country_all_df |>
  dplyr::select(Country) |>
  count() 

# Creates a df with all countries summed up by year, creating a global total
  gcpt_jan_2024_units_operating_df |>
  dplyr::group_by(Year) |>
  dplyr::summarise(Capacity = sum(`Capacity (MW)`)) |>
  dplyr::mutate(Country = "Global", .before = 1)

# Uses the OECD column in our data that identifies if a country is part of the OECD country grouping, to create an OECD total by year df
gcpt_jan_2024_units_operating_OECD_df <- 
  gcpt_jan_2024_units_operating_df |>
  group_by(OECD, Year) |>
  summarise(Capacity = sum(`Capacity (MW)`)) |>
  filter(OECD == "OECD") |>
  rename("Country" = OECD)
  
# Uses the G20 column in our data that identifies if a country is part of the OECD country grouping, to create an OECD total by year df
gcpt_jan_2024_units_operating_G20_df <- 
  gcpt_jan_2024_units_operating_df |>
  group_by(G20, Year) |>
  summarise(Capacity = sum(`Capacity (MW)`)) |>
  filter(G20 == "G20") |>
  rename("Country" = G20)

# Uses the G7 column in our data that identifies if a country is part of the OECD country grouping, to create an OECD total by year df
gcpt_jan_2024_units_operating_G7_df <- 
  gcpt_jan_2024_units_operating_df |>
  group_by(G7, Year) |>
  summarise(Capacity = sum(`Capacity (MW)`)) |>
  filter(G7 == "G7") |>
  rename("Country" = G7)


# Uses the EU27 column in our data that identifies if a country is part of the OECD country grouping, to create an OECD total by year df
gcpt_jan_2024_units_operating_EU27_df <- 
gcpt_jan_2024_units_operating_df |>
  filter(Region == "EU27") |>
  group_by(Year) |>
  summarise(Capacity = sum(`Capacity (MW)`)) |>
  mutate(Country = "EU27")

# joins all the country grouping datasets together with the country data. Also turns megawatt capacity to gigawatts
# Saves out the final dataset as a csv
gcpt_jan_2024_cumulative_df <- 
  bind_rows(gcpt_jan_2024_units_operating_global_df,
            gcpt_jan_2024_units_operating_EU27_df,
            gcpt_jan_2024_units_operating_G7_df,
            gcpt_jan_2024_units_operating_G20_df,
            gcpt_jan_2024_units_operating_OECD_df,
            gcpt_jan_2024_units_operating_country_all_df) |>
  dplyr::mutate(Capacity = Capacity/1000) |>
  write_csv(file.path(project_data_dir,
                      "january_2024",
                      "final",
                      "gcpt_jan_2024_cumulative.csv")) 

# Createa a dataset for download, rounding all data to 3 decimal places
gcpt_jan_2024_cumulative_df |>
  dplyr::mutate(`Capacity (GW)` =  round(Capacity, digits = 3)) |>
  dplyr::select(-Capacity) |>
  write_csv(file.path(project_data_dir,
                      "january_2024",
                      "final",
                      "gcpt_jan_2024_cumulative_download_data.csv")) 



# turns the dataframe into a json file, using the toJSON function from the jsonlite package
gcpt_jan_2024_cumulative_json <- 
  jsonlite::toJSON(gcpt_jan_2024_cumulative_df |>
                     mutate(across(everything(), as.character)),
                   simplifyDataFrame = TRUE,
                   pretty = TRUE)

# Saves out the final data as a json file, to be uploaded to the dashboard folder
writeLines(gcpt_jan_2024_cumulative_json, 
           file.path(project_data_dir,
                     "january_2024",
                     "final",
                     "gcpt_jan_2024_cumulative.json"))
