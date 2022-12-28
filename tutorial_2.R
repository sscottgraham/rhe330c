

# Tutorial 2: Data Wrangling & Text Stats ---------------------------------


# This script is part of a tutorial on a tidy approach to data wrangling and includes some basic text stat functions. The code walks users through exploring and manipulating a data frame imported from a .CSV with information about recent rhetoric courses at The University of Texas at Austin.   


# Pre-flight --------------------------------------------------------------

# load libraries 
library(tidyverse)
library(quanteda)
library(quanteda.textstats)

# load data
data <- read_csv("datasets/drw_courses.csv")


# Explore data ------------------------------------------------------------

#Eyeball data
head(data)

# View the data structure 
str(data)

#View column names
colnames(data)

# View data
View(data)


# Wrangle data ------------------------------------------------------------

# Select
data %>% select(Course, Instructor)

# Deselect
data %>% select(-Instructor)

# Save results 
data_no_instructor <- data %>% select(-Instructor)

# Filter
data %>% filter(Course == "Digital")
data %>% filter(Course == "Digital" | Course == "History")

# Three ways to count  
data %>% group_by(Course) %>% summarise(n())

data %>% group_by(Course) %>% tally()

data %>% count(Course)


# Asking questions --------------------------------------------------------

# Which course descriptions are longest on average?
data %>% 
  mutate(nchar = nchar(Description)) %>% 
  group_by(Course) %>% 
  summarise(mean_char = mean(nchar)) %>% 
  arrange(desc(mean_char))

# Which course has the most difficult to read course descriptions on average? 
data %>% 
  mutate(read_diff = textstat_readability(Description, measure = "Flesch")) %>% 
  group_by(Course) %>% 
  summarise(mean_read_diff = mean(read_diff)) %>% 
  arrange(desc(mean_read_diff))

# Let's see what went wrong  
data_diff <- data %>% 
  mutate(read_diff = textstat_readability(Description, measure = "Flesch"))

# View unnest() in action 
data_diff_unnest <- data %>% 
  mutate(read_diff = textstat_readability(Description, measure = "Flesch")) %>% 
  unnest(cols = c(read_diff))

# Now we try again 
data %>% 
  mutate(read_diff = textstat_readability(Description, measure = "Flesch")) %>% 
  unnest(cols = c(read_diff)) %>% 
  group_by(Course) %>% 
  summarise(mean_read_diff = mean(Flesch)) %>% 
  arrange(desc(mean_read_diff))

# Let's explore further 
data_diff <- data %>% 
  mutate(read_diff = textstat_readability(Description, measure = c("Flesch","Dale.Chall","SMOG"))) %>% 
  unnest(cols = c(read_diff))

#Summary 
summary(data_diff)

# What are the average reading difficulty scores (FK, DC, and SMOG) by course? 
data_diff %>% 
  group_by(Course) %>% 
  summarise(mean_fk = mean(Flesch), mean_dc = mean(Dale.Chall), mean_smog = mean(SMOG))

