#### Preamble ####
# Purpose: Simulates a dataset of Australian electoral divisions, including the 
  #state and party that won each division.
# Author: Rohan Alexander
# Date: 26 September 2024
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(dplyr)
library(lubridate)
library(tidyverse)

# Setting seed
set.seed(420)

# Number of observations 
n <- 100

# Simulating poll ID 
poll_id <- sample(1:1000, n, replace = TRUE)

# simulating pollster ID 
pollster_id <- sample(1:100, n, replace = TRUE)

# Simulating numeric grade (between 1.0 to 10.0)
numeric_grade <- round(runif(n, min = 1.0, max = 10.0), 2)

# Simulating poll score (between -1 to 1)
pollscore <- round(runif(n, min = -1, max = 1), 2)

# Simulating methodology 
methodology <- sample(c('Online', 'In-Person', 'Hybrid'), n, replace = TRUE)

# Simulate states 
states <- c("Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", 
            "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", 
            "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", 
            "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", 
            "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", 
            "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", 
            "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming")

# Simulating states for n entries
state <- sample(states, n, replace = TRUE)

# Simulating start and end dates with polls lasting 1 - 7 days
start_date <- sample(seq(as.Date('2024-01-01'), as.Date('2024-10-16'), by="day"), n, replace = TRUE)
end_date <- start_date + sample(1:7, n, replace = TRUE) 

# Simulating sample_size
sample_size <- sample(100:3000, n, replace = TRUE)

# Simulating population type 
population <- sample(c("likely voters", "registered voters"), n, replace = TRUE)

# Simulating candidate name 
candidate_name <- sample(c("Donald Trump", "Kamala Harris", "Other"), n, replace = TRUE)

# Simulate pct 
pct <- round(runif(n, min = 30, max = 70), 1)

# Combine all into a tibble
simulated_data <- tibble(
  poll_id = poll_id,
  pollster_id = pollster_id,
  numeric_grade = numeric_grade,
  pollscore = pollscore,
  methodology = methodology,
  state = state,
  start_date = start_date,
  end_date = end_date,
  sample_size = sample_size,
  population = population,
  candidate_name = candidate_name,
  pct = pct
)

# View the first few rows of the simulated dataset
head(simulated_data)

#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
