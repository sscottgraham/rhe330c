

# Tutorial 4: Framegrams ---------------------------------------------------


# This script is a basic framegram tutorial Framegram is a portmanteau of ngram and (linguistic) frame. The tutorial helps users explore the way COVID is framed in true and fake news tweets. 


# Pre-flight --------------------------------------------------------------

# Load libraries 
library(tidyverse)
library(tidytext)

# Load data
data <- read_csv("datasets/covid_fake_news.csv")


# Trigrams ----------------------------------------------------------------

# Visualize most commonly occurring terms (For details see Tutorial 3)
data %>%
  unnest_tokens(word, tweet) %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE) %>%
  filter(n > 300) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x=word, y=n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

# Visualize most commonly occurring trigrams (take 1)
data %>%
  unnest_tokens(trigram, tweet, token = "ngrams", n=3) %>% 
  anti_join(stop_words) %>%
  count(trigram, sort = TRUE) %>%
  filter(n > 300) %>%
  mutate(trigram = reorder(trigram, n)) %>%
  ggplot(aes(x=trigram, y=n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()


# Visualize most commonly occurring trigrams (take 2)
data %>%
  unnest_tokens(trigram, tweet, token = "ngrams", n=3) %>% 
  #anti_join(stop_words) %>%
  count(trigram, sort = TRUE) %>%
  filter(n > 300) %>%
  mutate(trigram = reorder(trigram, n)) %>%
  ggplot(aes(x=trigram, y=n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

# Visualize most commonly occurring trigrams (take 3)
data %>%
  unnest_tokens(trigram, tweet, token = "ngrams", n=3) %>% 
  #anti_join(stop_words) %>%
  count(trigram, sort = TRUE) %>%
  filter(n > 50) %>%
  mutate(trigram = reorder(trigram, n)) %>%
  ggplot(aes(x=trigram, y=n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()



# Framegrams --------------------------------------------------------------

#stringr::str_detect()
?str_detect()

str_detect("chicken", "c")

str_detect("chicken", "z")


# Covid framegram 
data %>%
  unnest_tokens(trigram, tweet, token = "ngrams", n=3) %>% 
  count(trigram, sort = TRUE) %>%
  filter(str_detect(trigram,"covid")) %>% 
  filter(n > 10) %>% # note filter change
  mutate(trigram = reorder(trigram, n)) %>%
  ggplot(aes(x=trigram, y=n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()


# COVID framegram (clean and find variants)
data %>%
  mutate(tweet_clean = str_remove_all(tweet, "19")) %>% # removes all 19s to eliminate "covid 19" problem
  unnest_tokens(trigram, tweet_clean, token = "ngrams", n=3) %>% 
  count(trigram, sort = TRUE) %>%
  filter(str_detect(trigram,"cov|corona|virus|sars")) %>% 
  filter(n > 10) %>% 
  mutate(trigram = reorder(trigram, n)) %>%
  ggplot(aes(x=trigram, y=n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()


# Addressing Stop Words ----------------------------------------------------

#stringr::str_count()
?str_count()

str_detect("chicken", "c")

str_count("chicken", "c")

#paste
paste(stop_words$word)

#paste
paste(stop_words$word, collapse = "|")


# Remove double stopword framegrams 
data %>%
  mutate(tweet_clean = str_remove_all(tweet, "19")) %>% 
  unnest_tokens(trigram, tweet_clean, token = "ngrams", n=3) %>% 
  count(trigram, sort = TRUE) %>%
  filter(str_detect(trigram,"cov|corona|virus|sars")) %>% 
  filter(str_count(trigram,paste(stop_words$word, collapse = "|")) < 2) %>%
  filter(n > 10) %>% 
  mutate(trigram = reorder(trigram, n)) %>%
  ggplot(aes(x=trigram, y=n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()


# WTF, eh?!  
str_count("coronavirus",paste(stop_words$word, collapse = "|"))

str_count("coronavirus","or")

str_count("coronavirus","\\bor\\b") # \\b = word boundary

stop_words_bounded <- paste0("\\b", stop_words$word, "\\b", collapse = "|")

str_count("coronavirus", stop_words_bounded)

# Remove double stopword framegrams 
data %>%
  mutate(tweet_clean = str_remove_all(tweet, "19")) %>%
  unnest_tokens(trigram, tweet_clean, token = "ngrams", n=3) %>% 
  #anti_join(stop_words) %>%
  count(trigram, sort = TRUE) %>%
  filter(str_detect(trigram,"cov|corona|virus|sars")) %>% 
  filter(str_count(trigram,stop_words_bounded) < 2) %>%
  filter(n > 10) %>% 
  mutate(trigram = reorder(trigram, n)) %>%
  ggplot(aes(x=trigram, y=n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()




