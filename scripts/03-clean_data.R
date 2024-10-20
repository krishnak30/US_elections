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
  select(poll_id, pollster_id, numeric_grade, pollscore, state, start_date, end_date, sample_size, population, candidate_name, pct)

# Remove any rows that have missing values in any column
cleaned_data <- cleaned_data %>% drop_na()

# Look at the range of numeric grade to select a cutoff 

numeric_grade_range <- range(cleaned_data$numeric_grade)

cutoffgrade <- 1.5 # this cutoff was selected  to retain mid to high quality pollster 

# Remove pollster that has low numeric grade 

cleaned_data <- cleaned_data %>% filter(numeric_grade >= cutoffgrade)

# Look at the range of pollscore to select a cutoff 

pollscore_range <- range(cleaned_data$pollscore)

cutoffscore <- 0.22 

# remove observations that has high pollsore (lower reflects less error and bias)

cleaned_data <- cleaned_data %>% filter(pollscore >= cutoffscore)

#### Save data ####
write_parquet(cleaned_data, "data/02-analysis_data/analysis_data.csv")
