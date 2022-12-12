
# Tutorial 1: R Orientation  ----------------------------------------------

# This R script file provides an overview of some basic R commands, with a focus on string (text) data. 


# The Basics --------------------------------------------------------------

# This is a comment. If well written, it helps us understand what code is doing. The # makes it a comment.
# Comments don't do anything. 

# Print "'print()' is a verb. It does stuff." to the console.  
print("'print()' is a verb. It does stuff.")

# Paste together two strings and print to the console. 
paste("'paste()' is another verb.", "It does other stuff.")

# Paste together two strings and print to the console. 
paste("Verbs (aka functions) can be modified with additional parameters.", "Here's an example using 'sep='", "'sep' stands for 'separator'", sep="|")

# Paste together two strings and print to the console. 
paste("Verbs (aka functions) can be modified with additional parameters.", "Here's an example using 'sep='", "'sep' stands for 'separator'", sep="<>")

#Learn about paste()'s parameters 
?paste




# Naming and using objects ------------------------------------------------

# <- or = can be use to save objects. You can then apply verbs to those saved objects. 

# Assign sentence to variable name. 
sentence1 <- "R is fun!" # Check out that weird <- operator. That's the "assignment" operator. It names things (assigns objects to nouns).

#Print sentence1 to console.
print(sentence1)

# Determine the structure of sentence1 with str(). 
str(sentence1)

# Determine how many characters are in sentence1 with the verb nchar(). 
nchar(sentence1)

# Assign sentence to variable name. 
sentence2 <- "I'm having a truly joyous time with R!"

#Combine sentence1 and sentence2 using the verb paste(). 
paste(sentence1,sentence2)

#Combine sentence1 and sentence2 using paste() and assign to variable name. 
two_sentences <- paste(sentence1,sentence2)

#Print two_sentences to the console. 
two_sentences

# Operators ---------------------------------------------------------------

# Operators are symbols that do things. You'll remember the assignment operator (<-) from up above. Mathematical operators are the kind you already know the best. They include your basic addition (+), subtraction (-), multiplication(*), and division (/). With mathematical operators, you can turn R into the most overpowered calculator there is. 

# Add 1 and 2
1 + 2

# This problem was famous on Twitter not too long ago (https://twitter.com/emma__jenner1/status/1427752157353189380). It turns out a lot of folks don't remember order of operations. 
50 + 50 - 25 * 0 + 2 + 2


# Importantly, R lets you mix and match verbs and operators, so let's do some sentence math for no good reason. 
nchar(sentence2) + nchar(sentence1)
nchar(sentence2) / nchar(sentence1)
nchar(two_sentences) - (nchar(sentence2) + nchar(sentence1)) #What happened here? 


# There are also logical operators like and (&), or (|), equals (==), greater than (>), less than (<) and in (%in%). With logical operators, you can think of them as asking a question.

# Using == asks if two terms are equal. 
3 == 1730 # Think of this as saying "True or False: does 3 equal 1730?"

# You can also combine logical operators and verbs just like you could with mathematical operators. 
nchar(two_sentences) == (nchar(sentence2) + nchar(sentence1)) #see that double equals, that means it's the logical operator. 
nchar(two_sentences) > nchar(sentence2)
sentence2 %in% two_sentences


# Lists -------------------------------------------------------------------
# Create a list of sentence1 and sentence2. 
sentence_list <- list(sentence1,sentence2) # Don't understand what happened? Try typing "?list" in your console to learn more. 

#Determine the structure of sentence_list.
str(sentence_list) #Same deal with "?str" 

#Check if sentence2 is in sentence_list. 
sentence2 %in% sentence_list

#Paste the elements of sentence_list. 
paste(sentence_list)

#Paste and collapse the elements of sentence_list. 
paste(sentence_list, collapse = " ")



# Libraries and packages --------------------------------------------------
# Get the word stems from sentence1. 
stem_strings(sentence1) 

#Welcome to your very first R error! R also known as base R has a ton of useful verbs. But people have developed all sorts of add-on libraries or packages with new bonus verbs. R doesn't know how to find bonus verbs by default, so you have to tell it where to look. Here's one way.  
textstem::stem_strings(sentence2) #This says "look in the textstem library to find the verb stem_strings(). If this didn't work type the following into your R console, press enter, and try again: install.packages("textstem")

#  You can also save time and typing by pre-loading libraries. | You're going to see a lot of weird things in the console. Ignore them for now.  
library(textstem) # This tells R- "Hey if you see a verb you don't understand, don't forget to check the textstem library." 

# Stem the string sentence2. Stems are basically the shortest meaningful version of a word. This gets each of the stems from the string sentence2.  
stem_strings(sentence2) #See no "texstem::" required. 



# Combo Moves -------------------------------------------------------------
# As mentioned in the lecture, R lets you create combo verbs by nesting them. 

# Stem sentence1 and find out how many characters are in the stem. 
nchar(stem_strings(sentence2))


# DIY Verbs ---------------------------------------------------------------
# You can also create your own verbs using function(x). Check it out. 
stem_and_count <- function(x){nchar(stem_strings(x))}

# Use your new DIY verb.  
stem_and_count(sentence1)
stem_and_count(sentence2)
stem_and_count(two_sentences)

