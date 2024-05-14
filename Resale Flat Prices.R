# dataset from https://data.gov.sg/dataset/resale-flat-prices

# data exploration and cleaning

# load dfs
df2017onwards <- read.csv("C:\\Users\\pangl\\Downloads\\resale-flat-prices-based-on-registration-date-from-jan-2017-onwards.csv")
df2012to2014 <- read.csv("C:\\Users\\pangl\\Downloads\\resale-flat-prices-based-on-registration-date-from-mar-2012-to-dec-2014.csv")
df2000to2012 <- read.csv("C:\\Users\\pangl\\Downloads\\resale-flat-prices-based-on-approval-date-2000-feb-2012.csv")
df2015to2016 <- read.csv("C:\\Users\\pangl\\Downloads\\resale-flat-prices-based-on-registration-date-from-jan-2015-to-dec-2016.csv")
df1990to1999 <- read.csv("C:\\Users\\pangl\\Downloads\\resale-flat-prices-based-on-approval-date-1990-1999.csv")

str(df2017onwards)
str(df2012to2014)
str(df2000to2012)
str(df2015to2016)
str(df1990to1999)

# as df2017onwards$remaining_lease is of chr type but df2015to2016$remaining_lease is of int type, convert df2017onwards$remaining_lease to int type by extracting the number of years, rounded down, in numeric format
df2017onwards$remaining_lease <- as.numeric(substr(df2017onwards$remaining_lease, 1, 2))

# combine dfs
df <- bind_rows(df1990to1999,df2000to2012,df2012to2014,df2015to2016,df2017onwards)

# drop columns
df = select(df, -1, -5, -6)

# as 'month' column is of chr type and only contains the year and month, convert column to date format, filling in day as 01
df <- df %>% 
rename("date" = "month")
df$date <- as.Date(paste(df$date,"-01",sep=""))

write.csv(df,"C:\\Users\\pangl\\Downloads\\Resale-Prices-1990-to-2022.csv", row.names = TRUE)

# Tableau Dashboard
# https://public.tableau.com/app/profile/lu.woon/viz/SingaporesMedianResaleFlatPrices1990-2022_16974384543580/Dashboard
