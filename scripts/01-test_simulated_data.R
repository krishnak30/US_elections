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

<<<<<<< HEAD
# loading the data #
simulated_data <- read_csv("data/00-simulated_data/simulated_data.csv")
=======
analysis_data <-
  read_csv("data/00-simulated_data/simulated_data.csv")
>>>>>>> 2e22a206dc9788f5708daba86f1e4ee71eec1e75

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

<<<<<<< HEAD
# Test population column values
test_that("Population column contains valid types", {
  expect_true(all(simulated_data$population %in% c("likely voters", "registered voters")))
})
=======
# Check if the 'state' column contains only valid Australian state names
valid_states <-
  c(
    "New South Wales",
    "Victoria",
    "Queensland",
    "South Australia",
    "Western Australia",
    "Tasmania",
    "Northern Territory",
    "Australian Capital Territory"
  )
>>>>>>> 2e22a206dc9788f5708daba86f1e4ee71eec1e75

# Test candidate_name values
test_that("Candidate names are valid", {
  expect_true(all(simulated_data$candidate_name %in% c("Donald Trump", "Kamala Harris", "other")))
})

<<<<<<< HEAD
=======
# Check if the 'party' column contains only valid party names
valid_parties <-
  c("Labor", "Liberal", "Greens", "National", "Other")

if (all(analysis_data$party %in% valid_parties)) {
  message("Test Passed: The 'party' column contains only valid party names.")
} else {
  stop("Test Failed: The 'party' column contains invalid party names.")
}

# Check if there are any missing values in the dataset
if (all(!is.na(analysis_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if there are no empty strings in 'division', 'state', and 'party' columns
if (all(analysis_data$division != "" &
        analysis_data$state != "" & analysis_data$party != "")) {
  message("Test Passed: There are no empty strings in 'division', 'state', or 'party'.")
} else {
  stop("Test Failed: There are empty strings in one or more columns.")
}

# Check if the 'party' column has at least two unique values
if (n_distinct(analysis_data$party) >= 2) {
  message("Test Passed: The 'party' column contains at least two unique values.")
} else {
  stop("Test Failed: The 'party' column contains less than two unique values.")
}
>>>>>>> 2e22a206dc9788f5708daba86f1e4ee71eec1e75
