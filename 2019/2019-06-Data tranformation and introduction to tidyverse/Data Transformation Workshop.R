
## Data Transformation and Introduction to Tidyverse Workshop

india.districts.census.2011 <- read.csv("E:/R-Ladies/R-Ladies/India-Census-2011-Analysis-master/india-districts-census-2011.csv")
str(india.districts.census.2011)

## Tidyverse

#install.packages("tidyverse")
library(tidyverse)

## Filter - Only data from Maharashtra and Gajarat

WestStates <- filter(india.districts.census.2011, State.name =='MAHARASHTRA'| State.name =='GUJARAT')

## Arrange - based on agricultural workers

AgriDist<- arrange(WestStates, Agricultural_Workers)
AgriDistDes<- arrange(WestStates, desc(Agricultural_Workers))

## Mutate - computers and internet in terms of percentage of households

IndCen2011Calculations<- mutate(india.districts.census.2011, PercentInternet = Households_with_Internet / Households * 100,
       PercentComputer = Households_with_Computer / Households * 100)


## Select - data on households with latrines and bathing facilities

ModernHomes<-select(india.districts.census.2011, State.name, District.name, Households, Having_bathing_facility_Total_Households,
                  Having_latrine_facility_within_the_premises_Total_Households)

## standardize the results - percentage

ModernHomes2<-mutate(ModernHomes, PercentToilet = Having_latrine_facility_within_the_premises_Total_Households / Households * 100,
                     PercentBath = Having_bathing_facility_Total_Households / Households * 100)

## Visualize

## ggplot to visualize this data

options(scipen=999)  # turn-off scientific notation like 1e+48
library(ggplot2)

ModernHomesPlot <- ggplot(ModernHomes2, aes(x=PercentToilet, y=PercentBath)) + 
  geom_point(aes(col=State.name, size=Households)) + 
  geom_smooth(method="glm", se=T) + 
  labs(subtitle="Toilets and Baths", 
       y="Percentage with Bath", 
       x="Percentage with Toilet", 
       title="Scatterplot", 
       caption = "Indian Census 2011")

plot(ModernHomesPlot)


## Summarize - group by state

summarize(india.districts.census.2011, PercentLiterate = mean(Literate/Population*100))
Literacy<-group_by(india.districts.census.2011, State.name)
LiteracyByState<-summarize(Literacy, PercentLiterate = mean(Literate/Population*100))

## Exercise - Literacy - Hygiene Relationship

LiteracyHygiene <- select(india.districts.census.2011, State.name, District.name, Literate, Households, Having_latrine_facility_within_the_premises_Total_Households)
LiteracyHygiene_Calculated<-mutate(LiteracyHygiene, PercentToilet = Having_latrine_facility_within_the_premises_Total_Households / Households * 100,
                     AverageLiterate = Literate/Households)

LiteracyHygienePlot <- ggplot(LiteracyHygiene_Calculated, aes(x=PercentToilet, y=AverageLiterate)) + 
  geom_point(aes(col=State.name, size=Households)) + 
  geom_smooth(method="glm", se=T) + 
  labs(subtitle="Toilets and Baths", 
       y="Average Literate People per Household", 
       x="Percentage with Toilet", 
       title="Scatterplot", 
       caption = "Indian Census 2011")

plot(LiteracyHygienePlot)

library(plotly)
ggplotly(LiteracyHygienePlot)

