######
#
# R Ladies Freiburg Meetup
# Modelling part 3
# Exercise 
# Elisa Schneider, 4th December
#
######

require(neuralnet)
require(nnet)
require(ggplot2)

wines <- read.csv("wines.csv")
names(wines) <- c("label",
                  "Alcohol",
                  "Malic_acid",
                  "Ash",
                  "Alcalinity_of_ash",
                  "Magnesium",
                  "Total_phenols",
                  "Flavanoids",
                  "Nonflavanoid_phenols",
                  "Proanthocyanins",
                  "Color_intensity",
                  "Hue",
                  "OD280_OD315_of_diluted_wines",
                  "Proline")

head(wines)

#Plot the data

plt1 <- ggplot(wines, aes(x = Alcohol, y = Magnesium, colour = as.factor(label))) +
  geom_point(size=3) +
  ggtitle("Wines")
plt2 <- ggplot(wines, aes(x = Alcohol, y = Proline, colour = as.factor(label))) +
  geom_point(size=3) +
  ggtitle("Wines")

plt1

plt2


# The wine dataset the variable label contains three different labels: 1,2 and 3.

#   The usual practice, as far as I know, is to encode categorical variables as a “one hot” vector. For instance, if I had three classes, like in this case, I’d need to replace the label variable with three variables like these:
  
  #   l1,l2,l3
  #   1,0,0
  #   0,0,1
  #   ...



# Encode as a one hot vector multilabel data
wines_ <- cbind(wines[, 2:14], class.ind(as.factor(wines$label)))
# Set labels name
names(wines_) <- c(names(wines)[2:14],"l1","l2","l3")

#Scale

maxs <- apply(wines_[,1:13], 2, max) 
mins <- apply(wines_[,1:13], 2, min)
scaled <- as.data.frame(scale(wines_[,1:13], center = mins, scale = maxs - mins))

scaled <- cbind(scaled[, 1:13], wines_$l1, wines_$l2, wines_$l3)
names(scaled) <- c(names(scaled)[1:13],"l1","l2","l3")


#Split training and test data

index <- sample(1:nrow(wines),round(0.5*nrow(wines)))


train_ <- scaled[index,]
test_ <- scaled[-index,]


#Fit the model

nn <- neuralnet(l1 + l2 + l3 ~ Alcohol + Malic_acid + Ash + Alcalinity_of_ash + Magnesium + Total_phenols + Flavanoids + Nonflavanoid_phenols +  Proanthocyanins + Color_intensity + Hue + OD280_OD315_of_diluted_wines + Proline ,
                data = train_,
                hidden = c(13, 10, 3),
                act.fct = "logistic",
                linear.output = FALSE,
                lifesign = "minimal")


plot(nn)
#Let’s have a look at the accuracy on the training set:
  
# Compute predictions
  pr.nn <- compute(nn, test_[, 1:13])

# Extract results
pr.nn_ <- pr.nn$net.result
head(pr.nn_)

# Accuracy (training set)
original_values <- max.col(test_[, 14:16])
pr.nn_2 <- max.col(pr.nn_)
mean(pr.nn_2 == original_values)


mx <- as.matrix(round(pr.nn$net.result)==1)
wine.class.model<- as.vector(apply(mx,1,function(x) which(x==TRUE)))

table(wine.class.model, wines$label[-index])

# Exercise from: https://www.r-bloggers.com/multilabel-classification-with-neuralnet-package/
