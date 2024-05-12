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

# Exercise, Challenge 1
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

# Exercise, Challenge 2: Checking the last few lines and middle of the dataset
tail(gapminder)
tail(gapminder, n = 15)
# Middle using a nested function
gapminder[sample(nrow(gapminder), 5), ] #go over this carefully

# Exercise, Challenge 3: Write a script to load the gapminder dataset, save it, and run the script with source function
# File --> new file --> R script --> write script to load the data --> save to scripts directory
dir.create("scripts")
source(file = "scripts/load-gapminder.R")

# Exercise, Challenge 4: Read the output of str() again and interpret based on what you know re: lists, vectors, colnames, dim; discuss with neighbors
str(gapminder)

########################
# Episode 8 - Creating Publication-Quality Graphics with ggplot2

# Three main plotting systems in R: Base plotting, lattice package, ggplot2 package
# ggplot is built on the grammar of graphics: data set, mapping aesthetics, and graphical layers

library("ggplot2")
ggplot(data = gapminder)
# Note: Any of the arguments we give the ggplot function are the GLOBAL options for the plot and they apply to all layers on the plot

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp))
# Note: aes tells ggplot how variables in the data map to AESTHETIC properties of the figure

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point()
# Note: Now we tell ggplot how we want to visually represent the daa We do this by adding a new layer using one of the geom functions

# Exercise, Challenge 1: Modify the code so that the figure shows how life expectancy has changed over time
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point()
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp)) + geom_point() # This looks like garbage, but it prepares learners for the second exercise

# Exercise, Challenge 2: Modify the code to add color to the continent column; What trends do you see? 
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color=continent)) +
  geom_point() # okay, so now the plot looks better

# Layers
# Let's switch the scatterplot to a line plot
ggplot(data = gapminder, mapping = aes(x=year, y=lifeExp, color=continent)) +
  geom_line() #doesn't look great either....let's try to separate the data by country, plotting one line for each

ggplot(data = gapminder, mapping = aes(x=year, y=lifeExp, group=country, color=continent)) +
  geom_line()
# NOTE: We added the GROUP aesthetic, which tells ggplot to draw a line for each county
# SK note: https://ggplot2.tidyverse.org/reference/aes_group_order.html?q=group#null

# What if we want to visualize both lines and points on the plot? We can add another layer
ggplot(data = gapminder, mapping = aes(x=year, y=lifeExp, group=country, color=continent)) +
  geom_line() + geom_point()
# It's important to note that each layer is drawn on top of the previous layer. In this case, points have been drawn on top of the lines. You can see it better here: 
ggplot(data = gapminder, mapping = aes(x=year, y=lifeExp, group=country)) +
  geom_line(mapping = aes(color=continent)) + geom_point()
# In this example, the aesthetic mapping of color has been moved from the global plot options in ggplot to the geom_line layer so it no longer applies to the points. Now we can clearly see that the points are drawn on top of the lines.

# Tip: So far, we’ve seen how to use an aesthetic (such as color) as a mapping to a variable in the data. For example, when we use geom_line(mapping = aes(color=continent)), ggplot will give a different color to each continent. But what if we want to change the color of all lines to blue? # SK Building Examples Below (not in content):
# SK Blue Lines: 
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, group = country, color = continent)) + geom_line(color = "blue") + geom_point()
# SK Blue Points: 
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, group = country, color = continent)) + geom_line() + geom_point(color = "blue")

# Exercise, Challenge 3: Switch the order of the point and line layers from the previous example (line 145-146, prior to SK add-ons). What happens? 
ggplot(data = gapminder, mapping = aes(x=year, y=lifeExp, group=country)) + geom_point() + 
  geom_line(mapping = aes(color=continent)) 

# Transformations and Statistics
# ggplot2 makes it easy to overlay statistical models over the data. To demonstrate, we'll go back to our first example. 
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point()
# We can change the units on the x axis using the scale functions. hese control the mapping between the data values and visual values of an aesthetic. We can also modify the transparency of the points, using the alpha function, which is especially helpful when you have a large amount of data which is very clustered.
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point(alpha = 0.5) + scale_x_log10() # logarithmic x-axis
# SK NOTE: be prepared to answer question about log scales; from SC content: The scale_x_log10 function applied a transformation to the coordinate system of the plot, so that each multiple of 10 is evenly spaced from left to right. For example, a GDP per capita of 1,000 is the same horizontal distance away from a value of 10,000 as the 10,000 value is from 100,000. This helps to visualize the spread of the data along the x-axis.

# Tip: Notice that we used geom_point(alpha = 0.5). Alpha can also be mapped to a variable in the data. For example, we can give a different transparency to each continent with geom_point(mapping = aes(alpha = continent)).
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point(mapping = aes(alpha = continent)) + scale_x_log10() # Console Warning: Using alpha for discrete variable is not advised; let's skip for SC beginners

# We can fit a simple relationship to the data by adding another layer, geom_smooth: 
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5) + scale_x_log10() + geom_smooth(method="lm")
# SK NOTE: There is no discussion about what's happening here; it just moves on to changing the line width. Be prepared to answer questions about linear models and geom_smooth()

# We can make the line thicker by setting the size aesthetic in the geom_smooth layer: 
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5) + scale_x_log10() + geom_smooth(method="lm", size=1.5)
# NOTE: this gives you a warning and tells you to use linewidth instead of size so let's just teach that directly
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5) + scale_x_log10() + geom_smooth(method="lm", linewidth=1.5) # that's better

# Exercise, Challenge 4A: Modify the color and size of the points on the point layer in the previous example. Do not use the aes function
# SK note: they won't know size = yet because we used linewidth = in the previous example
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(size=3, color="orange") + scale_x_log10() +
  geom_smooth(method="lm", size=1.5)

# Exercise, Challenge 4B: Modify 4A plot so that the points are now a different shape and are colored by continent with new trendlines. The color argument can be used inside the aesthetic. 
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point(size=3, shape=17) + scale_x_log10() +
  geom_smooth(method="lm", size=1.5)

# Multi-Panel Figures
# Earlier we visualized the change in life expectancy over time across all countries in one plot. We also also split this out over multiple plots
# Tip: We start by making a subset of data including only countries located in the Americas. This includes 25 countries, which will begin to clutter the figure. Note that we apply a “theme” definition to rotate the x-axis labels to maintain readability. 
# SK Note: Make this easier for learners (i.e., perhaps without the theme, or an easier theme)
americas <- gapminder[gapminder$continent == "Americas",]

ggplot(data = americas, mapping = aes(x = year, y = lifeExp)) +
  geom_line() +
  facet_wrap( ~ country) +
  theme(axis.text.x = element_text(angle = 45))

# Modifying Text
# To clean this figure up for a publication we need to change some of the text elements. The x-axis is too cluttered, and the y axis should read “Life expectancy”, rather than the column name in the data frame. We can do this by adding a couple of different layers. The theme layer controls the axis text, and overall text size. Labels for the axes, plot title and any legend can be set using the labs function. Legend titles are set using the same names we used in the aes specification. Thus below the color legend title is set using color = "Continent", while the title of a fill legend would be set using fill = "MyTitle".

ggplot(data = americas, mapping = aes(x = year, y = lifeExp, color=continent)) +
  geom_line() + facet_wrap( ~ country) +
  labs(x = "Year", y = "Life expectancy", title = "Figure 1", color = "Continent") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Exporting the Plot
# The ggsave() function allows you to export a plot created with ggplot. You can specify the dimension and resolution of your plot by adjusting the appropriate arguments (width, height and dpi) to create high quality graphics for publication. In order to save the plot from above, we first assign it to a variable lifeExp_plot, then tell ggsave to save that plot in png format to a directory called results. Make sure you have a results/ folder in your working directory.

dir.create("results")

lifeExp_plot <- ggplot(data = americas, mapping = aes(x = year, y = lifeExp, color=continent)) +
  geom_line() + facet_wrap( ~ country) +
  labs(x = "Year", y = "Life expectancy", title = "Figure 1", color = "Continent") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggsave(filename = "results/lifeExp.png", plot = lifeExp_plot, width = 12, height = 10, dpi = 300, units = "cm")
# The dimensions look off in this plot. You can read it. Let me change it. 

# SK: I added code to remove the legend
Take2Plot <- ggplot(data = americas, mapping = aes(x = year, y = lifeExp, color=continent)) +
  geom_line() + facet_wrap( ~ country) + theme(legend.position = "none") + 
  labs(x = "Year", y = "Life expectancy", title = "Figure 1") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# This looks way cleaner than their plot; show this example 
ggsave(filename = "results/Take2Plot.png", plot = Take2Plot)

# There are two nice things about ggsave. First, it defaults to the last plot, so if you omit the plot argument it will automatically save the last plot you created with ggplot. Secondly, it tries to determine the format you want to save your plot in from the file extension you provide for the filename (for example .png or .pdf). If you need to, you can specify the format explicitly in the device argument.

# Exercise, Challenge 5: Generate boxplots to compare life expectancy between the different continents during the available years. Advanced: rename y axis as Life Expectancy. Advanced: Remove x axis labels

ggplot(data = gapminder, mapping = aes(x = continent, y = lifeExp, fill = continent)) +
  geom_boxplot() + facet_wrap(~year) +
  ylab("Life Expectancy") +
  theme(axis.title.x=element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

########################
# Episode 12 - Data Frame Manipulation with dplyr

# Getting summary stats with Base R 
mean(gapminder$gdpPercap[gapminder$continent == "Africa"])
mean(gapminder$gdpPercap[gapminder$continent == "Americas"])
mean(gapminder$gdpPercap[gapminder$continent == "Asia"])

# dplyr package
library(dplyr)
# select, %, filter, group_by, summarize, mutate
# also: rename, arrange, count, n
# also see: substr, theme, if_else, sample_n

# select
# creating a new dataframe with only three of the gapminder variables
year_country_gdp <- select(gapminder, year, country, gdpPercap)

# creating a new dataframe with every variable except continent
smaller_gapminder_data <- select(gapminder, - continent)

# same code as above but with the pipe
year_country_gdp <- gapminder %>%
  select(year, country, gdpPercap)

# rename: rename(new_name = old_name)
tidy_gdp <- year_country_gdp %>%
  rename(gdp_per_capita = gdpPercap)
# to see the new variable name
head(tidy_gdp)

# filter
# the code above, but only for Europe
year_country_gdp_euro <- gapminder %>%
  filter(continent == "Europe") %>%
  select(year, country, gdpPercap)
# Notice: country, but not continent is in the new dataframe

# Life expectancy of Europen countries but for a specific year
europe_lifeExp_2007 <- gapminder %>%
  filter(continent == "Europe", year == 2007) %>%
  select(country, lifeExp)

# Exercise, Challenge 1: Create a datafrma with African values for lifeExp, country, and year, but not for other continents
year_country_lifeExp_Africa <- gapminder %>%
  filter(continent == "Africa") %>%
  select(year, country, lifeExp)
# NOTE: order of operation is important. If you used select first, you can't filter by continent because it's been removed

# group_by
str(gapminder) # see data.frame in output

str(gapminder %>%
      group_by(continent)) # see groupd_df in output; groups 
# the structure of the data frame is different; a grouped_df can be thought of as a list where each item in the list is a data.frame which contains only the rows that correspond to the particular value (in this case, continent)

# summarize
# group_by is much more exciting when used with summarize
# we split our original data frame into multiple pieces, then we run functions on those pieces with summarize
gpd_bycontinents <- gapminder %>%
  group_by(continent) %>%
  summarize(mean_gdpPercap = mean(gdpPercap))

# Exercise, Challenge 2: Calculate the average life expectancy per country. What has the longest, and what has the shortest? 
lifeExp_bycountry <- gapminder %>%
  group_by(country) %>%
  summarize(mean_lifeExp = mean(lifeExp)) # to get average lifeExp by country

lifeExp_bycountry %>%
  arrange(mean_lifeExp) # shortest

lifeExp_bycountry %>%
  arrange(desc(mean_lifeExp)) # longest
  
# Another way (a little trickier): 
lifeExp_bycountry %>%
  filter(mean_lifeExp == min(mean_lifeExp) | mean_lifeExp == max(mean_lifeExp))

# group_by allows you to group by multiple columns
# now we'll group_by year AND continent, and then summarize
gdp_bycontinents_byyear <- gapminder %>%
  group_by(continent, year) %>%
  summarize(mean_gdpPercap = mean(gdpPercap))

# SK: Too many objects; either don't create object every time, or remind folks to sweep environment pane 
gdp_pop_bycontinents_byyear <- gapminder %>%
  group_by(continent, year) %>%
  summarize(mean_gdpPercap = mean(gdpPercap), 
            sd_gdpPercap = sd(gdpPercap), 
            mean_pop = mean(pop), 
            sd_pop = sd(pop))

# count() and n()
# SK: cover count, but skip n()? 
# count the number of observations for each group
# let's see the number of countries in the dataset for 2002
gapminder %>%
  filter(year == 2002) %>% 
  count(continent, sort = T) #sort is an optional argument

# if we need to use number of observations in calculations, n() is useful
# it will return the total number of observations in the current group rather than counting the number of observations in each group
# standard error of life expectancy per continent
gapminder %>% 
  group_by(continent) %>% 
  summarize(se_le = sd(lifeExp)/sqrt(n()))

# several summary operations
gapminder %>% 
  group_by(continent) %>% 
  summarize(
    mean_le = mean(lifeExp), 
    min_le = min(lifeExp), 
    max_le = max(lifeExp), 
    se_le = sd(lifeExp)/sqrt(n()))

# mutate
# SK: such long examples for mutate section, consider simplifying
gdp_pop_bycontinents_byyear <- gapminder %>%
  mutate(gdp_billion = gdpPercap*pop / 10^9) %>% 
  group_by(continent, year) %>% 
  summarize(mean_gdpPercap = mean(gdpPercap), 
            sd_gdpPercap = sd(gdpPercap), 
            mean_pop = mean(pop), 
            sd_pop = sd(pop), 
            mean_gdp_billion = mean(gdp_billion), 
            sd_gdp_billion = sd(gdp_billion))


# Connect mutate with logical filtering: ifelse
# SK: is ifelse covered earlier? 
# when creating new variables, we can connect this with a logical condition
# keeping all data but filtering after a certain condition
# calculate GDP only for people with life expectation about 25
gdp_pop_bycontinents_byyear_above25 <- gapminder %>% 
  mutate(gdp_billion = ifelse(lifeExp > 25, gdpPercap * pop / 10^9, NA)) %>% 
  group_by(continent, year) %>% 
  summarize(mean_gdpPercap = mean(gdpPercap), 
            sd_gdpPercap = sd(gdpPercap), 
            mean_pop = mean(pop), 
            sd_pop = sd(pop), 
            mean_gdp_billion = mean(gdp_billion), 
            sd_gdp_billion = sd(gdp_billion))

# updating if certain condition is fulfilled
# for life expectations about 40, the gdp to be expected in the future is scaled
gdp_pop_bycontinents_byyear_high_lifeExp <- gapminder %>% 
  mutate(gdp_futureExpectation = ifelse(lifeExp > 40, gdpPercap * 1.5, gdpPercap)) %>% 
  group_by(continent, year) %>% 
  summarize(mean_gdpPercap = mean(gdpPercap), 
            mean_gdpPercap_expected = mean(gdp_futureExpectation))

# Combining dplyr and ggplot2

library(ggplot2)

# creating an intermediate object, then plotting
americas <- gapminder[gapminder$continent == "Americas", ]

ggplot(data = americas, mapping = aes(x = year, y = lifeExp)) + geom_line() + facet_wrap(~ country) + theme(axis.text.x = element_text(angle = 45)) # note: be sure to use axis.text.x and not axis.title.x

# Here's the same thing but without creating an intermediate object
gapminder %>% 
  filter(continent == "Americas") %>% 
  ggplot(mapping = aes(x = year, y = lifeExp)) %>% 
  geom_line() + facet_wrap(~country) + theme(axis.text.x = element_text(angle = 45))

# Combining mutate and ggplot
# SK: why did they use startsWith (Base) vs. starts_with (dplyr)?
# SK: this has a lot of new elements that might be too overwhelming

gapminder %>% 
  # extract first letter of country name into new column
  mutate(startsWith = substr(country, 1, 1)) %>% 
  # only keep countries starting with A or Z
  filter(startsWith %in% c("A", "Z")) %>% 
  # plot lifeExp into facets
  ggplot(aes(x = year, y = lifeExp, color = continent)) + 
  geom_line() + 
  facet_wrap(vars(country)) + theme_minimal() #not sure why use: vars(country) when (~ country) works the same

# Exercise, Advanced Challenge: calculate average life expectancy in 2002 of two random countries for each continent. Then arrange in reverse order. Hint: arrange() and sample_n()

lifeExp_2countries_bycontinents <- gapminder %>% 
  filter(year == 2002) %>% 
  group_by(continent) %>% 
  sample_n(2) %>% 
  summarize(mean_lifeExp = mean(lifeExp)) %>% 
  arrange(desc(mean_lifeExp))

lifeExp_2countries_bycontinents

# SK: probably skip that exercise unless we do it in two steps. Otherwise learners don't even see which two countries were grabbed per continent before the summarize function
step1 <- gapminder %>% 
  filter(year == 2002) %>% 
  group_by(continent) %>% 
  sample_n(2)

step2 <- step1 %>% 
  summarize(mean_lifeExp = mean(lifeExp)) %>% 
  arrange(desc(mean_lifeExp))

########################
# Episode 13 - Data Frame Manipulation with tidyr

library(tidyr)

str(gapminder)
# Exercise, Challenge 1: Is gapminder a purely long, purely wide, or some intermediate format? 
# Solution: intermediate; We have three ID variables (continent, country, year) and three observation variables (pop, lifeExp, gdpPercap)

# Download the wide version (csv) of gapminder and save to you data folder
# Load the data file and look at it 
# SK: it says to use the stringsAsFactors = F argument but that's not necessary anymore after R 4.0; see: https://stackoverflow.com/questions/61950876/read-csv-doesnt-seem-to-detect-factors-in-r-4-0-0
# SK: Why are they using read.csv and not read_csv? Probably to import as a data.frame rather than a tibble

gap_wide <- read.csv("data/gapminder_wide.csv")
str(gap_wide)
View(gap_wide)

# pivot_longer() reduces # of columns, increases # of rows
# pivotlonger(data, cols = c("a1", "a2", "a3"), names_to = "key", values_to = "value")

gap_long <- gap_wide %>% 
  pivot_longer(cols = c(starts_with('pop'), starts_with('lifeExp'), starts_with('gdpPercap')), names_to = "obstype_year", values_to = "obs_values")

str(gap_long)

# Another way to do it
gap_long2 <- gap_wide %>% 
  pivot_longer(cols = c(-continent, -country), names_to = "obstype_year", values_to = "obs_values")
str(gap_long2)

# The obstrype_year has two parts so we need to separate those
# Note: we are overwriting the dataset
gap_long <- gap_long %>% 
  separate(obstype_year, into = c("obs_type", "year"), sep = "_")
str(gap_long) #SK: see year is a character
gap_long$year <- as.integer(gap_long$year)
str(gap_long)

# Exercise, Challenge 2: using gap_long, calculate mean life expectancy, pop, and gdpPercap for each continent; Hint: group_by and summarize
gap_long %>% 
  group_by(continent, obs_type) %>% 
  summarize(means = mean(obs_values))

# From long to intermediate format
# Skip this section (and just cover from long to wide)

# pivot long to intermediate format
gap_normal <- gap_long %>% 
  pivot_wider(names_from = obs_type, values_from = obs_values)
dim(gap_normal)

names(gap_normal)
names(gapminder) #different ordering

gap_normal <- gap_normal[, names(gapminder)]
all.equal(gap_normal, gapminder)

head(gap_normal)
head(gapminder)

gap_normal <- gap_normal %>% 
  arrange(country, year)

all.equal(gap_normal, gapminder)

# Now Long to Wide - Note: these steps are repeating, can cut content
gap_temp <- gap_long %>% 
  unite(var_ID, continent, country, sep = "_")
str(gap_temp)

gap_temp <- gap_long %>% 
  unite(ID_var, continent, country, sep = "_") %>% 
  unite(var_names, obs_type, year, sep = "_")
str(gap_temp)
# Using unite, we now have a single ID variable which is a combination of continent and country and we have defined variable names. Now ready to pivot_wider

gap_wide_new <- gap_long %>% 
  unite(ID_var, continent, country, sep = "_") %>% 
  unite(var_names, obs_type, year, sep = "_") %>% 
  pivot_wider(names_from = var_names, values_from = obs_values)
str(gap_wide_new)
View(gap_wide_new)

# Now separating the ID_var
gap_wide_betterID <- separate(gap_wide_new, ID_var, c("continent", "country"), sep = "_")

gap_wide_betterID <- gap_long %>% 
  unite(ID_var, continent, country, sep = "_") %>% 
  unite(var_names, obs_type, year, sep = "_") %>% 
  pivot_wider(names_from = var_names, values_from = obs_values) %>% 
  separate(ID_var, c("continent", "country"), sep = "_")
str(gap_wide_betterID)
dim(gap_wide_betterID)
View(gap_wide_betterID)
