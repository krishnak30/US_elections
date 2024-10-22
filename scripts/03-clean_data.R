#### Preamble ####
# Purpose: Cleans the raw poll data from FiveThirtyEight, which contains observations on the number of polls for the U.S. election.
# Author: Shamayla Durrin Islam
# Date: 19 October 2024
# Contact: shamayla.islam@mil.utoronto.ca
# License: MIT
# Pre-requisites: Requires raw polling data from FiveThirtyEight. Ensure tidyverse, janitor and arrow packages are installed for data saving and cleaning.
# Any other information: This script assumes that the raw data is in CSV format and structured according to FiveThirtyEight's poll dataset.

#### Workspace setup and loading data  ####

library(tidyverse)
library(janitor)
library(arrow)
library(lubridate)
raw_data <- read_csv("data/01-raw_data/raw_data.csv")

#### Data Cleaning ####

# Remove duplicate rows if any 

cleaned_data <- raw_data %>% distinct()

# Create a new column 'National' based on whether the 'state' column is empty or not

cleaned_data <- cleaned_data %>%
  mutate(national = ifelse(is.na(state), 1, 0))

# Replace missing values (NA) in the 'state' column with Not Applicable

cleaned_data <- cleaned_data %>%
  mutate(state = ifelse(is.na(state), "Not Applicable", state))

# Keep only the relevant columns
cleaned_data <- cleaned_data %>%
  select(poll_id, pollster_id, pollster, numeric_grade, pollscore, state, start_date, national, end_date, sample_size, population, candidate_name, pct)

# Remove any rows that have missing values in any column
cleaned_data <- cleaned_data %>% drop_na()

# Look at the range of numeric grade to select a cutoff 

numeric_grade_range <- range(cleaned_data$numeric_grade)

cutoffgrade <- 1 # this cutoff was selected  to retain mid to high quality pollster 

# Remove pollster that has low numeric grade 

cleaned_data <- cleaned_data %>% filter(numeric_grade >= cutoffgrade)


#Filter the dataset to keep only rows with Kamala Harris or Donald Trump

cleaned_data <- cleaned_data %>%
  filter(candidate_name %in% c("Kamala Harris"))

# Ensure the start_date and end_date columns are in date format
cleaned_data <- cleaned_data %>%
  mutate(
    start_date = parse_date_time(start_date, orders = c("mdy", "ymd")),
    end_date = parse_date_time(end_date, orders = c("mdy", "ymd"))
  )

# Apply clean_names to clean the column names
cleaned_data <- cleaned_data %>%
  clean_names()

# Ensure that end_date is a Date object

cleaned_data$end_date <- as.Date(cleaned_data$end_date)


# Remove polls with pollster counts less than 5

cleaned_data <- cleaned_data %>%
  group_by(pollster) %>%
  filter(n() >= 5) %>%
  ungroup()

# Convert percentage to actual number for modelling

cleaned_data <- cleaned_data %>%
  mutate(
    num_support = round((pct / 100) * sample_size, 0)  
  )

# Filter Observatons after Harris was declared 

cleaned_data <- cleaned_data %>%
  filter(end_date >= as.Date("2024-07-21"))

# Calculate recency of every poll and make a column 

reference_date <- max(cleaned_data$end_date, na.rm = TRUE)  # Most recent poll date

analysis_data <- cleaned_data %>%
  mutate(recency = as.numeric(reference_date - end_date))


#### Save data ####

write_parquet(cleaned_data, "data/02-analysis_data/analysis_data.parquet")

#### Creating Data For Mapping ####

deduped_data <- raw_data %>%
  distinct()  # Remove duplicate rows

# Step 2: Filter for Kamala Harris and non-empty states
harris_data <- deduped_data %>%
  filter(candidate_name == "Kamala Harris" & !is.na(state))

# Step 3: Group by state and calculate mean support for Kamala Harris
mapping_data <- harris_data %>%
  group_by(state) %>%
  summarise(mean_support_kamala = mean(pct, na.rm = TRUE))

# Step 4: Save the aggregated data to a parquet file
write_parquet(mapping_data, "data/02-analysis_data/mapping_data.parquet")

