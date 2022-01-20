
### Programming Basics

# Data Structures
Number<-3
Text<-"Trial"
X<-c(1:10)
A<-matrix(c(2,4,1,5,7,3),nrow=2,ncol=3,byrow=TRUE)
B<-data.frame(Name= c("Part1","Part2","Part3"), DV = 1:3)
List <- list(Text="Practice", Numeric=6.9, Column = 1:5 )

str(A)
typeof(A)
typeof(List)

# Operators

Number+5

X*2

X[(X<8) & (X>5)]
X[(X>8) | (X<3)] 

M<-mean(X)

# Function

ConvertEuroToDollar <- function(Euro) {
  Dollar <- (Euro*1.13)
  Dollar
}
ConvertEuroToDollar(5)


# If---else

if(Number==3) {
  print("Yes")
} else {
  print("No")
}


# For loop

for (i in X){
  print(paste("File of Participant", i))
  
}

