#### Preamble ####
# Purpose: Models the percentage of support for Kamala Harris in each poll as a function of various predictors.
# Author: Shamayla Durrin
# Date: 30-10-2024
# Contact: shamayla.islam@mail.utoronto.ca
# License: MIT
# Pre-requisites: Ensure that the necessary libraries (tidyverse, arrow, etc.) are installed and data is available in the required format.
# Any other information needed? Data should include variables for support, pollster, sample size, state, and recency.


#### Workspace setup ####

library(tidyverse)
library(here)
library(arrow)

#### Read data ####
analysis_data <- read_parquet(here("data/02-analysis_data/analysis_data.parquet"))

# Load necessary libraries
library(tidyverse)

# Assuming your data is loaded in a dataframe called `data`, with variables:
# - support: percentage of support for Kamala Harris
# - pollster: categorical variable for the polling organization
# - sample_size: numeric variable for sample size
# - state: categorical variable for the state
# - recency: numeric variable representing the recency of the poll

# Model 1: Only pollster and sample size as predictors
model1 <- lm(pct ~ pollster + sample_size, data = analysis_data)
saveRDS(model1, "model_1.rds")

# Model 2: Adding state as a predictor
model2 <- lm(support ~ pollster + sample_size + state, data = data)
saveRDS(model2, "model_2.rds")

# Model 3: Adding recency as a predictor
model3 <- lm(support ~ pollster + sample_size + state + recency, data = data)
saveRDS(model3, "model_3.rds")


