
# Tutorial 3: Text Analytics  ---------------------------------------------


# This script walks users through basic text analytic techniques including word frequencies and TF-IDF. It helps user identify the most common and most salient terms in different categories of recent rhetoric courses at The University of Texas at Austin. 


# Pre-Flight --------------------------------------------------------------

# Load libraries 
library(tidyverse)
library(tidytext)

# Load data
data <- read_csv("datasets/drw_courses.csv")

# Explore data by word frequency ------------------------------------------

# View most common words in all tweets
data %>%
  #Tokenize by word
  unnest_tokens(word, Description) %>%
  # Count and sort by word 
  count(word, sort = TRUE) 

# View most common words excluding stop words
data %>%
  unnest_tokens(word, Description) %>%
  #USe anti_join() to remove stop words 
  anti_join(stop_words) %>%
  count(word, sort = TRUE) 

#Visualize frequency of most common words occurring more frequently than 200 times
data %>%
  unnest_tokens(word, Description) %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE) %>%
  # Exclude words that appear fewer than 200 times
  filter(n > 10) %>%
  # Reorder descending
  mutate(word = reorder(word, n)) %>%
  #plot data
  ggplot(aes(x=word, y=n)) +
  # Add column geometry 
  geom_col() +
  #Remove the x axis labels 
  xlab(NULL) +
  #Flip coordinates so X data is on the Y axis
  coord_flip()



# RQ: What are the most common words by course? --------------------------

data %>%
  unnest_tokens(word, Description) %>%
  anti_join(stop_words) %>%
  # county by word and course
  count(word, Course, sort = TRUE) %>%
  group_by(Course) %>% 
  slice(1:5) %>%
  ungroup() %>%
  # Reorder descending
  mutate(Course= as.factor(Course),
       word = reorder_within(word, n, Course)) %>%
  ggplot(aes(word, n, fill = Course)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()+
  scale_x_reordered()+ # This must be added to fix issues with the labels created above. 
  facet_wrap(~Course, ncol = 2, scales = "free_y")



# What are the most salient words by course? -----------------------------

#Save word data for each debate
data_word_n <- data %>%
  unnest_tokens(word, Description) %>%
  anti_join(stop_words) %>%
  count(Course, word, sort = TRUE)

# Get word count by debate compared to total count of each word
total_words <- data_word_n %>% 
  group_by(Course) %>% 
  summarize(total = sum(n))

# Create a new dataframe combining information on total number of words per tweet word frequency counts
data_word_n <- left_join(data_word_n, total_words)

# Get term frequency (TF),  inverse document frequency (IDF), and TF-IDF 
data_word_n <- data_word_n %>%
  # Calculates TF, IDF, and TF-IDF from word totals and TFs
  bind_tf_idf(word, Course, n)

#Visualize frequency of most common words occurring more frequently than 10 times by debate
data_word_n %>%
  arrange(desc(tf_idf)) %>%
  group_by(Course) %>% 
  slice(1:5) %>%
  ungroup() %>%
  #mutate(word = factor(word, levels = rev(unique(word)))) %>% This is replaced with the below to fix. 
  mutate(Course= as.factor(Course),
         word = reorder_within(word, tf_idf, Course)) %>%
  ggplot(aes(word, tf_idf, fill = Course)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()+
  scale_x_reordered()+ # This must be added to fix issues with the labels created above. 
  facet_wrap(~Course, ncol = 2, scales = "free_y")

