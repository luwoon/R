library(data.table)
library(ggplot2)
library(ggmosaic)
library(readxl)
library(dplyr)
library(readr)

#import data
transaction_data <- read_excel("C:/Users/pangl/Downloads/QVI_transaction_data.xlsx")
customer_data <- read.csv("C:/Users/pangl/Downloads/QVI_purchase_behaviour.csv")

#explore transaction_data
str(transaction_data)
head(transaction_data)

#convert transaction_date$DATE from num to date
transaction_data$DATE <- as.Date(transaction_data$DATE, origin = "1899-12-30")

#view summary of transaction_date$PROD_NAME
table(transaction_data$PROD_NAME)

#text analysis of transaction_date$PROD_NAME by extracting unique individual words
productWords <- data.table(unlist(strsplit(unique(as.character(transaction_data[, "PROD_NAME"])), " ")))
setnames(productWords, 'words')
#remove words with digits and special characters
productWords[, nalnum := grepl("[^[:alnum:]]", words)]
productWords <- productWords[nalnum == FALSE, ][, nalnum := NULL]
#sort distinct words by frequency of occurrence
word_freq <- table(productWords$words)
word_freq_dt <- data.table(word = names(word_freq), freq = as.numeric(word_freq))
setorder(word_freq_dt, -freq)
print(word_freq_dt)
#the three most frequent words are "Chips", "Cheese", and "Salt"

#remove salsa products from transaction_data
transaction_data = data.table(transaction_data)
transaction_data[, SALSA := grepl("salsa", tolower(PROD_NAME))]
transaction_data <- transaction_data[SALSA == FALSE, ][, SALSA := NULL]

#summary statistics
summary(transaction_data)

#examine outlier - customer who purchased 200 quantities
print(filter(transaction_data, PROD_QTY == 200))
print(filter(transaction_data, LYLTY_CARD_NBR == 226000))
#remove customer as they might have bought for commercial purposes
transaction_data <- filter(transaction_data, PROD_QTY != 200)
summary(transaction_data)

#summary of transaction count by date
transaction_summary <- transaction_data %>%
  group_by(DATE) %>%
    summarize(transaction_count = n())
print(transaction_summary)
#as there are only 364 rows, join to fill in missing date
dates <- data.frame(DATE = seq(as.Date("2018-07-01"), as.Date("2019-06-30"), by = "day"))
transaction_summary_full <- merge(dates, transaction_summary,  all.x = TRUE)

#set plot themes to format graphs
theme_set(theme_bw())
theme_update(plot.title = element_text(hjust = 0.5))

#plot transactions over time
p <- ggplot(transaction_summary_full, aes(x = DATE, y = transaction_count)) + 
  geom_line() + 
  labs(x = "Day", y = "Number of Transactions", title = "Transactions Over Time") +
  scale_x_date(breaks = "1 month") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))
p
#there was an increase in purchases in December and a break in late December
#December analysis
p + xlim(as.Date("2018-12-01"), as.Date("2018-12-31"))
#increase in sales occurred in the lead-up to Christmas, zero sales on Christmas day due to shops being closed

#create pack size feature
transaction_data[, PACK_SIZE := parse_number(PROD_NAME)]
transaction_data[, .N, PACK_SIZE][order(PACK_SIZE)]

#plot histogram showing number of transactions by pack size
p1 <- ggplot(transaction_data, aes(x = PACK_SIZE)) +
  geom_histogram() +
  labs(x = "Pack Size", y = "Frequency", title = "Number of Transactions by Pack Size")
p1

#create brand feature
transaction_data$BRAND <- sapply(strsplit(as.character(transaction_data$PROD_NAME), " "), "[", 1)
table(transaction_data$BRAND)
transaction_data[BRAND == "Red", BRAND := "RRD"]
transaction_data[BRAND == "Dorito", BRAND := "Doritos"]
transaction_data[BRAND == "Infzns", BRAND := "Infuzions"]
transaction_data[BRAND == "Smith", BRAND := "Smiths"]
transaction_data[BRAND == "Snbts", BRAND := "Sunbites"]
transaction_data[BRAND == "WW", BRAND := "Woolworths"]
table(transaction_data$BRAND)

#examine customer_data
str(customer_data)
head(customer_data)
summary(customer_data)
table(customer_data$LIFESTAGE)
table(customer_data$PREMIUM_CUSTOMER)

#merge transaction_data and customer_data
data <- merge(transaction_data, customer_data, all.x = TRUE)
colSums(is.na(data))
#no NAs

#data analysis on customer segments
total_sales_by_lifestage <- data %>%
  group_by(LIFESTAGE) %>%
  summarize(total_sales = sum(TOT_SALES)) %>%
  arrange(desc(total_sales))
print(total_sales_by_lifestage) #
total_sales_by_premium_customer <- data %>%
  group_by(PREMIUM_CUSTOMER) %>%
  summarize(total_sales = sum(TOT_SALES)) %>%
  arrange(desc(total_sales))
print(total_sales_by_premium_customer)
total_sales_by_lifestage_and_premium_customer <- data %>%
  group_by(LIFESTAGE, PREMIUM_CUSTOMER) %>%
  summarize(total_sales = sum(TOT_SALES)) %>%
  arrange(desc(total_sales))
print(total_sales_by_lifestage_and_premium_customer)
total_sales_by_lifestage_and_premium_customer$GROUP <- paste(total_sales_by_lifestage_and_premium_customer$PREMIUM_CUSTOMER, total_sales_by_lifestage_and_premium_customer$LIFESTAGE, sep = " ")
p2 <- ggplot(data = total_sales_by_lifestage_and_premium_customer, aes(x = reorder(GROUP, -total_sales), y = total_sales)) +
  geom_bar(stat="identity")
p2
#sales come mainly from budget - older families, mainstream - young singles/couples, and mainstream - retirees

#average number of units per customers by LIFESTAGE and PREMIUM_CUSTOMER
average_qty_by_lifestage <- data %>%
  group_by(LIFESTAGE) %>%
  summarize(average_qty = mean(PROD_QTY)) %>%
  arrange(desc(average_qty))
print(average_qty_by_lifestage)
average_qty_by_premium_customer <- data %>%
  group_by(PREMIUM_CUSTOMER) %>%
  summarize(average_qty = mean(PROD_QTY)) %>%
  arrange(desc(average_qty))
print(average_qty_by_premium_customer)
average_qty_by_lifestage_and_premium_customer <- data %>%
  group_by(LIFESTAGE, PREMIUM_CUSTOMER) %>%
  summarize(average_qty = mean(PROD_QTY)) %>%
  arrange(desc(average_qty))
print(average_qty_by_lifestage_and_premium_customer)
average_qty_by_lifestage_and_premium_customer$GROUP <- paste(average_qty_by_lifestage_and_premium_customer$PREMIUM_CUSTOMER, average_qty_by_lifestage_and_premium_customer$LIFESTAGE, sep = " ")
p3 <- ggplot(data = average_qty_by_lifestage_and_premium_customer, aes(x = reorder(GROUP, -average_qty), y = average_qty)) +
  geom_bar(stat="identity")
p3
#older families and young families in general buy more chips per customer

#average price per unit by LIFESTAGE and PREMIUM_CUSTOMER
average_price_by_lifestage <- data %>%
  group_by(LIFESTAGE) %>%
  summarize(average_price = mean((TOT_SALES/PROD_QTY)/PACK_SIZE) %>%
  arrange(desc(average_price))
print(average_price_by_lifestage)
average_price_by_premium_customer <- data %>%
  group_by(PREMIUM_CUSTOMER) %>%
  summarize(average_price = mean((TOT_SALES/PROD_QTY)/PACK_SIZE) %>%
  arrange(desc(average_price))
print(average_price_by_premium_customer)
average_price_by_lifestage_and_premium_customer <- data %>%
  group_by(LIFESTAGE, PREMIUM_CUSTOMER) %>%
  summarize(average_price = mean((TOT_SALES/PROD_QTY)/PACK_SIZE) %>%
  arrange(desc(average_price))
print(average_price_by_lifestage_and_premium_customer)
average_price_by_lifestage_and_premium_customer$GROUP <- paste(average_price_by_lifestage_and_premium_customer$PREMIUM_CUSTOMER, average_price_by_lifestage_and_premium_customer$LIFESTAGE, sep = " ")
p4 <- ggplot(data = average_price_by_lifestage_and_premium_customer, aes(x = reorder(GROUP, -average_price), y = average_price)) +
  geom_bar(stat="identity")
p4
#mainstream mid-age and young singles/couples are more willing to pay more per packet of chips compared to their budget and premium counterparts
#may be due to premium shoppers being more likely to buy healthy snacks and when they buy chips, it is mainly for entertainment purposes rather than their own consumption

#independent t-test between mainstream vs premium and budget midage and young singles/couples on average price per unit
s1 <- average_price_by_lifestage_and_premium_customer[average_price_by_lifestage_and_premium_customer$GROUP == 'Mainstream YOUNG SINGLES/COUPLES' | average_price_by_lifestage_and_premium_customer$GROUP == 'Mainstream MIDAGE SINGLES/COUPLES',]
s2 <- average_price_by_lifestage_and_premium_customer[average_price_by_lifestage_and_premium_customer$GROUP == 'Premium YOUNG SINGLES/COUPLES' | average_price_by_lifestage_and_premium_customer$GROUP == 'Premium MIDAGE SINGLES/COUPLES' | average_price_by_lifestage_and_premium_customer$GROUP == 'Budget YOUNG SINGLES/COUPLES' | average_price_by_lifestage_and_premium_customer$GROUP == 'Budget MIDAGE SINGLES/COUPLES',]
t.test(s1$average_price, s2$average_price)
#the t-test results in a p-value of 0.01271 < 0.05, i.e. the unit price for mainstream young and mid-age singles and couples are significantly higher than that of budget or premium young and mid-age singles and couples

#overall brand preference
brand_pref <- data %>%
  group_by(BRAND) %>%
  summarize(pref = sum(PROD_QTY)) %>%
  arrange(desc(pref))
brand_pref
p5 <- ggplot(data = brand_pref, aes(x = BRAND, y = pref)) +
  geom_bar(stat="identity")
p5
#top 3 brands are Kettle, Smiths, and Doritos

#brand preference of mainstream customers
brand_pref_mainstream <- data %>%
  group_by(BRAND) %>%
  filter(PREMIUM_CUSTOMER == "Mainstream") %>%
  summarize(pref = sum(PROD_QTY)) %>%
  arrange(desc(pref))
brand_pref_mainstream
p6 <- ggplot(data = brand_pref_mainstream, aes(x = BRAND, y = pref)) +
  geom_bar(stat="identity")
p6
#top 3 brands are Kettle, Smiths, and Doritos

#brand preference of young singles/couples
brand_pref_young <- data %>%
  group_by(BRAND) %>%
  filter(LIFESTAGE == "YOUNG SINGLES/COUPLES") %>%
  summarize(pref = sum(PROD_QTY)) %>%
  arrange(desc(pref))
brand_pref_young
p7 <- ggplot(data = brand_pref_young, aes(x = BRAND, y = pref)) +
  geom_bar(stat="identity")
p7
#top 3 brands are Kettle, Smiths, and Pringles
