# Software Carpentry, Tuesday 5.14.24
# Afternoon Session, S.Kelly

# load required libraries
library(tidyverse) #includes ggplot2, dplyr, tidyr, etc. 

#Exploring Data Frames -------------------
cats
# creating a new age variable that we'll add to the cats dataframe
age <- c(2, 3, 5)

# cbind is column bind; adds a new column to the dataframe
cats <- cbind(cats, age)
cats

length(cats)

# Creating a new row that we'll add to the cats dataframe
newRow <- list("tortoiseshell", 3.3, 1, 9)

# rbind is row bind; adds a new row to the dataframe
cats <- rbind(cats, newRow)
cats

# deleting the fourth row in the cats dataframe
cats[-4, ]

cats
# deleting the fourth column
cats[,-4]

# you can also stack dataframes with rbind
rbind(cats, cats)

# creating a practice dataframe
df <- data.frame(id = c("a", "b", "c"), 
                 x = 1:3, 
                 y = c(TRUE, TRUE, FALSE))

# exercise: creating a dataframe
exercise <- data.frame(first = c("Savannah"), 
                       last = c("Kelly"), 
                       lucky_number = c(32))

exercise <- rbind(exercise, list("First", "Last", 500))
exercise <- cbind(exercise, coffee = c(TRUE, TRUE))

View(exercise)

# Importing gapminder csv data
# Note: make sure the csv file is located in your data folder
gapminder <- read.csv("data/gapminder_data.csv")

# to see the dataset in a spreadsheet type viewer
View(gapminder)

str(gapminder) # structure
summary(gapminder) # basic summary stats on your variables
typeof(gapminder$country) # checking object type

length(gapminder) # length is only 6
typeof(gapminder) # reading as a list

nrow(gapminder) # number of rows
ncol(gapminder) # number of columns
dim(gapminder) # dimensions

head(gapminder, 2) # head grabs top six rows
tail(gapminder) # tail grabs bottom six rows

rm(gapminder) # remove object from environment

source(file = "script/load_gapminder.R") # source function allows you to run a script inside another script

#________________ ggplot _________________

library(tidyverse) # you can also run library(ggplot2)

# ggplot: data, aes mapping, geom / layers

ggplot(data = gapminder) # data

# data and aesthetics and geom; now you see an image!
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point() 

# adding color 
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color = continent)) + geom_point()

# changing the geom
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color = continent)) + geom_line()

# adding group to the aes 
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color = continent, group = country)) + geom_line()

# Global mapping; what's applied in the aes is applied across both geoms
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color = continent, group = country)) + geom_line() + geom_point()

# local mapping of color to only lines
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color = continent, group = country)) + geom_line(color = "blue") + geom_point()

# local mapping of color to only points
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color = continent, group = country)) + geom_line() + geom_point(color = "blue")

# Transformations and Stats

# back to the earlier plot
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point()

# adding a layer to log the x axis in the plot
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point() + scale_x_log10()

# adding a color to the points
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point(color = "steelblue1") + scale_x_log10()

colors() # you can see all the colors R understands

# alpha sets transparency
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point(alpha = 0.3) + scale_x_log10()

# applying geom smooth 
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point(alpha = 0.3) + scale_x_log10() + geom_smooth(method = "lm", size = 1.5)

# Exercise: adding color and size to the points
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point(color = "green", size = 3) + scale_x_log10() + geom_smooth(method = "lm", size = 1.5)

# the geom_smooth has multiple lines; the global color mapping filters down
ggplot(gapminder, mapping = aes(x = gdpPercap, y = lifeExp, color = continent)) + geom_point(size = 2, shape = 17) + scale_x_log10() + geom_smooth(method = "lm")

# grab the americas data with Base R
americas <- gapminder[gapminder$continent == "Americas", ]

# plot the americas data; labs is the function for labels
# facet wrap for multiple plots
# theme to fix the years text
ggplot(americas, mapping = aes(x = year, y = lifeExp, color = continent)) + geom_line() + facet_wrap(~country) + labs(x = "Year", y = "Life Expectancy", title = "Figure 1", color = "Continent") + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + theme(legend.position = "none")

# to save the plot
ggsave("plots/Americas.png")

# dplyr -------------------------------
# Base R can be repetitive
mean(gapminder$gdpPercap[gapminder$continent == "Americas"])
mean(gapminder$gdpPercap[gapminder$continent == "Africa"])
mean(gapminder$gdpPercap[gapminder$continent == "Asia"])

# common dplyr functions: select, filter, group_by, summarize, mutate
# rename, arrange, count

# select to grab columns
year_country_gdp <- select(gapminder, year, country, gdpPercap)
View(year_country_gdp)

# select with - to grab everything but
smaller_gapminder_data <- select(gapminder, -continent)

# The Tidy Pipe: %>% 
year_country_gdp2 <- gapminder %>%
  select(year, country, gdpPercap) 

# rename; rename(new_name = oldname)
tidy_gdp <- smaller_gapminder_data %>%
  rename(gdp_per_capita = gdpPercap)
View(tidy_gdp)  

# filter; grabs observations based on criteria
europe_df <- gapminder %>%
  filter(continent == "Europe") %>% 
  select(year, country, gdpPercap)

# the | is OR in R
europe_africa <- gapminder %>%
  filter(continent == "Europe" | continent == "Africa" ) %>% 
  select(year, country, gdpPercap)

europe_2007 <- gapminder %>%
  filter(continent == "Europe", year == 2007)

# group_by and summarize
gapminder %>% 
  group_by(continent) %>%
  summarize(mean_gdp = mean(gdpPercap))

# you can group_by more than one variable
gapminder %>% 
  group_by(continent, year) %>%
  summarize(mean_gdp = mean(gdpPercap))

View(europe_df)

# combining dplyr (filter) and ggplot
gapminder %>%
  filter(continent == "Americas") %>% 
  ggplot(mapping = aes(x = year, y = lifeExp)) + 
  geom_line() + facet_wrap(~country) + theme(axis.text.x = element_text(angle = 45))

# mutate - creating a new variable based on variables you already have
gapminder_rank <- gapminder %>% 
  filter(year == 1957) %>% 
  mutate(pop_rank = rank(pop)) %>%
  arrange(pop_rank)

View(gapminder_rank)

# tidyr -----------------------------------

# download the wide gapminder dataset and read in from your data folder
gap_wide <- read.csv("data/gapminder_wide.csv")

# flipping from wide to long; pivot_longer function
gap_long <- gap_wide %>%
  pivot_longer(
    cols = c(starts_with('pop'), starts_with('lifeExp'), starts_with('gdpPercap')), names_to = "obstype_year", values_to = "obs_values"
  )

# separating the column into two parts
gap_long <- gap_long %>%
  separate(obstype_year, into = c("obs_type", "year"), sep = "_")

# turning the year into an integer (currently a character)
gap_long$year <- as.integer(gap_long$year) 
str(gap_long)