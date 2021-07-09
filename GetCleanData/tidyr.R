# tidyr intro. tutorial (feat. readr)

# > students
# grade male female
#1     A    5      3
#2     B    4      1
#3     C    8      6
#4     D    4      5
#5     E    5      5

# issue 1: column headers that are values, not variable names
# variables are: grade, sex, count

?gather

str(gather)
# function (data, key = "key", value = "value", ..., na.rm = FALSE, ...
  # convert = FALSE, factor_key = FALSE) 

# (data, key, value, gather all columns except grade)
gather(students, sex, count, -grade)

# issue 2: multiple variables in one column

# > students2
# grade male_1 female_1 male_2 female_2
# 1     A      7        0      5        8
# 2     B      4        0      5        8
# 3     C      7        4      5        6
# 4     D      8        2      8        1
# 5     E      8        4      1        0

# variables are grade, sex, count, class(1,2)
# multiple variables in one column are sex, class

# tidying here is two-step process
res <- gather(students2, key = sex_class, value = count, -grade)

# separate()
?separate
separate(data = res, col = sex_class, into = c("sex", "class"))
separate(res, sex_class, into = c("sex", "class"))
# default separator is on non-alphanumeric values

# chaining for same result
students2 %>%
  gather(sex_class, count, -grade) %>%
  separate(sex_class, c("sex", "class")) %>%
  print

# issue 3: variables stored in rows and columns
# > students3
#     name   test    class1  class2 class3 class4 class5
#  1  Sally midterm      A   <NA>      B   <NA>   <NA>
#  2  Sally   final      C   <NA>      C   <NA>   <NA>
#  3  Jeff midterm    <NA>      D   <NA>      A   <NA>
#  4  Jeff   final    <NA>      E   <NA>      C   <NA>
#  5  Roger midterm   <NA>      C   <NA>   <NA>      B
#  6  Roger   final   <NA>      A   <NA>   <NA>      A
#  7  Karen midterm   <NA>   <NA>      C      A   <NA>
#  8  Karen   final   <NA>   <NA>      C      A   <NA>
#  9  Brian midterm      B   <NA>   <NA>   <NA>      A
#  10 Brian   final      B   <NA>   <NA>   <NA>      C

# first variables, name, already in column
# class columns should be single variable 'class'
# the values in test column should also be its own variable

# step 1
students3 %>%
  gather(class, grade, class1:class5 , na.rm = TRUE) %>%
  print

# step 2 
?spread # inverse of gather
students3 %>%
  gather(class, grade, class1:class5, na.rm = TRUE) %>%
  spread(test, grade) %>%
  print

library(readr)
parse_number("class5")

# finally
students3 %>%
  gather(class, grade, class1:class5, na.rm = TRUE) %>%
  spread(test, grade) %>%
  mutate(class = parse_number(class)) %>%
  print

# issue 4: multiple observational units are stored in the same table
# > students4
#    id  name  sex  class midterm final
# 1  168 Brian   F     1       B     B
# 2  168 Brian   F     5       A     C
# 3  588 Sally   M     1       A     C
# 4  588 Sally   M     3       B     C
# 5  710  Jeff   M     2       D     E
# 6  710  Jeff   M     4       A     C
# 7  731 Roger   F     2       C     A
# 8  731 Roger   F     5       B     A
# 9  908 Karen   M     3       C     C
# 10 908 Karen   M     4       A     A

# the problem: unique id for each student, as well as 
# his or her sex (M = male; F = female)
# each id, name, and sex is repeated twice (redundant)

# solution:
# create two separate tables -- one containing basic 
# student information (id, name, and sex); 
# other containing grades (id, class, midterm, final)

# id -> primary key

# info
student_info <- students4 %>%
  select(id, name, sex) %>%
  print

# remove duplicates
student_info <- students4 %>%
  select(id, name, sex) %>%
  unique %>%
  print

# second table
gradebook <- students4 %>%
  select(id, class, midterm, final) %>%
  print

# issue 5: inverse of 4 (single observational unit, multiple tables)
passed <- mutate(passed, status = "passed")
failed <- mutate(failed, status = "failed")
bind_rows(passed, failed)

sat %>%
  select(-contains("total")) %>%
  gather(part_sex, count, -score_range) %>%
  separate(part_sex, into = c("part", "sex")) %>%
  print

sat %>%
  select(-contains("total")) %>%
  gather(part_sex, count, -score_range) %>%
  separate(part_sex, c("part", "sex")) %>%
  group_by(part, sex) %>%
  mutate(total = sum(count),
         prop = count / total
  ) %>% print