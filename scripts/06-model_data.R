#### Preamble ####
# Purpose: Models the percentage of support for Kamala Harris (pct) based on various factors such as pollster, poll type (state vs. national), 
#          sample size, and other relevant variables.
# Author: Shamayla Durrin
# Date: 19 October 2024
# Contact: shamayla.islam@mil.utoronto.ca
# License: MIT
# Pre-requisites: Requires the cleaned dataset of polls, including variables like pollster, state, sample size, and pct for Kamala Harris.
# Any other information needed: Ensure the necessary packages (e.g., tidyverse, broom, and modeling packages) are installed before running the model.


#### Workspace setup ####

library(tidyverse)
library(rstanarm)
library(arrow)

#### Read data ####
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

### Model data ####
first_model <-
  stan_glm(
    formula = flying_time ~ length + width,
    data = analysis_data,
    family = gaussian(),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_aux = exponential(rate = 1, autoscale = TRUE),
    seed = 853
  )


#### Save model ####
saveRDS(
  first_model,
  file = "models/first_m\del.rds"
)


