

# Tutorial 5: Automated Content Analysis ----------------------------------

# This R script is an automated content analysis tutorial. It demonstrates how to one can use keyword matching to identify content types in a sample data from the 2020 presidential debates. 


# Pre-Flight --------------------------------------------------------------

#load libraries 
library(tidyverse)
library(tidytext)
library(textstem)

#load data and select Binden Trump Debate subset 
data <- read_csv("datasets/political_debates.csv") %>% 
  filter(debate=="biden_trump_2020")


# Basic Automated Content Analysis Demo -----------------------------------

# Import CSV of pre-identified COVID terms 
covid_terms <- read_csv("datasets/covid_terms.csv")

# Paste terms to REGEX query 
covid_terms_regex <- paste0(covid_terms$terms,collapse = "|")

# Get a COVID moment from dataset  
data$text[22] 

# Check that COVID text 
data$text[22] %>% str_detect(.,covid_terms_regex)

# Get another COVID moment  
data$text[41] 

# Check that COVID text 
data$text[41] %>% str_detect(.,covid_terms_regex) # oh no! 

# Try again
data$text[41] %>% str_detect(.,tolower(covid_terms_regex))


# Get fancy ---------------------------------------------------------------

# Create a function that gets stems and lemmas and then creates the REGEX query for you. 
regexify <- function(x){
  stems <- stem_words(x)
  lemmas <- lemmatize_words(x)
  c(stems,lemmas,x) %>% unique %>% 
    paste0(.,collapse = "|") %>% 
    tolower()
}

# Apply regexify function to COVID terms  
covid_terms_better_regex <- regexify(covid_terms$terms)


# Conduct automatic content analysis 
data_covid <- data %>%
  mutate(text_lower = tolower(text), # lower case text all around 
    covid = ifelse(str_detect(text_lower,covid_terms_better_regex),1,0)) # assign 1 for hit; 0 for miss

# Question: What percent of each speakers' talking turns address COVID? 
data_covid %>% 
  count(speaker,covid) %>% 
  pivot_wider(names_from = covid,values_from=n,names_prefix="covid_") %>% 
  mutate(n=covid_0+covid_1,
         covid_percent = (covid_1/n)*100)

