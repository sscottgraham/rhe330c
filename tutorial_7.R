

# Tutorial 7: Binary Text Classification ----------------------------------

# This tutorial shows how to train a binary classifier using pre-engineered data. It is designed to work with the datasets created in Tutorials 6a and 6b. 

# Pre-Flight --------------------------------------------------------------

# Load Libraries 
library(tidyverse)
library(caret)
library(pROC)


# Load training data 
train_set <- read_rds("spam_train_w2v.RDS") %>% 
  select(-id,-Message) %>% 
  mutate(label = as.factor(Type)) %>% 
  select(-Type)

  
# Load test set data 
test_set <- read_rds("spam_test_w2v.RDS") %>% 
  select(-id,-Message) %>% 
  mutate(label = as.factor(Type)) %>% 
  select(-Type)


# 1st Try: Modeling with KNN ----------------------------------------------

# set train control 
my_control <- trainControl(## 5-fold CV
  method = "repeatedcv",
  number = 5,
  repeats = 10,
  classProbs = TRUE,
  summaryFunction = twoClassSummary)

# Fit neural network model 
knnFit <- train(label ~ ., 
                data = train_set,
                method = "knn",
                metric = "ROC",
                trControl = my_control,
                tuneLength = 2)


# Inspect model 
knnFit

# use trained model to predict test set values (raw)
knn_pred_raw <- test_set %>% select(-label) %>% predict(knnFit, newdata = ., type = 'raw')

# use trained model to predict test set values (probability)
knn_pred_prob <- test_set %>% select(-label) %>% predict(knnFit, newdata = ., type = 'prob')

# Assess model performance with confusion matrix 
confusionMatrix(knn_pred_raw,test_set$label)

# Assess model performance with ROC curve 

# Fit ROC curve 
knn_roc <- roc(test_set$label,knn_pred_prob$spam)

# Plot ROC curve 
ggroc(knn_roc)

# View area under curve value 
knn_roc




# 2nd Try: Modeling with nnet ---------------------------------------------

# set train control 
my_control <- trainControl(## 5-fold CV
  method = "repeatedcv",
  number = 5,
  repeats = 10,
  classProbs = TRUE,
  summaryFunction = twoClassSummary)

# Fit neural network model 
nnetFit <- train(label ~ ., 
                 data = train_set,
                 method = "nnet",
                 metric = "ROC",
                 trControl = my_control,
                 tuneLength = 2,
                 verbose = FALSE)


# Inspect model 
nnetFit

# use trained model to predict test set values (raw)
nn_pred_raw <- test_set %>% select(-label) %>% predict(nnetFit, newdata = ., type = 'raw')

# use trained model to predict test set values (probability)
nn_pred_prob <- test_set %>% select(-label) %>% predict(nnetFit, newdata = ., type = 'prob')

# Assess model performance with confusion matrix 
confusionMatrix(nn_pred_raw,test_set$label)

# Assess model performance with ROC curve 

# Fit ROC curve 
nn_roc <- roc(test_set$label,nn_pred_prob$spam)

# Plot ROC curve 
ggroc(nn_roc)

# View area under curve value 
nn_roc



# Examine variable importance  --------------------------------------------

varImp(nnetFit) %>% plot()


