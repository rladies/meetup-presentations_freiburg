# Part 1

install.packages("datasets")
library(datasets)
head(iris)
set.seed(20)

i1 <- kmeans(iris[, 3:4], 3, nstart = 20)
i1
table(i1$cluster, iris$Species)

install.packages("cluster.datasets")
library("cluster.datasets")
data(nutrients.meat.fish.fowl.1959)
nm<- na.omit(nutrients.meat.fish.fowl.1959)

install.packages("factoextra")
library(factoextra)
fviz_nbclust(nm[,2:6], kmeans, method = "wss")+labs(subtitle = "Elbow Method")
fviz_nbclust(nm[,2:6], kmeans, method = "silhouette")+
  labs(subtitle = "Silhouette method")

install.packages("NbClust")
install.packages(dplyr)
library("NbClust")
library(dplyr)
nut1 <- nm[,2:6]%>%
  
  NbClust(distance = "euclidean",
          min.nc = 2, max.nc = 10, 
          method = "complete", index ="all")
# Visualize
library(factoextra)
fviz_nbclust(nut1)

c10 <- kmeans(nm[,2:6], 10, nstart = 50)
c10

fviz_cluster(c10, data = nm[,2:6])

# silhouette width 
install.packages("cluster")
library(cluster)
silnut <- silhouette(c10$cluster, dist(nm[,2:6]))
rownames(silnut) <- nm[,1]
head(silnut[, 1:3], 10)
fviz_silhouette(silnut)

negindex <- which(silnut[, "sil_width"] < 0)
silnut[negindex, , drop = FALSE]

#Dunn index
#k-means using eclust()
library(factoextra)
nkm1 <- eclust(nm[,2:6], "kmeans", nstart = 25)
# Gap statistic plot
fviz_gap_stat(nkm1$gap_stat)
# Silhouette plot
fviz_silhouette(nkm1)

install.packages("(fpc")
library(fpc)
n2 <- cluster.stats(dist(nm[,2:6]), nkm1$cluster)
# Dunn index
n2$dunn


library(factoextra)
fviz_cluster(c10, data = nm[,2:6])


install.packages("tibble")
library(tibble)
nm[,2:6] %>%
  as_tibble() %>%
  mutate(Cluster = c10$cluster) %>%
  group_by(Cluster) %>%
  summarise_all("mean")


# Part 2


library(tidyverse)  # data manipulation
library(cluster)    # clustering algorithms
library(factoextra) # clustering visualization
library(cluster.datasets)
set.seed(20)
data(nutrients.meat.fish.fowl.1959)


m2 <- na.omit(nutrients.meat.fish.fowl.1959)
head(m2)

distancematrix <- dist(m2[,2:6], method = "euclidean")

# Hierarchical clustering 
hierclus <- hclust(distancematrix , method = "complete" )
plot(hierclus, cex = 0.6, hang = -1)

#  the agnes function with method = "complete"
hierclusagnes <- agnes(m2[,2:6], method = "complete")
# Agglomerative coefficient
hierclusagnes$ac

methodstoassess <- c( "average", "single", "complete", "ward")
names(methodstoassess) <- c( "average", "single", "complete", "ward")

f <- function(x) {
  agnes(m2, method = x)$ac
}
library(purrr)
map_dbl(methodstoassess, f)

hcward <- agnes(m2, method = "ward")
pltree(hcward , cex = 0.6, hang = -1, main = "Dendrogram of agnes method") 


# Divisive Hierarchical Clustering

hierclusdivisive <- diana(m2[,2:6])

# Divise coefficient

hierclusdivisive$dc

#  visualize the dendrogram
pltree(hierclusdivisive, cex = 0.6, hang = -1, main = "Dendrogram of divisive hierarchical clustering using the diana function")

h6 <- hclust(distancematrix, method = "ward.D2" )

tree1 <- cutree(h6, k = 4)

table(tree1)

# Add the  cluster of each observation  to the data
install.packages("dplyr")
library(dplyr)

m2[,2:6] %>%
  mutate(cluster = tree1) %>%
  head
m2%>%
  mutate(cluster = tree1) %>%
  head

fviz_dend(  h6, k = 4,rect = TRUE,cex = 0.5)

m3=m2[,2:6]
fviz_cluster(list(data = m3, cluster = tree1))

m4=m2%>%
  mutate(cluster = tree1)
count(m4, cluster)

# Cut agnes() tree into 4 groups
hagnes <- agnes(m2, method = "ward")
cutree(as.hclust(hagnes), k = 4)

# Cut diana() tree into 4 groups
hdiana<- diana(m2)
cutree(as.hclust(hdiana), k = 4)

fviz_nbclust(m2[,2:6], FUN = hcut, method = "wss")
fviz_nbclust(m2[,2:6], FUN = hcut, method = "silhouette")

tree7 <- cutree(h6, k = 7)
table(tree7)

m3 %>%
  mutate(cluster = tree7) %>%
  head
m2 %>%
  mutate(cluster = tree7) %>%
  head

fviz_cluster(list(data = m3, cluster = tree7))

#Silhouette width
install.packages("fpc")
library(fpc)
distancematrix <- dist(m2[,2:6], method = "euclidean")
enhier <- eclust(m2, "hclust", k = 7,
                 method = "complete", graph = FALSE) 
head(enhier$cluster, 15)
hier1 <- cluster.stats(distancematrix,  enhier$cluster)
# within clusters sum of squares
hier1$within.cluster.ss
# cluster average silhouette widths
hier1$clus.avg.silwidths

#Dunn index
install.packages("clValid")
library("clValid")
distancematrix <- dist(m2[,2:6], method = "euclidean")
clusterObj <- hclust(distancematrix, method="average")
nc <- 7      
cluster <- cutree(clusterObj,nc)
dunn(distancematrix, cluster)


