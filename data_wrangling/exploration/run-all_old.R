# PROJECT SETUP -----------------------------------------------------------

# Loads in the packages needed in this repository and the data directory, defined in our setup script. The data directory is set based on a local path, so if anyone else wants to use this, you will have to change this to match your own machine.
#

source("R/setup.R")

##### -------------------------------- #####

# 1. LOADS DATA  -----------------------------------------------------------

# This scripts loads the country list, with the names of the countries as included and spelt in the Global Coal Plant Tracker. Also loads a sheet with the country groupings (G7, G20, EU27 and OECD countries) for those countries that have data in the Global Coal Plant Tracker. These lists will be used to create summary country grouping values for the different plots. 
source("R/00_loads_country_list.R")

# The next step is to load the data that we will need for the project
# This script loads the raw data with the operating units, to use in order to create cumulative capacity.
source("R/01_loads_raw_operating_units_by_year.R")

# This script  loads data by country and by year broken down by status (cancelled, operating, under construction etc) over the period from 2014 to 2023, annually
source("R/02_loads_status_df.R")

# This scripts loads data specially formatted to include the age and technology type of each coal unit
source("R/03_loads_plant_age_type_df.R")

# This script loads the Global Coal Plant Tracker latest summary tables, which include the  total coal capacity by status for the latest release, by country
source("R/04_loads_summary_table_df.R")

# This script loads the data file that includes cumulative capacity (that includes mothballed data so not used for other calculations) and the capacity added and retired for each country, to be used in the added and retired dashboard dataviz. 
source("R/05_loads_main_df.R")

##### -------------------------------- #####

## 2. CLEANS AND ANALYSES DATA -----------------------------------------------------------

# Here our scripts will clean and analyse the data, exporting them one by one for the relevant json file to be used in the dashboard. 
# The first step is to create a long df of our country groupings, to be used to creating group summaries in the scripts where the country grouping totals are not pre-calculated. 
source('cleaning/transforms_country_grouping_data_to_long.R')
# 
# COUNTRY GROUPING ADD ADJUSTMENT 

###### 1. Cumulative area chart dataset
###### 
#The next step here is to create the data for the cumulative area chart in the dashboard that shows the total operating capacity by year, from 2000. In this dataset, the country groupings are included within the raw data.
# The script creates and exports a csv dataset and a json dataset to be used in the dashboard, as well as creating a csv file to make available for downloading with the graphic within the dashboard

source('analysis/preps_df_for_cumulative_area.R')

##### 2. Added and retired bar chart dataset 
##### 
##### The second dataset we create and export is the added, retired and net change dataset for use in a bar chart showing the total capacity added and retired each year. This dataset is already formatted as total capacity by country, so we do not need to run any significant analysis from the raw data. In this script, we are creating country grouping totals within the code based on the country groupings list, as they are not included in the dataset.
#### The script creates and exports a csv dataset and a json dataset to be used in the dashboard, as well as creating a csv file to make available for downloading with the graphic within the dashboard
source("analysis/preps_df_for_added_retired_net_change.R")

###### 3. Status data
###### 
######  The data here comes summarised by country, so not calculated from the raw data - just some basic tidying up column names and reshaping the data. In this case, one sheet includes all country data and a second sheet includes the country groupings, so we just combine the two together, but don't need to calculate group summaries in the code. The script creates and exports a csv dataset and a json dataset to be used in the dashboard, as well as creating a csv file to make available for downloading with the graphic within the dashboard
source("analysis/preps_df_for_status_bars.R")

###### 4. Age and technology type data
###### 
###### The data here is raw data by unit, and our script groups it by age bracket, 
#The script creates and exports a csv dataset and a json dataset to be used in the dashboard, as well as creating a csv file to make available for downloading with the graphic within the dashboard
source("analysis/preps_df_for_age_type.R")

###### 5. Ticker data
###### 
# For the numbers to go in the ticker, we use the data from the status spreadsheet that we loaded in 02. The script also creates the phrases and colours for the ticker text, based on conditionals. It then saves out a csv and a json, to be included in the dashboard code. 
source("analysis/preps_df_for_ticker.R")

##### -------------------------------- #####



##### -------------------------------- #####

### 4. EXPORTS DATA -----------------------------------------------------------

# There are occasions when we want to export data after cleaning or analysis, for uploading to Flourish for example or to share, save the csvs used to create the final data viz. We do this in this section

# source('')
