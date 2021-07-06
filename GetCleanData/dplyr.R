# Week 3
# dplyr (for data frames)
install.packages("dplyr")
library(dplyr)

# dplyr verbs
select(); filter(); arrange(); rename(); mutate(); summarise()

# select
chicago <- readRDS("chicago.rds")
dim(chicago)
head(select(chicago, 1:5))
names(chicago)[1:3]
head(select(chicago, city:dptp)) # instead of $

head(select(chicago, -(city:dptp))) # exclude
# <=> 
i <- match("city", names(chicago))
j <- match("dptp", names(chicago))
head(chicago[, -(i:j)])

# filter
chic.f <- filter(chicago, pm25tmean2 > 30) # conditional subsetting
head(select(chic.f, 1:3, pm25tmean2), 10)

chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)
head(select(chic.f, 1:3, pm25tmean2, tmpd), 10)

# arrange
chicago <- arrange(chicago, date)
head(select(chicago, date, pm25tmean2), 3)
tail(select(chicago, date, pm25tmean2), 3)

# arrange: descending order
chicago <- arrange(chicago, desc(date))
head(select(chicago, date, pm25tmean2), 3)
tail(select(chicago, date, pm25tmean2), 3)

# rename
head(chicago[, 1:5], 3)
chicago <- rename(chicago, dewpoint = dptp, 
                  pm25 = pm25tmean2)
head(chicago[, 1:5], 3)

# mutate (adding new variables)
chicago <- mutate(chicago, 
                  pm25detrend=pm25-mean(pm25, na.rm=TRUE))

# group_by (split by categories)
# e.g. 1
# create factor variable
chicago <- mutate(chicago, 
                  tempcat = factor(1 * (tmpd > 80), 
                                   labels = c("cold", "hot")))

hotcold <- group_by(chicago, tempcat)

summarize(hotcold, pm25 = mean(pm25, na.rm = TRUE), 
          o3 = max(o3tmean2), 
          no2 = median(no2tmean2))

# e.g. 2
# summary stats for each year
chicago <- mutate(chicago, 
                  year = as.POSIXlt(date)$year + 1900)

years <- group_by(chicago, year)

summarize(years, pm25 = mean(pm25, na.rm = TRUE), 
          o3 = max(o3tmean2, na.rm = TRUE), 
          no2 = median(no2tmean2, na.rm = TRUE))

# %>% (can ignore data frame as argument each time)
chicago %>% mutate(month = as.POSIXlt(date)$mon + 1) %>% group_by(month) %>% 
  summarize(pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2, na.rm = TRUE), 
          no2 = median(no2tmean2, na.rm = TRUE))