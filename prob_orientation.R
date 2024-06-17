
# Pre-Flight --------------------------------------------------------------

#Load Libraries 
library(tidyverse)
library(dslabs)


# The Mystery Urn ---------------------------------------------------------

# Take multiple polls
take_poll(25)



# Tiny Toy Model Urn ------------------------------------------------------

# Create the urn 
urn <- rep(c("red", "blue"), times = c(2,3))
urn

#Calculate the percent red
2/5

#Calculate the percent blue
3/5

#Sample 1 bead at random
sample(urn, 1)

#Same 3 beads at random (what % red?)
sample(urn, 3)

# What if we try 10 times? 
replicate(10, sample(urn, 3)) %>% table() %>% prop.table()

# What if we try 1000 times? 
replicate(1000, sample(urn, 3)) %>% table() %>% prop.table()

# What if we try 10,000 times? 
replicate(10000, sample(urn, 3)) %>% table() %>% prop.table()

# Let's do it 10,000 times and see what each result looks like 
samples <- replicate(10000, sample(urn,3) %>% 
                       table() %>% 
                       prop.table()) %>% 
  tibble() %>% unnest_wider(col = 1) %>% 
  mutate(red = ifelse(is.na(red),0,red), blue = ifelse(is.na(blue),0,blue))

# What did we learn? 
summary(samples)
hist(samples$blue)
hist(samples$red)


# Jumbo Urn ---------------------------------------------------------------
# Create the urn 
jumbo_urn <- rep(c("red", "blue"), times = c(84,37))
jumbo_urn

red <- 84/(84+37)
blue <- 37/(84+37)

jumbo_samples <- replicate(10000, sample(jumbo_urn,10) %>% 
                             table() %>% 
                             prop.table()) %>% 
  tibble() %>% unnest_wider(col = 1) %>% 
  mutate(red = ifelse(is.na(red),0,red), blue = ifelse(is.na(blue),0,blue))

summary(jumbo_samples)
hist(jumbo_samples$blue)
hist(jumbo_samples$red)

# Calculate average Red %
x_hat_red <- mean(jumbo_samples$red)

# Calculate standard error for Red
se_hat_red <- sqrt(x_hat_red * (1 - x_hat_red) / 10000)

# calculate lower and upper bounds for the 95% Confidence Interval 
c(x_hat_red - 1.96 * se_hat_red, x_hat_red + 1.96 * se_hat_red)


# Calculate average Blue %
x_hat_blue<- mean(jumbo_samples$blue)

# Calculate standard error for Blue
se_hat_blue <- sqrt(x_hat_blue * (1 - x_hat_blue) / 10000)

# calculate lower and upper bounds for the 95% Confidence Interval 
c(x_hat_blue - 1.96 * se_hat_blue, x_hat_blue + 1.96 * se_hat_blue)



# Easier/Fancier ----------------------------------------------------------


# New preflight  ----------------------------------------------------------

# Load packages 
#install.packages("devtools")
devtools::install_github(repo = "ACCLAB/dabestr", ref = "dev") # CRAN version is broke 
library(dabestr)
library(quanteda)
library(quanteda.textstats)

# Load data 
data <- read_csv("datasets/drw_courses.csv")

# Get Flesch scores
flesch_scores <- data %>% 
  mutate(read_diff = textstat_readability(Description, measure = "Flesch")) %>% 
  unnest(cols = c(read_diff))

# Create estimation object 
dabest_object <- load(data=flesch_scores, x=Course, y=Flesch, 
                                       idx = c("Digital", "History", "Theory"))
# Get mean diff 
dabest_object %>% mean_diff()

# Plot results 
dabest_object %>% mean_diff() %>% dabest_plot()

