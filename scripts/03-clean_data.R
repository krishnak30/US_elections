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

# Create a new column 'poll_scope' based on whether the 'state' column is empty or not

cleaned_data <- cleaned_data %>%
  mutate(poll_scope = ifelse( is.na(state), "National", "State"))

# Replace missing values (NA) in the 'state' column with NA

cleaned_data <- cleaned_data %>%
  mutate(state = ifelse(is.na(state), "Not Applicable", state))

# Keep only the relevant columns
cleaned_data <- cleaned_data %>%
  select(poll_id, pollster_id, pollster, numeric_grade, pollscore, state, start_date, poll_scope, end_date, sample_size, population, candidate_name, pct)

# Remove any rows that have missing values in any column
cleaned_data <- cleaned_data %>% drop_na()

# Look at the range of numeric grade to select a cutoff 

numeric_grade_range <- range(cleaned_data$numeric_grade)

cutoffgrade <- 1.5 # this cutoff was selected  to retain mid to high quality pollster 

# Remove pollster that has low numeric grade 

cleaned_data <- cleaned_data %>% filter(numeric_grade >= cutoffgrade)


#Filter the dataset to keep only rows with Kamala Harris or Donald Trump

cleaned_data <- cleaned_data %>%
  filter(candidate_name %in% c("Kamala Harris", "Donald Trump"))

# Ensure the start_date and end_date columns are in date format
cleaned_data <- cleaned_data %>%
  mutate(
    start_date = parse_date_time(start_date, orders = c("mdy", "ymd")),
    end_date = parse_date_time(end_date, orders = c("mdy", "ymd"))
  )

# Ensure that end_date is a Date object

cleaned_data$end_date <- as.Date(cleaned_data$end_date)

# Create a new column to calculate the recency of a poll 

cleaned_data$recency <- as.numeric(Sys.Date() - cleaned_data$end_date)


#### Save data ####

write_parquet(cleaned_data, "data/02-analysis_data/analysis_data.parquet")
