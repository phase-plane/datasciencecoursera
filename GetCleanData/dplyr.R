# dplyr (for data frames)

install.packages("dplyr")
library(dplyr)
packageVersion("dplyr")

# swirl() lesson 1 (using dplyr)
# some basics
mydf <- read.csv(path2csv, stringsAsFactors = FALSE)
dim(mydf)
cran <- tbl_df(mydf)
rm("mydf")
cran # print is very readable
select(cran, ip_id, package, country) vs  # cran$country, cran$package, etc.
# beefed up ':'
select(cran, r_arch:country)
select(cran, -time) # omit / negate
select(cran, -(X:size))
# subset rows
filter(cran, package == "swirl") # vs cran$package
filter(cran, r_version == "3.1.1", country == "US")
filter(cran, country == "US" | country == "IN")
filter(cran, size > 100500, r_os == "linux-gnu")
# recall 
!is.na(c(3, 5, NA, 10))
filter(cran, !is.na(r_version))
# ordering => arrange()
cran2 <- select(cran, size:ip_id)
arrange(cran2, ip_id)
arrange(cran2, desc(ip_id))
# multiple arguments
arrange(cran2, package, ip_id)
arrange(cran2, country, desc(r_version), ip_id)
# mutate (create new variables)
cran3 <- select(cran, ip_id, package, size)
mutate(cran3, size_mb = size / 2^20)
mutate(cran3, size_mb = size / 2^20, size_gb = size_mb / 2^10)
mutate(cran3, correct_size = size + 1000)
# summary
summarize(cran, avg_bytes = mean(size))

# lecture notes
# dplyr verbs
select(); filter(); arrange(); rename(); mutate(); summarise()

# select (?select)
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

# filter (subset rows) (see ?Comparison)
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

# swirl() lesson 2: Grouping and Chaining
cran <- tbl_df(mydf)
rm("mydf")
?group_by / ungroup()
by_package <- group_by(cran, package)
# now any operation applied to the grouped data will take place on a
# per package basis
summarise(by_package, mean(size))
# more dynamic (creating columns by group)
pack_sum <- summarize(by_package,
                      count = n(),
                      unique = n_distinct(ip_id),
                      countries = n_distinct(country) ,
                      avg_bytes = mean(size))
# most popular, 0.99 percentile
quantile(pack_sum$count, probs = 0.99)
top_counts <- filter(pack_sum, count > 679)
View(top_counts) # View() to see full tbl's
top_counts_sorted <- arrange(top_counts, desc(count))
View(top_counts_sorted)

# 0.99 percentile for unique
quantile(pack_sum$unique, probs = 0.99)
top_unique <- filter(pack_sum, unique > 465)
View(top_unique)
top_unique_sorted <- arrange(top_unique, desc(unique))
View(top_unique_sorted)

# chaining (avoid intermediate results)
result3 <-
  cran %>%
  group_by(package) %>%
  summarize(count = n(),
            unique = n_distinct(ip_id),
            countries = n_distinct(country),
            avg_bytes = mean(size)
  ) %>%
  filter(countries > 60) %>%
  arrange(desc(countries), avg_bytes)

# Print result to console
print(result3)

cran %>%
  select(ip_id, country, package, size) %>%
  print

cran %>%
  select(ip_id, country, package, size) %>%
  mutate(size_mb = size / 2^20) %>%
  print

cran %>%
  select(ip_id, country, package, size) %>%
  mutate(size_mb = size / 2^20) %>%
  filter(size_mb <= 0.5) %>%
  arrange(desc(size_mb)) %>%
  print

# lecture notes
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