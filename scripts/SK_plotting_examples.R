library(tidyverse)
library(gapminder)

# Default colors
ggplot(gapminder, aes(x = log(gdpPercap), y = lifeExp, color = continent)) + geom_point()

?scale_color_manual # function from ggplot2
colors()

# with layer scale_color_manual
ggplot(gapminder, aes(x = log(gdpPercap), y = lifeExp, color = continent)) + geom_point() + scale_color_manual(values = c("steelblue", "orchid1", "maroon1", "turquoise1", "seagreen"))

# Boxplot with default colors
ggplot(gapminder, aes(x = continent, y = lifeExp, fill = continent)) + geom_boxplot() 

# with layer scale_fill_manual
ggplot(gapminder, aes(x = continent, y = lifeExp, fill = continent)) + geom_boxplot() + scale_fill_manual(values = c("steelblue", "violet", "yellow2", "turquoise3", "seagreen"))

# added facet wrap by year
ggplot(gapminder, aes(x = continent, y = lifeExp, fill = continent)) + geom_boxplot() + facet_wrap (~ year) + scale_fill_manual(values = c("steelblue", "violet", "yellow2", "turquoise3", "wheat2"))


?theme #function from ggplot2

# theme = x axis blank, x ticks blank
ggplot(gapminder, aes(x = continent, y = lifeExp, fill = continent)) + geom_boxplot() + facet_wrap (~ year) + labs(y = "Life Expectancy", x = NULL) + theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())

# Removing the legend
ggplot(gapminder, aes(x = continent, y = lifeExp, fill = continent)) + geom_boxplot() + facet_wrap (~ year) + labs(y = "Life Expectancy", x = NULL) + theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), legend.position = "none")

# Other common geoms
geom_point()
geom_boxplot()
geom_line()
geom_histogram()
geom_bar()
geom_col()

# adding a note

