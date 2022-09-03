#remove previous variables
rm(list = ls())

library(dtw);
library(ggplot2); 
library(reshape);
library(stats);
library(MASS);
library(readxl)

#set path
setwd("C:/Users/XXX/XXX")

#read time-series data of each subject in the dyad
s1 <- read_excel("s1.xlsx")
#change bad channels to 0
s1[is.na(s1)] <- 0
s2 <- read_excel("s2.xlsx")
s2[is.na(s2)] <- 0

#demarcation of timeframe for each condition; 20 columns for 20 NIRS channels
s1cond1<-data.frame(s1[48:711,2:21])
s1cond2<-data.frame(s1[1009:2227,2:21])
s1cond3<-data.frame(s1[2501:3422,2:21])
s1cond4<-data.frame(s1[3704:5156,2:21])
s2cond1<-data.frame(s2[48:711,2:21])
s2cond2<-data.frame(s2[1009:2227,2:21])
s2cond3<-data.frame(s2[2501:3422,2:21])
s2cond4<-data.frame(s2[3704:5156,2:21])

#create 20xN matrix where N=number of rows of data
cond1s1 = matrix(ncol=20, nrow=1219)
cond1s2 = matrix(ncol=20, nrow=1219)
cond2s1 = matrix(ncol=20, nrow=664)
cond2s2 = matrix(ncol=20, nrow=664)
cond3s1 = matrix(ncol=20, nrow=1453)
cond3s2 = matrix(ncol=20, nrow=1453)
cond4s1 = matrix(ncol=20, nrow=922)
cond4s2 = matrix(ncol=20, nrow=922)

#create matrix for normalised distance where the number of dyads is the row
cond1.align.ndist = matrix(ncol=20, nrow=1)
cond2.align.ndist = matrix(ncol=20, nrow=1)
cond3.align.ndist = matrix(ncol=20, nrow=1)
cond4.align.ndist = matrix(ncol=20, nrow=1)

#DTW
#initialize column of original time-series table
i<-1
#initialize column of original new empty matrices
j<-1
for (i in 1:20){
  cond1s1[,j] <-(s1cond1[,i]);
  cond2s1[,j] <-(s1cond2[,i]);
  cond3s1[,j] <-(s1cond3[,i]);
  cond4s1[,j] <-(s1cond4[,i]);
  cond1s2[,j] <-(s2cond1[,i]);
  cond2s2[,j] <-(s2cond2[,i]);
  cond3s2[,j] <-(s2cond3[,i]);
  cond4s2[,j] <-(s2cond4[,i]);
  
  #Find the best match with the canonical recursion formula and display the warping curve
  alignment <- dtw(cond1s1[,j],cond1s2[,j],keep=TRUE)
  cond1.align.ndist [1,j] <- alignment$normalizedDistance
  alignment <- dtw(cond2s1[,j],cond2s2[,j],keep=TRUE)
  cond2.align.ndist [1,j] <- alignment$normalizedDistance
  alignment <- dtw(cond3s1[,j], cond3s2[,j],keep=TRUE)
  cond3.align.ndist [1,j] <- alignment$normalizedDistance
  alignment <- dtw(cond4s1[,j],cond4s2[,j],keep=TRUE)
  cond4.align.ndist [1,j] <- alignment$normalizedDistance
  j<-j+1
}

#write output files
write.table(cond1.align.ndist, file = "cond1XXX.csv",row.names=TRUE, col.names=TRUE, sep=",")
write.table(cond2.align.ndist, file = "cond2XXX.csv",row.names=TRUE, col.names=TRUE, sep=",")
write.table(cond3.align.ndist, file = "cond3XXX.csv",row.names=TRUE, col.names=TRUE, sep=",")
write.table(cond4.align.ndist, file = "cond4XXX.csv",row.names=TRUE, col.names=TRUE, sep=",")
