#SECTION 2 HOMEWORK
#Test the Law Of Large Numbers for N random normally distributed numbers with mean = 0, stdev = 1:
#Create an R script that will count how many of these numbers fall between -1 and 1 and divide by the total quantity of N. You know that E(X) = 68.2%.
N <- 100
counter <- 0
for(i in rnorm(N)){
  if(i>-1 & i<1 ){
    counter <- counter+1
  }
}
answer <- counter/N
answer

#SECTION 3 HOMEWORK
#data
revenue <- c(14574.49, 7606.46, 8611.41, 9175.41, 8058.65, 8105.44, 11496.28, 9766.09, 10305.32, 14379.96, 10713.97, 15433.50)
expenses <- c(12051.82, 5695.07, 12319.20, 12089.72, 8658.57, 840.20, 3285.73, 5821.12, 6976.93, 16618.61, 10054.37, 3803.96)
#profit for each month
profit <- (revenue-expenses)*1000
#profit after tax for each month (the tax rate is 30%)
profitaftertax <- (.7*revenue-expenses)*1000
#profit margin for each month - equals to profit a after tax divided by revenue
profitmargin <- round((.7*revenue-expenses)/revenue*100)
#good months - where the profit after tax was greater than the mean for the year
for(i in profitaftertax){
  print(i>mean(profitaftertax))
}
#bad months - where the profit after tax was less than the mean for the year
for(i in profitaftertax){
  print(i<mean(profitaftertax))
}
#the best month - where the profit after tax was max for the year
for(i in profitaftertax){
  print(i==max(profitaftertax))
}
#the worst month - where the profit after tax was min for the year
for(i in profitaftertax){
  print(i==min(profitaftertax))
}
