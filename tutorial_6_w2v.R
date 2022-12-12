
# Tutorial 6a: Feature Engineeering- Word2Vec -----------------------------

# This tutorial demonstrates how to extract document-level word embeddings for subsequent text classification. (See Tutorial 7 for further details.) 

# Pre-Flight --------------------------------------------------------------

# Load libraries 
library(tidyverse)
library(word2vec)

# Load data
data <- read_csv("datasets/spam_ham.csv") %>% 
  mutate(id = row_number())

# Create splits  ----------------------------------------------------------

# Set seed to ensure reproducable samples. (Always set again before running the next line)
set.seed(2022)

# Randomly select 80% of cases for the training set 
train_set <- data %>% slice_sample(prop =.8)

# Reserve the remaining 20% for the test set 
test_set <- data %>% anti_join(train_set, by="id")


# Create model and get embeddings  ----------------------------------------

# Create train set model 
train_model <- word2vec(train_set$Message)

# Get train set embeddings 
train_embeddigns <- doc2vec(train_model, train_set$Message) %>% 
  data.frame() %>% 
  bind_cols(train_set) %>% 
  filter(complete.cases(.))

# Write out training data 
saveRDS(train_embeddigns, "spam_train_w2v.RDS")

# Create test set model 
test_model <- word2vec(test_set$Message)

# Get test set embeddings 
test_embeddigns <- doc2vec(test_model, test_set$Message) %>% 
  data.frame() %>% 
  bind_cols(test_set) %>% 
  filter(complete.cases(.))

# Write out training data 
saveRDS(test_embeddigns, "spam_test_w2v.RDS")
