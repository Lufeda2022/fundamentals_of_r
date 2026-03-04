#NB: Comments are hashed out (#)
#    Even some commands are hashed out
# ==============================================================================
# ATOMIC VECTORS
# ==============================================================================
# There are exactly SIX atomic types (often called "atomic classes or modes").

# The four you use 99% of the time:
# 1. logical    → TRUE / FALSE / NA
# 2. integer    → whole numbers (with L suffix)
# 3. double     → real numbers (floating point), called "numeric" in many contexts
# 4. character  → text/strings

# The two rarely used in everyday analysis:
# 5. complex    → complex numbers (with imaginary part)
# 6. raw        → raw bytes (binary data)

# 1. Creating examples of each atomic type

# Logical
log_vec <- c(TRUE, FALSE, TRUE, NA)
typeof(log_vec)     # "logical"
mode(log_vec)       # "logical"
class(log_vec)      # "logical"

# Integer
int_vec <- c(1L, -5L, 0L, 100L)
typeof(int_vec)     # "integer"
mode(int_vec)       # "numeric"
class(int_vec)      # "integer"

# Double (default for numbers without L)
dbl_vec <- c(3.14, -2.5, 0, 1.0)
typeof(dbl_vec)     # "double"
mode(dbl_vec)       # "numeric"
class(dbl_vec)      # "numeric"

# Character
chr_vec <- c("Kampala", "Entebbe", "Hello world", NA)
typeof(chr_vec)     # "character"
mode(chr_vec)       # "character"
class(chr_vec)      # "character"

# Complex (rare in stats/data analysis)
cmp_vec <- c(1 + 2i, -3 + 0i, 0 + 4i)
typeof(cmp_vec)     # "complex"
mode(cmp_vec)       # "complex"
class(cmp_vec)      # "complex"

# Raw (very rare — for binary/low-level data)
raw_vec <- charToRaw("ABC")   # converts string to raw bytes
typeof(raw_vec)     # "raw"
mode(raw_vec)       # "raw"
class(raw_vec)      # "raw"

# ==============================================================================
# Coercion Rules 
# ==============================================================================

# Atomic vectors are homogeneous → when you try to mix types, R coerces them
# Coercion hierarchy (lowest to highest precedence):
# logical → integer → double → complex → character → raw
#
# Direction: lower types are promoted to the higher one in the pair

# 1. Implicit coercion (automatic – happens without you asking)

# Logical → Integer / Double
c(TRUE, FALSE, TRUE) + 5         # → 6 5 6   (TRUE=1, FALSE=0)
c(TRUE, 1L, 3.14)                # → 1 1 3.14  (logical → double)

# Integer → Double
c(1L, 2L, 5.5)                   # → 1 2 5.5   (integer → double)
typeof(c(1L, 2L, 5.5))           # "double"

# Numeric → Complex
c(3.14, 2 + 1i)                  # → 3.14+0i  2+1i
typeof(c(3.14, 2 + 1i))          # "complex"

# Anything → Character (almost always wins last)
c(TRUE, 42L, 3.14, 2+1i, "hello") 
# → "TRUE"  "42"  "3.14"  "2+1i"  "hello"
typeof(c(TRUE, 42L, 3.14, "text"))   # "character"

# 2.  common coercion examples

# Logical in arithmetic → treated as 0/1
mean(c(TRUE, TRUE, FALSE, TRUE))     # → 0.75
sum(c(TRUE, FALSE, NA))              # → NA   (NA propagates)

# Character + number → everything becomes character
c(10, 20, "thirty") + 5             # Error! Cannot add to character

# But paste / c() is forgiving
c(10, 20, "thirty")                  # → "10" "20" "thirty"

# Mixing with NA
c(1, NA, "abc")                      # → "1" NA "abc"

# 3. Explicit coercion – you control it (recommended when possible)

# as.*() family – safest & clearest
as.integer(c(3.9, 2.1, -1.5))        # → 3  2 -1   (truncates toward zero)
as.double(c(1L, 5L))                 # → 1 5
as.character(c(42, TRUE, 3.14))      # → "42" "TRUE" "3.14"
as.logical(c(0, 1, 5, -3, NA))       # → FALSE TRUE TRUE TRUE NA
# (0→FALSE, non-zero→TRUE)

# as.numeric() is very common (accepts many formats)
as.numeric(c("1.5", "42", "3e2"))    # → 1.5  42  300
as.numeric(c("1.5", "hello", "42"))  # → 1.5 NA 42   + warning

# Special versions for stricter control
as.integer("3.9")                    # → 3   (truncates)
as.double("not a number")            # → NA + warning

# 4. Real-world examples where coercion bites

# Wrong: accidentally mixing types in data entry
scores <- c(85, 92, "absent", 78)
mean(scores)                         # Error – character present

# Fix: explicit coercion + NA handling
scores_clean <- as.numeric(scores)   # → 85 92 NA 78
mean(scores_clean, na.rm = TRUE)     # → 85

# ==============================================================================
#FACTORS 
# ==============================================================================

# 1. Create a character vector
weather_data <- c("Sunny", "Rainy", "Cloudy", "Sunny", "Cloudy")

# 2. Convert to a Basic Factor (Nominal)
# R will automatically assign levels alphabetically: Cloudy, Rainy, Sunny
weather_factor <- factor(weather_data)

print("Basic Factor:")
print(weather_factor)
print(levels(weather_factor)) # View the unique categories


# 3. Create an Ordered Factor (Ordinal)
# Useful for levels that have a natural rank (Small < Medium < Large)
temp_data <- c("Medium", "High", "Low", "High", "Medium")

temp_factor <- factor(temp_data, 
                      levels = c("Low", "Medium", "High"), 
                      ordered = TRUE)

print("Ordered Factor:")
print(temp_factor)


# 4. Modifying Factors
# Let's rename the levels to be more descriptive
levels(temp_factor) <- c("Chilly", "Mild", "Hot")

print("Renamed Levels:")
print(temp_factor)


# 5. Summary and Verification
print("Frequency Table:")
print(table(temp_factor)) # Counts how many of each level exist

# Check if it's a factor
is_it_factor <- is.factor(temp_factor)
print(paste("Is this a factor?", is_it_factor))


# 6. Converting back (The "Under the Hood" look)
# This shows how R stores factors as integers 1, 2, 3...
internal_integers <- as.numeric(temp_factor)
print("Internal Integer Storage:")
print(internal_integers)

#Goal	                  Function / Code
#Check Levels    	      levels(my_factor)
#Count Frequencies	      table(my_factor)
#Change Level Names	    levels(my_factor) <- c("A", "B")
#Check if Factor	        is.factor(my_factor)


# ==============================================================================
#Data Types / Data Structures
# ==============================================================================

# How atomic classes are organized (Vectors, Matrices, Arrays, Lists, Data Frames).

# ==============================================================================
# Vectors 
# ==============================================================================

# A vector is a 1-dimensional sequence of elements of THE SAME TYPE
# Most basic building block — everything else (matrices, arrays, lists, data frames) builds on it

# 1. Creating vectors – most common ways

# Atomic vectors (single type)
numeric_vec <- c(1.5, 3.2, -4, 0)          # numeric (double by default)
integer_vec <- c(1L, 5L, -3L, 0L)          # integer (note the L suffix)
char_vec    <- c("Kampala", "Entebbe", "Jinja", "Gulu")
logical_vec <- c(TRUE, FALSE, TRUE, NA)    # logical / boolean
complex_vec <- c(2+3i, -1+0i, 4-2i)

# Quick sequences (very common)
1:10                  # integer sequence → 1 2 3 ... 10
seq(0, 20, by = 2)    # 0 2 4 ... 20
seq(1, 10, length.out = 5)  # 5 evenly spaced numbers: 1 3.25 5.5 7.75 10

rep(7, times = 5)     # 7 7 7 7 7
rep(c("A", "B"), each = 3)  # A A A B B B

# 2. Checking type & structure
typeof(numeric_vec)    # "double"
class(numeric_vec)     # "numeric"
is.numeric(numeric_vec)   # TRUE
is.character(char_vec)    # TRUE
str(logical_vec)       #  logi [1:4] TRUE FALSE TRUE NA
length(numeric_vec)    # 4
mode(char_vec)         # "character"  (older way, still works)

# 3. Combining / concatenating vectors
v1 <- c(10, 20, 30)
v2 <- c(40, 50)
combined <- c(v1, v2, 60, 70)   # → 10 20 30 40 50 60 70

# 4. Vector arithmetic (element-wise — very powerful!)
a <- c(1, 2, 3, 4)
b <- c(10, 20, 30, 40)

a + b          # 11 22 33 44
a * 2          # 2 4 6 8          (recycling scalar)
a ^ 2          # 1 4 9 16
a > 2          # FALSE FALSE TRUE TRUE   (logical vector)
sqrt(a)        # element-wise square root

# Recycling rule (very important!)
short <- c(1, 2)
long  <- 1:6
short + long   # 2 4 4 6 6 8   (short vector is repeated)

# 5. Indexing / subsetting (many styles)

vec <- c(10, 20, 30, 40, 50, 60)

# Positive integers: select positions
vec[3]           # → 30
vec[c(1, 4, 6)]  # → 10 40 60
vec[2:5]         # → 20 30 40 50

# Negative integers: exclude positions
vec[-3]          # removes 3rd element → 10 20 40 50 60
vec[-c(1,6)]     # removes 1st & last

# Logical indexing (extremely useful!)
vec[vec > 35]          # → 40 50 60
vec[vec %% 2 == 0]     # even numbers only

# Named vectors (handy for lookup)
named_vec <- c(math = 85, english = 92, science = 78, history = 88)
named_vec["english"]          # → 92
named_vec[c("math", "science")]

names(named_vec)              # see names
names(named_vec)[3] <- "biology"   # rename

# 6. Missing values (NA) – very common in real data
scores <- c(90, 85, NA, 92, NA, 78)
is.na(scores)          # TRUE where missing
mean(scores)           # → NA   (most functions propagate NA)
mean(scores, na.rm = TRUE)   # → 86.25   (remove NA first)

# 7. Common functions on vectors
sum(vec)
mean(vec)
median(vec)
sd(vec)                # standard deviation
var(vec)
min(vec); max(vec)
range(vec)             # min & max together
sort(vec, decreasing = TRUE)
order(vec)             # indices that would sort it
rank(vec)              # ranks of each value

unique(c(1,2,2,3,3,3,4))   # → 1 2 3 4
table(c("red","blue","red","green","blue"))   # frequency count

# 8. Quick real-world mini-example
set.seed(42)
temps <- round(runif(7, min=22, max=32), 1)   # 7 random temperatures
days  <- c("Mon","Tue","Wed","Thu","Fri","Sat","Sun")

names(temps) <- days
temps

# Hot days
temps[temps >= 28]

# Average weekend temperature
mean(temps[c("Sat","Sun")])

# Days above average
temps > mean(temps)

# ==============================================================================
#Matrices (2D, Homogeneous)
# ==============================================================================
# A matrix is a 2-dimensional array → all elements MUST be of the SAME type
# Most often used for numeric data, but can hold characters, logicals, etc.

# 1. Creating a matrix – most common ways

# Method A: matrix() function (recommended)
mat1 <- matrix(1:12, nrow = 4, ncol = 3)
print(mat1)

#      [,1] [,2] [,3]
# [1,]    1    5    9
# [2,]    2    6   10
# [3,]    3    7   11
# [4,]    4    8   12

# Method B: fill by row instead of by column (default is by column)
mat_row <- matrix(1:12, nrow = 4, ncol = 3, byrow = TRUE)
print(mat_row)

#      [,1] [,2] [,3]
# [1,]    1    2    3
# [2,]    4    5    6
# [3,]    7    8    9
# [4,]   10   11   12

# Method C: from a vector with dim()
vec <- 1:15
dim(vec) <- c(5, 3)          # turns vector into 5×3 matrix
print(vec)

# Method D: combine vectors by column or row
col1 <- c(10, 20, 30)
col2 <- c(15, 25, 35)
mat_cols <- cbind(col1, col2)     # column-bind
mat_rows <- rbind(col1, col2)     # row-bind

# 2. Naming rows and columns (very useful)
rownames(mat1) <- c("R1", "R2", "R3", "R4")
colnames(mat1) <- c("Math", "Physics", "Chem")
print(mat1)

#     Math Physics Chem
# R1    1       5    9
# R2    2       6   10
# R3    3       7   11
# R4    4       8   12

# 3. Accessing elements (very similar to arrays)
mat1[2, 3]          # → 10          (row 2, column 3)
mat1[3, ]           # entire 3rd row
mat1[, "Physics"]   # entire Physics column (named access)
mat1["R2", c("Math", "Chem")]   # selected rows & columns
mat1[1:3, 2]        # rows 1–3, column 2

# 4. Important: matrices are stored COLUMN-MAJOR order
# That means elements are filled down columns first (like most linear algebra libraries)

# 5. Basic matrix operations (very fast in R)
A <- matrix(1:4, 2, 2)
B <- matrix(5:8, 2, 2)
A
B

A + B               # element-wise addition
A * B               # element-wise multiplication
A %*% B             # matrix multiplication (most important!)
t(A)                # transpose
solve(A)            # inverse (if square & invertible)
det(A)              # determinant
eigen(A)            # eigenvalues & eigenvectors
svd(A)              # singular value decomposition

# 6. Row / column operations
rowSums(mat1)       # sum of each row
colMeans(mat1)      # mean of each column
apply(mat1, 1, sd)  # standard deviation per row
apply(mat1, 2, max) # max per column

# 7. Logical indexing / subsetting
mat1[mat1 > 7]      # returns vector of values > 7
mat1[mat1[, "Math"] >= 3, ]   # rows where Math ≥ 3

# 8. Converting to/from other types
as.matrix(data.frame(a=1:3, b=4:6))   # data.frame → matrix
as.data.frame(mat1)                   # matrix → data.frame
as.vector(mat1)                       # flatten to vector
c(mat1)                               # same as above

# 9. Real-world mini example: covariance matrix
set.seed(42)
scores <- matrix(rnorm(50, mean=70, sd=10), nrow=10, ncol=5,
                 dimnames = list(NULL, c("Math","Eng","Sci","Hist","Geo")))

cov_mat <- cov(scores)          # sample covariance matrix
cor_mat <- cor(scores)          # correlation matrix

print(round(cor_mat, 2))

# Quick check: is it symmetric? (should be)
all.equal(cov_mat, t(cov_mat))   # TRUE


# ==============================================================================
#Arrays 
# ==============================================================================

# An array is a multi-dimensional generalization of a vector
# All elements must be of the SAME data type (like vectors)

# 1. Creating a basic 1D array (same as vector in this case)
arr1 <- array(1:12)
print(arr1)
# Output: [1]  1  2  3  4  5  6  7  8  9 10 11 12

# 2. Creating a 2D array (most common use – like a matrix)
arr2 <- array(1:12, dim = c(4, 3))   # 4 rows × 3 columns
print(arr2)

#       [,1] [,2] [,3]
# [1,]    1    5    9
# [2,]    2    6   10
# [3,]    3    7   11
# [4,]    4    8   12

# 3. Creating a true 3D array (most typical "array" use in statistics)
arr3 <- array(1:24, dim = c(4, 3, 2))   # 4 rows × 3 cols × 2 layers
print(arr3)

# , , 1
#      [,1] [,2] [,3]
# [1,]    1    5    9
# [2,]    2    6   10
# [3,]    3    7   11
# [4,]    4    8   12
#
# , , 2
#      [,1] [,2] [,3]
# [1,]   13   17   21
# [2,]   14   18   22
# [3,]   15   19   23
# [4,]   16   20   24

# 4. Naming dimensions (very useful for clarity)
arr_named <- array(1:24,
                   dim = c(4, 3, 2),
                   dimnames = list(
                     rows    = c("R1","R2","R3","R4"),
                     cols    = c("C1","C2","C3"),
                     layers  = c("Year1","Year2")
                   ))

print(arr_named)

# 5. Accessing elements
arr3[1, 2, 1]      # → 5     (row 1, column 2, layer 1)
arr3[ , , 2]       # entire second layer (4×3 matrix)
arr3[2:3, c(1,3), ] # rows 2-3, columns 1 and 3, all layers

# 6. Modifying / assigning values
arr3[1,1,1] <- 999
arr3[ , , 2] <- arr3[ , , 2] * 10   # multiply second layer by 10

# 7. Useful functions
dim(arr3)          # returns: 4 3 2
length(arr3)       # total elements: 24
str(arr3)          # structure overview

# 8. Converting between array and matrix/vector
m <- matrix(1:12, nrow=4)
a <- as.array(m)          # becomes 4×3×1 array

# 9. Real-world example: 3 subjects × 5 students × 2 tests
scores <- array(runif(30, 50, 100),   # 30 random scores between 50-100
                dim = c(5, 3, 2),
                dimnames = list(
                  student = paste0("S",1:5),
                  subject = c("Math","Eng","Sci"),
                  test    = c("Midterm","Final")
                ))

print(scores)

# Average per subject (across students and tests)
apply(scores, 2, mean)

# Average per student
apply(scores, 1, mean)

# Average final exam only
mean(scores[ , , "Final"])

# ==============================================================================
# Lists (Heterogeneous)
# ==============================================================================
# A list is a very flexible container that can hold elements of DIFFERENT types
# Unlike vectors/arrays → elements can be numbers, characters, vectors, matrices, other lists, functions, etc.

# 1. Creating a simple list
my_list <- list(
  name    = "John",
  age     = 28,
  scores  = c(85, 92, 78, 95),
  passed  = TRUE,
  subjects = c("Math", "Physics", "Chemistry")
)

print(my_list)

# 2. Different ways to create the same list
# Way A: using names directly (most readable)
person <- list(name = "Sara", age = 34, city = "Kampala")

# Way B: unnamed + add names later
person2 <- list("Sara", 34, "Kampala")
names(person2) <- c("name", "age", "city")

# Way C: mix named and unnamed elements
mixed <- list("Kampala", temp = 28.5, raining = FALSE, districts = c("Central", "Eastern"))

# 3. Accessing list elements (THREE main ways)

# 3.1 Single bracket [ ] → returns a list (preserves list structure)
my_list[1]          # returns list with one element
my_list["name"]     # same, using name
my_list[c(1,3)]     # returns a sub-list with elements 1 and 3

# 3.2 Double bracket [[ ]] → extracts the actual content (most common)
my_list[[1]]        # → "John"     (character)
my_list[["scores"]] # → c(85, 92, 78, 95)  (numeric vector)
my_list[[4]]        # → TRUE

# 3.3 Dollar sign $ → named access (very common & readable)
my_list$name        # → "John"
my_list$scores      # → vector of scores
my_list$scores[2]   # → 92   (combine with vector indexing)

# 4. Useful: nested lists (lists inside lists)
student_records <- list(
  student1 = list(
    name = "Aisha",
    id = "S001",
    grades = list(math = 89, english = 76, science = 92)
  ),
  student2 = list(
    name = "Brian",
    id = "S002",
    grades = list(math = 95, english = 88, science = 85)
  )
)

# Accessing nested elements
student_records$student1$grades$math          # → 89
student_records[["student2"]][["grades"]][["science"]]  # → 85

# 5. Modifying lists
my_list$age <- 29                      # change existing element
my_list$new_field <- "UGANDA"          # add new element
my_list$scores[5] <- 100               # add to vector inside list
my_list[[6]] <- matrix(1:6, 2, 3)      # add a matrix

# Remove element
my_list$passed <- NULL                 # removes 'passed'

# 6. Checking structure & length
str(my_list)          # very useful — shows structure clearly
length(my_list)       # number of top-level elements
names(my_list)        # get/set names

# 7. Combining / creating lists
list1 <- list(a = 1:3, b = "hello")
list2 <- list(x = TRUE, y = 3.14)
list1
list2

combined <- c(list1, list2)           # simple concatenation
combined <- list(part1 = list1, part2 = list2)  # nested


# ==============================================================================
#2.4 Data Frames (Tabular, Heterogeneous Columns)
# ==============================================================================

# A data frame is a rectangular table (2D structure)
# → list of equal-length vectors (columns), each can be different type
# → most common way to store real-world datasets in R

# 1. Creating a data frame (base R way)
df_base <- data.frame(
  name    = c("Aisha", "Brian", "Clara", "David"),
  age     = c(25, 31, 28, 42),
  city    = c("Kampala", "Entebbe", "Jinja", "Gulu"),
  salary  = c(4500000, 6200000, 5100000, 8900000),
  is_senior = c(FALSE, TRUE, FALSE, TRUE),
  stringsAsFactors = FALSE   # ← prevents automatic factor conversion (good habit)
)

print(df_base)


# 2. Modern / tidyverse way → use tibble (recommended today)
# install.packages("tibble")   # once
library(tibble)

df_tibble <- tibble(
  name    = c("Aisha", "Brian", "Clara", "David"),
  age     = c(25, 31, 28, 42),
  city    = c("Kampala", "Entebbe", "Jinja", "Gulu"),
  salary  = c(4500000, 6200000, 5100000, 8900000),
  is_senior = c(FALSE, TRUE, FALSE, TRUE)
)

df_tibble   # nicer printing: shows only first 10 rows, types, etc.

# 3. Quick inspection tools
str(df_base)          # structure: types + first few values
glimpse(df_tibble)    # tidyverse version — very readable
head(df_base, 3)      # first 3 rows
tail(df_base)         # last 6 rows by default
dim(df_base)          # rows × columns → 4 5
nrow(df_base)         # 4
ncol(df_base)         # 5
names(df_base)        # column names
colnames(df_base)     # same as names()
rownames(df_base)     # row names (usually 1,2,3,...)

summary(df_base)      # quick stats per column

# 4. Accessing elements (many ways – choose what you like)

# Like matrix / array (position-based)
df_base[1, 3]            # → "Kampala"  (row 1, column 3)
df_base[ , "salary"]     # entire salary column (as vector)
df_base[2:4, c("name","age")]   # rows 2–4, selected columns

# Like list (because data frame IS a list underneath)
df_base$name             # → vector "Aisha" "Brian" ...
df_base[["city"]]        # same as above
df_base[[4]]             # 4th column (salary vector)

# 5. Adding / changing columns
df_base$bonus <- df_base$salary * 0.15          # new column
df_base$age_group <- ifelse(df_base$age >= 30, "Senior", "Junior")

# Modify existing
df_base$salary[1] <- 4800000

# Remove column
df_base$bonus <- NULL

# 6. Factors (categorical variables – common gotcha in base R)
# By default data.frame() turns strings → factors (old behavior)
# Modern best practice: keep as character or use factor() intentionally

df_base$city <- as.factor(df_base$city)   # make it categorical
levels(df_base$city)                      # see categories



# ==============================================================================
# String Operations
# ==============================================================================


# 1. Basic creation and concatenation
name <- "money"
city <- "Kampala"

# paste() – most common way to combine strings
paste("Hello", name, "from", city)                  # → "Hello money from Kampala"
paste(name, "lives in", city, sep = " - ")          # → "money - lives in - Kampala"

# paste0() – no space by default (very popular)
paste0("file_", name, "_2026.csv")                  # → "file_money_2026.csv"

# collapse many strings into one
fruits <- c("mango", "banana", "pineapple")
paste(fruits, collapse = ", ")                      # → "mango, banana, pineapple"

# 2. sprintf() / format() – C-style formatting (very readable)
sprintf("User: %s | Age: %d | Balance: UGX %d", 
        name, 30, 4500000)                          # → "User: money | Age: 30 | Balance: UGX 4,500,000"

format(1234567.89, big.mark = ",", nsmall = 2)      # → "1,234,567.89"

# 3. String length & counting
nchar("Kampala")                                    # → 7
nchar(c("hello", "world", NA))                      # → 5  5 NA

# 4. Case conversion
toupper("hello world")                              # → "HELLO WORLD"
tolower("Kampala Uganda")                           # → "kampala uganda"
tools::toTitleCase("this is a title")               # → "This Is A Title"

# 5. Substring extraction
substr("Kampala", 1, 3)                             # → "Kam"
substr("Kampala", 4, 7)                             # → "pala"

# substring() – can assign too
x <- "123456"
substring(x, 3, 5) <- "XXX"
x                                                   # → "12XXX6"

# 6. Searching / detecting patterns
grepl("ala", "Kampala")                             # → TRUE
grepl("kampala", "Kampala", ignore.case = TRUE)     # → TRUE

# Which elements contain pattern?
cities <- c("Kampala", "Entebbe", "Jinja", "Gulu")
grepl("a$", cities)                                 # ends with 'a' → TRUE FALSE FALSE FALSE

# Find position
regexpr("ala", "Kampala")                           # → 5 (position), attr "match.length"

# 7. Extracting parts with regular expressions
string <- "Contact: money@example.com | +256 777 123456"

# Extract email
sub(".*@([^ ]+).*", "\\1", string)                  # → "example.com"

# Better: regmatches + regexpr
email <- regmatches(string, regexpr("[[:alnum:].-]+@[[:alnum:].-]+", string))
email                                               # → "money@example.com"

# 8. Replacement / substitution
gsub("old", "new", "old data old style old way")    # → "new data new style new way"

# Remove digits
gsub("[0-9]", "", "Room 405, Plot 12")              # → "Room , Plot "

# Clean phone numbers
phone <- "+256-777-123-456"
gsub("[^0-9]", "", phone)                           # → "256777123456"

# 9. Splitting strings
full_name <- "money   from   Kampala"
strsplit(full_name, " +")[[1]]                      # → "money" "from" "Kampala"   (split on 1+ spaces)

dates <- "2025-02-21,2026-01-15"
strsplit(dates, ",")[[1]]                           # → two dates

# 10. Most useful stringr equivalents (tidyverse – highly recommended in 2025–2026)
# install.packages("stringr")   # once

library(stringr)

str_length("Kampala")                               # same as nchar()
str_to_upper("hello")                               # same as toupper()
str_to_title("this is nice")                        # → "This Is Nice"

str_detect(cities, "ala")                           # → TRUE FALSE FALSE FALSE
str_extract(string, "[[:alnum:].-]+@[[:alnum:].-]+") # → email
str_replace_all("old old old", "old", "new")        # like gsub


#Task                     | Base R                | stringr (preferred today)      | Notes                              |

#| Concatenate            | paste(), paste0()     | str_c(), str_glue()            | str_glue() very readable           |
#| Length                 | nchar()               | str_length()                   | handles NA better                  |
#| Upper/lower/title      | toupper(), tolower()  | str_to_upper(), str_to_title() | locale-aware                       |
#| Contains pattern       | grepl()               | str_detect()                   | str_detect() more consistent       |
#| Replace all            | gsub()                | str_replace_all()              | str_replace() does first only      |
#| Extract first match    | regmatches() / sub()  | str_extract()                  | str_extract_all() gets all         |
#| Split into list        | strsplit()            | str_split()                    | str_split_1() for single string    |
#| Trim whitespace        | trimws()              | str_trim()                     | str_squish() removes multiples     |


# ==============================================================================
# Operators
# ==============================================================================
# Main categories: Arithmetic, Relational/Comparison, Logical, Assignment, Miscellaneous/Special

# 1. Arithmetic Operators (element-wise on numerics)
# Work on vectors, matrices, arrays → very powerful for data

a <- c(10, 20, 30)
b <- c(3, 4, 5)

a + b     # 13 24 35
a - b     #  7 16 25
a * b     # 30 80 150
a / b     # 3.333... 5 6
a ^ b     # 1000 160000 24300000   (exponentiation = ** also works)
a %% b    # 1 0 0     (modulo / remainder)
a %/% b   # 3 5 6     (integer division)

# Scalar recycling example
a * 2     # 20 40 60

# 2. Relational / Comparison Operators (return logical vectors)
# Element-wise comparison

x <- c(5, 10, 15, 20)
y <- c(10, 10, 5, 25)

x <  y     # TRUE FALSE FALSE TRUE
x <= y     # TRUE TRUE  FALSE TRUE
x >  y     # FALSE FALSE TRUE  FALSE
x >= y     # FALSE TRUE  TRUE  FALSE
x == y     # FALSE TRUE  FALSE FALSE   ← note: TWO equals signs!
x != y     # TRUE  FALSE TRUE  TRUE

# Very common use: logical indexing / subsetting
x[x > 12]          # → 15 20

# 3. Logical Operators
# Two flavors: vectorized (single & |) vs scalar/control-flow (double && ||)

# Vectorized (element-wise — most common in data work)
c(TRUE, FALSE, TRUE) & c(TRUE, TRUE, FALSE)    # TRUE FALSE FALSE
c(TRUE, FALSE, TRUE) | c(TRUE, TRUE, FALSE)    # TRUE TRUE  TRUE

# Short-circuit / scalar versions (used in if() conditions)
# Only evaluate second argument if needed
TRUE && FALSE     # FALSE   (second not evaluated if first is FALSE)
TRUE || stop("boom")   # TRUE  (second not evaluated)

# Logical NOT
!c(TRUE, FALSE, NA)   # FALSE TRUE NA

# NA propagation
NA & TRUE    # NA
NA | FALSE   # NA

# 4. Assignment Operators
# Four main styles — choose one consistently!

x <- 10       # left assignment (most recommended style)
10 -> x       # right assignment (less common)

x = 10        # works, but NOT recommended in scripts (can confuse with function args)
# Safe only at top level or inside ( )

# Global / super assignment (rare, used in functions to modify outer scope)
x <<- 999     # assigns to global environment even from inside function

# 5. Miscellaneous / Special Operators (very R-specific)

# Sequence operator (very common!)
1:10          # 1  2  3 ... 10
5:-3          # 5  4  3  2  1  0 -1 -2 -3

# Matrix multiplication
A %*% B       # matrix product (not element-wise!)

# Special infix operators (user-definable!)
`%myop%` <- function(x, y) x + 2*y
3 %myop% 4    # → 11

# Pipe operator (since R 4.1+ — hugely popular!)
# Native |>    or  magrittr / tidyverse %>%
mtcars |> 
  subset(hp > 150) |> 
  head(5)

# Component / slot extraction
list(a=1, b=2)$a          # 1
df$salary
S4_object@slotname



# ==============================================================================
#conditional flow statements
# ==============================================================================

# ==============================================================================
#If statements & conditional 
# ==============================================================================


# 1. Basic if statement
age <- 25

if (age >= 18) {
  print("You are an adult")
}

# Nothing prints if condition is FALSE

# 2. if ... else
temperature <- 28

if (temperature > 30) {
  print("It's hot!")
} else {
  print("It's comfortable")
}

# 3. if ... else if ... else (chained conditions)
score <- 78

if (score >= 90) {
  grade <- "A"
} else if (score >= 80) {
  grade <- "B"
} else if (score >= 70) {
  grade <- "C"
} else if (score >= 60) {
  grade <- "D"
} else {
  grade <- "F"
}

print(paste("Your grade is:", grade))

# 4. Very important: if() expects a SINGLE logical value
# This is correct:
if (length(x) > 0) { ... }

# This causes ERROR or warning (most common beginner mistake):
x <- c(5, 10, 15)
if (x > 10) {          # ← x > 10 gives c(FALSE, FALSE, TRUE) — multiple values!
  print("Some are big")
}
# → Warning: the condition has length > 1 and only the first element will be used

# Correct ways:
if (any(x > 10)) { ... }      # at least one TRUE
if (all(x > 10)) { ... }      # all are TRUE
if (sum(x > 10) > 0) { ... }  # same as any()

# 5. ifelse() — vectorized version (very common in R!)
# Much faster & cleaner than loops for vectors

scores <- c(45, 82, 67, 91, 55)

result <- ifelse(scores >= 60,
                 "Pass",
                 "Fail")

print(result)
# → "Fail" "Pass" "Pass" "Pass" "Fail"

# Another classic use:
sales <-23
bonus <- ifelse(sales > 1000000, 0.15 * sales, 0)
# or
category <- ifelse(age < 18, "Child",
                   ifelse(age < 65, "Adult", "Senior"))

# 6. Multiple conditions with logical operators
income <- 4500000
has_degree <- TRUE
experience <- 4

if (income > 3000000 && has_degree && experience >= 3) {
  print("Eligible for senior position")
} else {
  print("Not eligible yet")
}

# Note: && and || are short-circuiting → safe & efficient
# & and | are vectorized → usually NOT what you want inside if()

# 7. Nested if (sometimes needed, but prefer readability)
price <- 120000

if (price > 100000) {
  if (price > 150000) {
    discount <- 0.20
  } else {
    discount <- 0.10
  }
} else {
  discount <- 0
}


# 8. switch() — nice alternative for multiple exact matches
operation <- "add"
a <- 10; b <- 5

result <- switch(operation,
                 "add"    = a + b,
                 "subtract" = a - b,
                 "multiply" = a * b,
                 "divide"   = a / b,
                 "unknown operation"
)

print(result)  # → 15



# ==============================================================================
# For loop
# ==============================================================================


# 1. Basic syntax – looping over a sequence/vector
for (i in 1:5) {
  print(i)
}
# Prints:
# [1] 1
# [1] 2
# [1] 3
# [1] 4
# [1] 5

# 2. Most common & recommended style: loop over elements directly
fruits <- c("mango", "banana", "pineapple", "passion")

for (fruit in fruits) {
  cat("I like", fruit, "\n")
}
# → I like mango
#   I like banana
#   etc.

# 3. Looping over indices (when you need position)
scores <- c(78, 92, 65, 88, 45)
for (i in seq_along(scores)) {          # seq_along() is safer than 1:length()
  if (scores[i] >= 80) {
    cat("Student", i, "passed with", scores[i], "\n")
  }
}

# 4. Pre-allocating vectors (very important for speed!)
n <- 10000
result <- numeric(n)          # pre-allocate — 1000× faster than growing!

for (i in 1:n) {
  result[i] <- i ^ 2 + sin(i)
}

# Bad / slow version (avoid this!)
bad_result <- c()
for (i in 1:n) {
  bad_result <- c(bad_result, i ^ 2)   # copies vector every time!
}

# 5. Looping over lists (very common when working with complex objects)
students <- list(
  list(name = "Aisha", scores = c(85, 92)),
  list(name = "Brian", scores = c(78, 88)),
  list(name = "Clara", scores = c(95, 91))
)

for (student in students) {
  avg <- mean(student$scores)
  cat(student$name, "→ average:", round(avg, 1), "\n")
}

# 6. Nested for loops (e.g. matrix filling / simulation)
mat <- matrix(0, nrow = 5, ncol = 5)

for (i in 1:5) {
  for (j in 1:5) {
    mat[i, j] <- i + j
  }
}
print(mat)

#How the above code executes
#Outer Loop (i): Picks a row (starts at 1).
#Inner Loop (j): Moves across every column in that row (1 through 5).
#Calculation: At each "intersection," it performs $i + j$.



# 7. for loop + if / break / next
for (i in 1:10) {
  if (i == 3) next          # skip this iteration
  if (i == 7) break         # exit loop completely
  print(i)
}
# Prints: 1 2 4 5 6

# 8. Alternatives to for loops (often preferred in R)

# A. apply family (classic base R)
sapply(1:5, function(x) x^2)

# B. lapply / sapply on lists/vectors
lapply(students, function(s) mean(s$scores))

# C. purrr::map (tidyverse style – very readable)
library(purrr)
map_dbl(students, ~ mean(.x$scores))


#

#| Situation                              | Best choice in modern R (2025–2026)   | Why / Notes                                  |
#|----------------------------------------|---------------------------------------|----------------------------------------------|
#| Simple sequence / learning             | for loop                              | Easy to read & understand                    |
#| Need index & value                     | for (i in seq_along(x))               | or walk2() from purrr                        |
#| Apply same function to list elements   | lapply() / map()                      | Cleaner, no side effects                     |
#| Transform columns in data frame        | across() + mutate()                   | Fast, readable, grouped-aware                |
#| Heavy numeric computation              | vectorized ops (no loop!)             | 10–1000× faster                              |
#| Very simple one-off script             | for loop is fine                      | Don't over-engineer                          |

# 
# "If you can avoid a for loop, you usually should — 
# but when you need it, use it proudly and pre-allocate!"

# ==============================================================================
# While Loops 
# ==============================================================================

# 1. Basic syntax
count <- 1

while (count <= 5) {
  print(paste("Count is now:", count))
  count <- count + 1
}
# Prints:
# [1] "Count is now: 1"
# [1] "Count is now: 2"
# ...
# [1] "Count is now: 5"

# 2. Classic example: keep going until condition fails
balance <- 1000000
withdrawal <- 150000
months <- 0

while (balance >= withdrawal) {
  balance <- balance - withdrawal
  months <- months + 1
  cat("Month", months, ": balance =", balance, "\n")
}

cat("Ran out of money after", months, "months\n")

# 3. Very important: AVOID infinite loops!
# Always make sure the condition can eventually become FALSE

# BAD (infinite loop – do NOT run this!)
# x <- 5
# while (x > 0) {
#   print(x)
#   # forgot to decrease x → infinite!
# }

# Safe version with safety net
i <- 1
max_iterations <- 100

while (i <= 20 && i <= max_iterations) {
  print(i)
  i <- i + 1
}

# 4. while + break (exit early)
secret_number <- 7
guess <- 0
attempts <- 0

while (guess != secret_number) {
  guess <- as.integer(readline("Guess a number 1–10: "))
  attempts <- attempts + 1
  
  if (guess == secret_number) {
    cat("Correct! You won in", attempts, "attempts!\n")
    break
  } else if (attempts >= 5) {
    cat("Too many attempts! Game over.\n")
    break
  } else {
    cat("Wrong. Try again.\n")
  }
}

# 5. while + next (skip rest of loop body)
i <- 0

while (i < 10) {
  i <- i + 1
  
  if (i %% 3 == 0) {
    next          # skip printing multiples of 3
  }
  
  print(i)
}
# Prints: 1 2 4 5 7 8 10

# 6. Common real-world use cases


# ==============================================================================
#break, next, with repeat
# ==============================================================================
# break, next  (repeat + break)


#Stop when condition is met
for (i in 1:10) {
  cat("i =", i, "\n")
  if (i >= 5) {
    cat("→ Stopping at 5\n")
    break          # exits the for loop completely
  }
}


###some little guessing game
# while + break (very common)
secret <- 7
attempts <- 0

while (TRUE) {                # intentional infinite loop
  guess <- as.integer(readline("Guess (1–10): "))
  attempts <- attempts + 1
  
  if (guess == secret) {
    cat("Correct! Took", attempts, "tries.\n")
    break
  }
  
  if (attempts >= 3) {
    cat("Game over – too many attempts.\n")
    break
  }
  
  cat("Wrong. Try again.\n")
}


#Skip the rest of the current iteration

#Jumps to the next iteration immediately — skips remaining code in this loop cycle.

# Skip even numbers
for (i in 1:10) {
  if (i %% 2 == 0) {
    next           # skip printing even numbers
  }
  cat("Odd number:", i, "\n")
}


# Real-world: skip missing values in processing
values <- c(10, NA, 25, 8, NA, 33)

for (v in values) {
  if (is.na(v)) {
    next
  }
  cat("Processing:", v, "→ squared =", v^2, "\n")
}


##USING REPEAT (like while)

cat("Starting...\n\n")

# Simple repeat loop (this is the "until" style in R)
i <- 0

repeat {
  i <- i + 1
  
  # skip number 3 and 7 (using next)
  if (i == 3 || i == 7) {
    cat("→ skipping", i, "\n")
    next
  }
  
  cat("Number:", i, "\n")
  
  # stop when we reach 10 (using break)
  if (i >= 10) {
    cat("→ stopping now\n")
    break
  }
}

cat("\nFinished!\n")








### Quick Comparison Table
#break`           = Exit loop immediately                     
#next`            =Skip to next iteration                        
#`repeat { ... }` = Infinite loop until `break`               
#`while (TRUE)`    = Same as repeat                            


# ==============================================================================
# Creating and Using Functions
# ==============================================================================

# 1. Basic function definition
add_two <- function(x) {
  x + 2
}

add_two(5)          # → 7
add_two(c(1, 10))   # → 3 12   (vectorized automatically)

# 2. Multiple arguments
power <- function(base, exponent = 2) {   # exponent has default value
  base ^ exponent
}

power(3)            # → 9     (uses default exponent = 2)
power(3, 4)         # → 81
power(exponent = 3, base = 2)   # named arguments — order doesn't matter

# 3. Returning values explicitly (good habit)
greet <- function(name) {
  message <- paste("Hello,", name, "from Kampala!")
  return(message)          # explicit return (optional but clear)
}

greet("client")

# 4. Functions that return multiple values , usually return a list
stats_summary <- function(numbers) {
  if (length(numbers) == 0) {
    return(list(error = "Empty vector"))
  }
  
  list(
    mean   = mean(numbers, na.rm = TRUE),
    median = median(numbers, na.rm = TRUE),
    sd     = sd(numbers, na.rm = TRUE),
    n      = length(numbers),
    min    = min(numbers, na.rm = TRUE),
    max    = max(numbers, na.rm = TRUE)
  )
}

result <- stats_summary(c(10, 15, NA, 8, 22))
result
str(result)

# 5. Functions with side effects (printing, plotting, writing files)
show_info <- function(name, age) {
  cat("Name:", name, "\n")
  cat("Age: ", age,  " years\n")
  cat("Location: Kampala, UG\n")
  # no return → returns last evaluated expression (usually invisible)
}

show_info("client", 30)   # prints directly, returns NULL invisibly

# 6. Checking arguments (defensive programming)
safe_divide <- function(a, b) {
  if (!is.numeric(a) || !is.numeric(b)) {
    stop("Both arguments must be numeric")
  }
  if (b == 0) {
    stop("Division by zero is not allowed")
  }
  a / b
}

# safe_divide("10", 2)   # → error
# safe_divide(10, 0)     # → error

# 7. Using ... (ellipsis) for extra arguments

# Pass extra arguments to another function 
my_plot <- function(x, y, ...) {
  plot(x, y, pch = 19, col = "blue", ...)
}

my_plot(1:10, 1:10, main = "Nice plot", xlab = "Time", cex = 1.5)
# → ... passes main, xlab, cex to plot()

# Accept any number of arguments
sum_any <- function(...) {
  sum(c(...))
}

sum_any(1, 2, 3, 4, 5)          # 15
sum_any(10, 20, -5, NA)         # NA (unless you handle it)

#Forward ... to multiple functions
f <- function(a, b, ...) {
  list(
    mean = mean(c(a, b), ...),
    sum  = sum(c(a, b), ...)
  )
}

f(1, 2, na.rm = TRUE)          # works for both mean() and sum()


# 8. Anonymous / inline functions (very common)
# Used in many base functions and tidyverse
(function(x) x^2 + 3)(5)          # → 28

# Sort with custom comparison
sort(c(5, 2, 8, 1), decreasing = TRUE)

# Very short form (R ≥ 4.1)
\(x) x + 10     # same as function(x) x + 10

# 9. Functions that modify objects (less common – prefer return values)
increment <- function(x) {
  x + 1
}

value <- 100
value <- increment(value)   # typical pattern

# Rare / advanced: modify in place using <<- (global assignment)
counter <- 0
increment_global <- function() {
  counter <<- counter + 1
  counter
}

increment_global()   # 1
increment_global()   # 2
# (avoid <<- in most code — makes debugging hard)


# ==============================================================================
#The Apply functions
# ==============================================================================


# 1. lapply() → always returns a LIST
# Apply a function to each element of a list/vector → result is list

numbers <- list(a = 1:5, b = 10:15, c = c(2,7,3,9))

lapply(numbers, mean)
# $a
# [1] 3
# $b
# [1] 12.5
# $c
# [1] 5.25

lapply(numbers, function(x) x > 5)          # returns list of logical vectors

# Very common pattern: extract first element of each sub-list/vector
lapply(students, function(s) s$name)        # where students is list of lists


# 2. sapply() → "simplified" version of lapply
# Tries to simplify result to vector/matrix/array if possible

sapply(numbers, mean)          # → named numeric vector:  3.0 12.5  5.25

sapply(numbers, range)         # → matrix 2 × 3 (min & max per group)

# Control simplification
sapply(numbers, mean, simplify = FALSE)   # same as lapply
sapply(numbers, mean, simplify = "array") # force array if possible

# 3. vapply() → safest & fastest (you specify output type)
# Recommended when you know what the result should be

vapply(numbers, mean, numeric(1))          # must return 1 number ,error if not

vapply(numbers, length, integer(1))        # returns integer vector of lengths

# 4. apply() → apply over margins of arrays/matrices (2D or higher)

mat <- matrix(1:12, nrow = 4, ncol = 3)
rownames(mat) <- paste0("R",1:4)
colnames(mat) <- c("A","B","C")

apply(mat, 1, sum)          # sum per ROW    (MARGIN = 1)
apply(mat, 2, mean)         # mean per COLUMN (MARGIN = 2)
apply(mat, c(1,2), sqrt)    # apply to every single element

# Classic use: row/column summaries
apply(mat, 1, function(row) c(mean = mean(row), sd = sd(row)))

# 5. tapply() → apply function to subsets defined by factors/groups

group <- factor(c("A","A","B","B","A","C"))
values <- c(10, 15, 8, 12, 18, 7)

tapply(values, group, mean)
#        A        B        C 
# 14.33333 10.00000  7.00000 

tapply(values, group, summary)   # returns list of summary objects

# Very useful with data frames
tapply(mtcars$mpg, mtcars$cyl, mean)

# 6. mapply() → multivariate apply (multiple input vectors/lists)

x <- c(1, 2, 3)
y <- c(10, 20, 30)
z <- c("red", "blue", "green")

mapply(function(a,b,col) paste0(col, ": ", a+b),
       x, y, z)
# → character vector: "red: 11" "blue: 22" "green: 33"

# Recycling works if lengths differ (with warning if not multiple)
mapply(rep, 1:3, times = c(2,1,4))   # rep(1,2), rep(2,1), rep(3,4)

# 7. rapply() → recursive apply (for deeply nested lists)

nested <- list(a = list(1:3, list(4:5)), b = list(c(6,7)))
rapply(nested, function(x) x^2, how = "replace")

#Function |Input type               | Output type              | Margin / Grouping?  | Most common modern use-case                     |
#lapply   |vector / list            | always list              | no                  | safest default, works on everything              |
#sapply   |vector / list            | tries to simplify        | no                  | quick interactive work, named vectors            |
#vapply   |vector / list            | **you specify** type     | no                  | production code, fastest & type-safe             |
#apply    |matrix / array           | vector/matrix/list/array | yes (MARGIN)        | row/column summaries on matrices                 |
#tapply   |vector + grouping factor | list or simplified       | yes (INDEX)         | group-by summaries (pre-dplyr era)               |
#mapply   |multiple vectors/lists   | vector/matrix/list       | element-wise        | parallel processing of several inputs            |
#rapply   |nested lists             | list (recursive)         | recursive           | cleaning/processing deeply nested structures     |

# ==============================================================================


# ==============================================================================
# ==============================================================================


