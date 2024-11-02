#### Preamble ####
# Purpose: Tests the structure and validity of the simulated polling results data set
# Author: Krishna Kumar
# Date: October 19 2024
# Contact: krishna.kumar@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - 00-install_packages.R
  # - 00-simulate_data.R 

#### Workspace setup ####

#install.packages("arrow")
#install.packages("testthat")

library(tidyverse)
library(testthat)
library(arrow)
library(readr)

# loading the data #
simulated_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Checking data load success
if (exists("simulated_data") && is.data.frame(simulated_data)) {
  cat("Data load test passed: Dataset is loaded successfully and is a data frame.\n")
} else {
  stop("Data load test failed: Dataset is not loaded or is not a data frame.\n")
}

# Checking for any missing values
if (all(!is.na(simulated_data))) {
  cat("No missing values in the dataset.\n")
} else {
  cat("There are missing values in the dataset.\n")
}

# Checking for valid state names
valid_states <- c("Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", 
                  "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", 
                  "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", 
                  "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", 
                  "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", 
                  "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", 
                  "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming")

if (all(simulated_data$state %in% valid_states)) {
  cat("All values in 'state' column are valid US state names.\n")
} else {
  cat("The 'state' column contains invalid state names.\n")
}


# Testing data set shape
test_that("Data shape is correct", {
  expect_equal(ncol(simulated_data), 13) # Expected number of columns
  expect_equal(nrow(simulated_data), 100) # Expected number of rows
})

# Testing ID and grade ranges
test_that("ID and grade ranges are within expected limits", {
  expect_true(all(simulated_data$poll_id >= 1 & simulated_data$poll_id <= 1000))
  expect_true(all(simulated_data$pollster_id >= 1 & simulated_data$pollster_id <= 100))
  expect_true(all(simulated_data$numeric_grade >= 0.0 & simulated_data$numeric_grade <= 10.0))
  expect_true(all(simulated_data$pollscore >= -1 & simulated_data$pollscore <= 1))
})

# Testing methodology column values
test_that("Methodology column contains valid values", {
  expect_true(all(simulated_data$methodology %in% c("Online", "In-Person", "Hybrid")))
})

# Test sample sizes and percentage values
test_that("Sample sizes and pct are within expected ranges", {
  expect_true(all(simulated_data$sample_size >= 100 & simulated_data$sample_size <= 10000))
  expect_true(all(simulated_data$pct >= 30 & simulated_data$pct <= 70))
})

# Test population column values
test_that("Population column contains valid types", {
  expect_true(all(simulated_data$population %in% c("likely voters", "registered voters")))
})

# Test candidate_name values
test_that("Candidate names are valid", {
  expect_true(all(simulated_data$candidate_name %in% c("Donald Trump", "Kamala Harris", "other")))
})

