# PROJECT SETUP -----------------------------------------------------------

# Loads in the packages needed in this repository and the data directory, defined in our setup script. The data directory is set based on a local path, so if anyone else wants to use this, you will have to change this to match your own machine.
#

source("R/setup.R")

##### -------------------------------- #####

# 1. DEFINE VARIABLES  -----------------------------------------------------------

# We want to define the variables to use in the process of tsaking the data provided by the GCPT project manager and creating the final output files to update the dashboard. 

# this is the variable to use in our folder structure for the update, and to append to our file exports
year_filename <- "h1_2024" 

# We set the year here that we are currently running an update for, regardless if it is a half-year update or full year, so we would just say 2024 for example
full_year <- "2024"

# If a mid-year, we want our data to replace the label (full_year) with a half year variable, so we set how we want out data labels to display here. So if we are doing a half year analysis, we would say H1 2024 for example, and if a full year, just 2024
year_variable <- "H1 2024"

# 2. LOADS DATA  -----------------------------------------------------------

# The scripts in the `R` folder load the data for each of the elements in our dashboard. 
# The data is initially provided by the GCPT project manager to go with the new data update. In our local directory structure, we create a folder for this update to match the variable year_filename and create an input subfolder where we save our input data and an output subfolder where our data will then be exported. 
# This means for example that our original file is saved here: 
# "~/data/dashboards/GCPT/h1_2024/input/summary_text.xlsx"
# And the output file, once it has been formatted in the script in the analysis folder, is exported here:
# "~/data/dashboards/GCPT/h1_2024/output/gcpt_h1_2024_summary_text.json"

# For anyone else running this update, you can replace the base filepath structure to what makes sense for your local folder structure and your filenaming conventions. 

# Loads the country summary text data
source("R/00a_loads_country_summary_text.R")

# Loads the country cumulative data for the area chart showing cumulative capacity over time
source("R/01a_loads_cumulative_data.R")

# Loads the added, retired and net change data for diverging column chart showing capacity changes each year. 
source("R/02a_loads_added_retired_data.R")

# Loads the status over time data for the stacked column chart showing status change over time. 
source("R/03a_loads_status_over_time_data.R")

# Loads the age and technology tpe data for the stacked bar chart showing capacity by age and tech type
source("R/04a_loads_age_type_data.R")

# Loads the data for the data ticker, which includes operating capacity, change in operating capacity since 2015 and capacity under development, for the large animated numbers at the top of the dashboard. 
source("R/05a_loads_data_ticker_data.R")


# 3. EXPORTS DATA  -----------------------------------------------------------

# The scripts in the `analysis` folder take the the data for each of the elements in our dashboard that we loaded in the step above, make some formatting adjustments and exports the data as json files to the specifications needed to upload to our dashboard. 
#  
# Each output file, once it has been formatted in the relevant script, is exported to this local directory, with a filename like below:
# "~/data/dashboards/GCPT/h1_2024/output/gcpt_h1_2024_summary_text.json"

# Formats and exports the country summary text data
source("analysis/00b_structures_and_exports_summary_text.R")

# Formats and exports the country cumulative data for the area chart showing cumulative capacity over time
source("analysis/01b_structures_and_exports_cumulative_data.R")

# Formats and exports the added, retired and net change data for diverging column chart showing capacity changes each year. 
source("analysis/02b_structures_and_exports_added_retired_data.R")

# Formats and exports the status over time data for the stacked column chart showing status change over time. 
source("analysis/03b_structures_and_exports_over_time_data.R")

# Formats and exports the age and technology tpe data for the stacked bar chart showing capacity by age and tech type
source("analysis/04b_structures_and_exports_age_type_data.R")

# Exports the data for the data ticker, which includes operating capacity, change in operating capacity since 2015 and capacity under development, for the large animated numbers at the top of the dashboard. In this case, the script uses conditions to add different colours for values above or below 0 in the change column, and formats some numbers with a certain number of decimal places based on specific thresholds set in the script.  
source("analysis/05b_structures_and_exports_data_ticker_data.R")
