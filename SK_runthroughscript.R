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
# Episode 13 - Creating Publication-Quality Graphics with ggplot2

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



