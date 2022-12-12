# Tutorial 6b: Feature Engineering - Custom Flags -------------------------

# This tutorial demonstrates how to use custom flag feature engineering. The approach counts the frequency of identified key words for use in subsequent machine learning. See Tutorial 7 for futher details.  

# Pre-Flight --------------------------------------------------------------

# Load libraries 
library(tidyverse)

# Load data
data <- read_csv("datasets/spam_ham.csv") %>% 
  mutate(id = row_number())


# Load flag terms 
flags <- read_csv("datasets/spam_features.csv", col_names = FALSE) %>% 
  .[1,] %>% transpose() %>% unlist()



# Get features ------------------------------------------------------------

# Get flag counts 
data_features <-data %>% 
  mutate(!!!setNames(rep(NA, length(flags)), flags)) %>% 
  pivot_longer(cols = urgent:mobile,names_to="flags") %>% 
  mutate(value = str_count(Message,flags)) %>% 
  pivot_wider(names_from = flags,values_from = value)


# Create splits  ----------------------------------------------------------

# Set seed to ensure reproducable samples. (Always set again before running the next line)
set.seed(2022)

# Randomly select 80% of cases for the training set 
train_set <- data_features %>% slice_sample(prop =.8)

# Write out data 
saveRDS(train_set,"spam_train_flags.RDS")

# Reserve the remaining 20% for the test set 
test_set <- data_features %>% anti_join(train_set, by="id")

# Write out data 
saveRDS(test_set,"spam_test_flags.RDS")


  
