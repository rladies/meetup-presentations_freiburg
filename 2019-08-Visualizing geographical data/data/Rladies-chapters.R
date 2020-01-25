setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

rladies <- read_csv("RLadiesChapters.csv")


library(ggplot2)
library(maps)
library(ggthemes)

world <- ggplot() +
  borders("world", colour = "gray85", fill = "gray80") +
  theme_map() 

map <- world +
  geom_point(aes(x = lon, y = lat, size = members),
             data = rladies, 
             colour = 'purple', alpha = .5) +
  scale_size_continuous(range = c(1, 8), 
                        breaks = c(250, 500, 750, 1000)) +
  labs(size = 'Followers')

map

ggplot() + theme_map() + 
  borders("world", colour = "gray85", # borders 
          fill = "gray80") + #fill
  theme_map()

ggplot() + theme_map() + 
  borders("world", colour = "black", fill = "gray80") +
  theme_map() +
  expand_limits(x = 30, y = map$lat)

countries <- c("Germany")
some.maps <- map_data("world", region = countries)

region.lab.data <- some.maps %>%
  group_by(region) %>%
  summarise(long = mean(long), lat = mean(lat))
region.lab.data

ggplot(some.maps, aes(x = long, y = lat)) +
  geom_polygon(aes( group = group, fill = region))+
  geom_text(aes(label = region), data = region.lab.data,  size = 3, hjust = 0.5)+
  scale_fill_viridis_d()+
  theme_void()+
  theme(legend.position = "none")

square=data.frame(lat = c(52, 50, 50, 52), long = c(14,14,13,13))
ggplot(square, aes(x = long, y = lat)) +
  geom_polygon()

square=data.frame(lat = c(52, 51, 50, 50, 52), long = c(14,13.5,14,13,13)) # from top right following the clock
ggplot(square, aes(x = long, y = lat)) +
  geom_polygon()


# Some EU Contries
some.eu.countries <- c(
  "Portugal", "Spain", "France", "Switzerland", "Germany",
  "Austria", "Belgium", "UK", "Netherlands",
  "Denmark", "Poland", "Italy", 
  "Croatia", "Slovenia", "Hungary", "Slovakia",
  "Czech republic"
)
# Retrievethe map data
some.eu.maps <- map_data("world", region = some.eu.countries)

# Compute the centroid as the mean longitude and lattitude
# Used as label coordinate for country's names
region.lab.data <- some.eu.maps %>%
  group_by(region) %>%
  summarise(long = mean(long), lat = mean(lat))



life.exp <- get_data("WHOSIS_000001")             # Retrieve the data
life.exp <- life.exp %>%
  filter(year == 2015 & sex == "Both sexes") %>%  # Keep data for 2015 and for both sex
  select(country, value) %>%                      # Select the two columns of interest
  rename(region = country, lifeExp = value) %>%   # Rename columns
  # Replace "United States of America" by USA in the region column
  mutate(
    region = ifelse(region == "United States of America", "USA", region)
  )          
