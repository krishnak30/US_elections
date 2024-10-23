#### Preamble ####
# Purpose: Simulates a data set of polling results for forecasting the upcoming US elections. 
# Author: Krishna Kumar
# Date: October 19 2024
# Contact: krishna.kumar@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed


#### Workspace setup ####

library(tidyverse)

#### Simulate data ####

set.seed(420)

# Number of observations #
n <- 100

# simulating poll ID #
poll_id <- sample(1:1000, n, replace = TRUE)

# simulating pollster ID #

pollster_id <- sample(1:100, n, replace = TRUE)

# simulating numeric grade #

numeric_grade <- round(runif(n, min = 0.0, max = 10.0), 2)

# simulating poll score #

pollscore <- round(runif(n, min = -1, max = 1), 2)

# simulating methodology for three assumed types #

methodology <- sample(c('Online', 'In-Person', 'Hybrid'), n, replace = TRUE)

# simulating states #

states <- c("Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", 
            "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", 
            "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", 
            "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", 
            "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", 
            "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", 
            "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming")

state <- sample(states, n, replace = TRUE)

# simulating start and end dates with poll length being 1 - 7 days #

start_date <- sample(seq(as.Date('2024-01-01'), as.Date('2024-10-16'), by="day"), n, replace = TRUE)

end_date <- start_date + sample(1:7, n, replace = TRUE)  # Assuming polls last 1 to 7 days

# simulating sample sizes for polls #

sample_size <- sample(100:10000, n, replace = TRUE)

# simulating population type (likely voters vs registered voters) #

population <- sample(c("likely voters", "registered voters"), n, replace = TRUE)

# simulating candidate names #

candidate_name <- sample(c("Donald Trump", "Kamala Harris", "other"), n, replace = TRUE)

# simulating percentage (pct) #

pct <- round(runif(n, min = 30, max = 70), 1)


# Combining all variables into a tibble #

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

head(simulated_data, 20)

write.csv(simulated_data, file = "data/00-simulated_data/simulated_data.csv")
