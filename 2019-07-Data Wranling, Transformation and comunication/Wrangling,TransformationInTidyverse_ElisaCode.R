library(tidyr)
library(dplyr)
candy <- read_csv("RLadies/candyhierarchy2017.csv")
str(candy)
nrow(candy)
ncol(candy)
sum(is.na(candy))

colnames(candy)

tidy.candy <- candy[,7:109] %>% gather ("candy", "answer")

meh <- tidy.candy %>% filter (answer =="MEH") %>% group_by (candy) %>%  summarise (n())


despair <- tidy.candy %>% 
  group_by (candy) %>% 
  filter (answer =="DESPAIR") %>%  
  summarise (n())

joy <- tidy.candy %>% group_by (candy) %>% filter (answer =="JOY") %>%  summarise (n())


sum.candy <- left_join(joy, despair, by="candy")


cbind(joy$candy, joy$`n()`, despair$`n()`)

colnames(sum.candy) <- c("candy", "JOY", "DESPAIR")
sum.candy

################ plot

library(ggplot2)


sum.candy %>% ggplot(aes(x=DESPAIR, y=JOY)) +
  geom_point(aes(col=candy)) +
  theme(legend.title = element_blank()) 



CandyPlot<-ggplot(sum.candy, aes(x=JOY, y=DESPAIR)) + 
  geom_point(aes(col=candy)) + 
  labs(subtitle="Halloween Candy 2017", 
       y="Despair", 
       x="Joy", 
       title="Scatterplot", 
       caption = "From Candy Heirarchy Data")

ggplotly(CandyPlot)

