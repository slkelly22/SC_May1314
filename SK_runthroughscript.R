# Software Carpentry Workshop
# University of Mississippi, May 13-14
# Day 2, Afternoon Session

# Episode 5 - Exploring Data Frames

age <- c(2, 3, 5)
cats #cats is from Episode 4 so need to have that build previously
# from Episode 4: 
cats <- data.frame(coat = c("calico", "black", "tabby"),
                   weight = c(2.1, 5.0, 3.2),
                   likes_string = c(1, 0, 1))
# Note: Just go ahead and add Episode 4 above even through you're not teaching that content

# Episode 5 (now that we have the cats dataframe): 
# Adding columns and rows in data frames
age <- c(2, 3, 5)
cats
# We can add age to cats data frame with cbind function
cbind(cats, age)
# If the elements are different numbers, this doesn't work
age <- c(2, 3, 5, 12)
cbind(cats, age) #error
age <- c(2, 3)
cbind(cats, age) #error

nrow(cats) #there are three rows 
length(age) #and only 2 elements in the age vector; R wants those numbers to match
# You want nrow(cats) = length(age)

age <- c(2, 3 ,5)
cats <- cbind(cats, age)
# We added a column, how do we add rows? We already know the rows of a data frame are lists
newRow <- list("tortoiseshell", 3.3, TRUE, 9)
cats <- rbind(cats, newRow)
cats

# Removing Rows
cats
cats[-4, ] #this will remove the last row
cats[c(-3, -4), ] #you can also remove several rows at once by putting the numbers inside of a vector

# Removing Columns - by variable number or by index
cats[, -4]
# We cn also drop by using the index name and the %in% operator
drop <- names(cats) %in% c("age") # the %in% operator goes through each element in the left argument, in this name cats, and asks if this element occurs in the second argument
cats[, !drop]
# Note: Touch base with SW to see what subsetting she plans to cover in the AM before this PM session

# Appending to a Data Frame
# Remember: columns are vectors, rows are lists
# You can also glue two data frames together with rbind
cats <- rbind(cats, cats)
cats

# Exercise: Challenge 1
# Make a dataframe that has your first name, last name, lucky number. Then use rbind to add an entry for folks sitting besides you. Then cbind to add column to see if it's time for coffee break. 

# Realistic Example
# Read in the Gapminder dataset that we loaded previously - this is references previous content and folks will need a data folder for this code to work; note also: read.csv is Base R, not Tidy
# It looks like they'll get the data in Episode 2 (Project Management with RStudio)
# I'll create the data folder now and download gapminder
dir.create("data")
# Back to Episode 5
gapminder <- read.csv("data/gapminder_data.csv")
# Gives additional tips on how to download with download.file, readxl package, etc. See: Miscellaneous Tips

# Inspect the data
str(gapminder)
summary(gapminder)

typeof(gapminder$year) # integer
#Note: when you just run typeof(gapminder), the answer is "list" (that gets explained shortly)
typeof(gapminder$country) #character

# Dimensions - remember str() gave 1704 observations, 6 vars; what will this do? 
length(gapminder) #6; #Remember that a dataframe is a LIST OF VECTORS AND FACTORS
# Gapminder is a list of six columns
typeof(gapminder)

#If you want number of rows/columns
nrow(gapminder)
ncol(gapminder)
dim(gapminder)

# What are the title of the columns
colnames(gapminder) # Note: Look up the arguments for colnames; this should be determined at import, but can be set also?
# At this point you want to make sure that R is reading your data as you want before you run into issues down the road

# If happy with structure, start looking at the data
head(gapminder)

# Exercise: Challenge 2: Checking the last few lines and middle of the dataset
tail(gapminder)
tail(gapminder, n = 15)
# Middle using a nested function
gapminder[sample(nrow(gapminder), 5), ] #go over this carefully

# Exercise: Challenge 3: Write a script to load the gapminder dataset, save it, and run the script with source function
# File --> new file --> R script --> write script to load the data --> save to scripts directory
dir.create("scripts")
source(file = "scripts/load-gapminder.R")

# Exercise: Challenge 4: Read the output of str() again and interpret based on what you know re: lists, vectors, colnames, dim; discuss with neighbors
str(gapminder)
