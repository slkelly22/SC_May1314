library(tidyverse)
library(gapminder)

mean(gapminder$gdpPercap) #Base R to call the mean on the entire dataframe

mean(gapminder$gdpPercap[gapminder$continent == "Africa"]) # Base R to call the mean on a subset of the data

mean(gapminder$gdpPercap[gapminder$continent == "Africa" & gapminder$continent == "Americas"])

# New mutate example
View(gapminder)
?rank

gapminder_rank <- gapminder %>%
  filter(year == 1957) %>%
  mutate(pop_rank = rank(pop)) %>% 
  arrange(pop_rank)
         
gapminder_with_ranks <- gapminder %>%
  filter(year == 1957) %>%
  mutate(pop_rank = rank(pop), 
         lifeExp_rank = rank(lifeExp)) %>%
  arrange((lifeExp))

nrow(gapminder_rank)
gapminder_rank[71, ]
