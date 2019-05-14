
# Open a new Script

# Import dataset ChickWeight

library(datasets)
data(ChickWeight)
View(ChickWeight)
str(ChickWeight)

# calculate mean weight

mean(ChickWeight$weight)

# Create new variable -  deviation from mean weight

ChickWeight$Deviation <-ChickWeight$weight-121.81

# Loop, if-statement (ifelse - selected from either yes or no depending on whether the element of test is TRUE or FALSE)

for(a in 1:nrow(ChickWeight)){
  ChickWeight$Obese<- ifelse(ChickWeight$Deviation < 100,"Normal","Obese")
}


### plots

plot(ChickWeight$weight)
plot(ChickWeight$Diet, ChickWeight$weight)

hist(ChickWeight$Deviation)
