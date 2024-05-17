cats
age <- c(2, 3, 5)

cats <- cbind(cats, age)
cats

length(cats)

newRow <- list("tortoiseshell", 3.3, 1, 9)

cats <- rbind(cats, newRow)
cats

cats[-4, ]

cats
cats[,-4]

rbind(cats, cats)

df <- data.frame(id = c("a", "b", "c"), 
                 x = 1:3, 
                 y = c(TRUE, TRUE, FALSE))

exercise <- data.frame(first = c("Savannah"), 
                       last = c("Kelly"), 
                       lucky_number = c(32))

exercise <- rbind(exercise, list("First", "Last", 500))
exercise <- cbind(exercise, coffee = c(TRUE, TRUE))

View(exercise)

# Import gapminder csv data

gapminder <- read.csv("data/gapminder_data.csv")

View(gapminder)

str(gapminder)
summary(gapminder)
typeof(gapminder$country)

length(gapminder)
typeof(gapminder)

nrow(gapminder)
ncol(gapminder)
dim(gapminder) #dimensions

head(gapminder, 2)
tail(gapminder)

rm(gapminder)

source(file = "script/load_gapminder.R")

#________________ ggplot _________________

library(tidyverse)

# ggplot: data, aes mapping, geom / layers

ggplot(data = gapminder)

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point()

ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp)) + geom_point()

ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color = continent)) + geom_point()

ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color = continent)) + geom_line()

ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color = continent, group = country)) + geom_line()

# Global mapping; what's applied in the aes is applied across both geoms
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color = continent, group = country)) + geom_line() + geom_point()

# local mapping of color to only lines
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color = continent, group = country)) + geom_line(color = "blue") + geom_point()

ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color = continent, group = country)) + geom_line() + geom_point(color = "blue")

# Transformations and Stats

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point()

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point() + scale_x_log10()

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point(color = "steelblue1") + scale_x_log10()

colors()

#alpha is transparency
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point(alpha = 0.3) + scale_x_log10()

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point(alpha = 0.3) + scale_x_log10() + geom_smooth(method = "lm", size = 1.5)

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + geom_point(color = "green", size = 3) + scale_x_log10() + geom_smooth(method = "lm", size = 1.5)

ggplot(gapminder, mapping = aes(x = gdpPercap, y = lifeExp, color = continent)) + geom_point(size = 2, shape = 17) + scale_x_log10() + geom_smooth(method = "lm")

# grab the americas data
americas <- gapminder[gapminder$continent == "Americas", ]

ggplot(americas, mapping = aes(x = year, y = lifeExp, color = continent)) + geom_line() + facet_wrap(~country) + labs(x = "Year", y = "Life Expectancy", title = "Figure 1", color = "Continent") + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + theme(legend.position = "none")

ggsave("plots/Americas.png")

# Dplyr
mean(gapminder$gdpPercap[gapminder$continent == "Americas"])
mean(gapminder$gdpPercap[gapminder$continent == "Africa"])
mean(gapminder$gdpPercap[gapminder$continent == "Asia"])

# select, filter, group_by, summarize, mutate
# rename, arrange, count

year_country_gdp <- select(gapminder, year, country, gdpPercap)
View(year_country_gdp)

library(tidyverse)
gapminder <- read.csv("data/gapminder_data.csv")
smaller_gapminder_data <- select(gapminder, -continent)

# The Tidy Pipe: %>% %>% %>% 
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

europe_africa <- gapminder %>%
  filter(continent == "Europe" | continent == "Africa" ) %>% 
  select(year, country, gdpPercap)

europe_2007 <- gapminder %>%
  filter(continent == "Europe", year == 2007)

%in% c(1997, 2003)

# group_by
grouped_continents <- 
  
  gapminder %>% 
  group_by(continent) %>%
  summarize(mean_gdp = mean(gdpPercap))

gapminder %>% 
  group_by(continent, year) %>%
  summarize(mean_gdp = mean(gdpPercap))

View(europe_df)

gapminder %>%
  filter(continent == "Americas") %>% 
  ggplot(mapping = aes(x = year, y = lifeExp)) + 
  geom_line() + facet_wrap(~country) + theme(axis.text.x = element_text(angle = 45))

?rank

gapminder_rank <- gapminder %>% 
  filter(year == 1957) %>% 
  mutate(pop_rank = rank(pop)) %>%
  arrange(pop_rank)

View(gapminder_rank)

# tidyr
library(tidyverse)

gap_wide <- read.csv("data/gapminder_wide.csv")

gap_long <- gap_wide %>%
  pivot_longer(
    cols = c(starts_with('pop'), starts_with('lifeExp'), starts_with('gdpPercap')), names_to = "obstype_year", values_to = "obs_values"
  )

gap_long <- gap_long %>%
  separate(obstype_year, into = c("obs_type", "year"), sep = "_")
gap_long$year <- as.integer(gap_long$year)
str(gap_long)