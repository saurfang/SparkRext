# SparkRext - SparkR extension for closer to dplyr
Koji MAKIYAMA (@hoxo_m)  







## 1. Overview

[Apache Spark](https://spark.apache.org/) is one of the hottest products in data science.  
Spark 1.4.0 has formally adopted **SparkR** package which enables to handle Spark DataFrames on R.(See [this article](http://databricks.com/blog/2015/06/09/announcing-sparkr-r-on-spark.html))

SparkR is very useful and powerful.  
One of the reasons is that SparkR DataFrames present an API similar to **dplyr**.  

For example:




```r
df <- createDataFrame(sqlContext, iris)
df %>%
  select("Sepal_Length", "Species") %>%
  filter(df$Sepal_Length >= 5.5) %>%
  group_by(df$Species) %>%
  summarize(count=n(df$Sepal_Length), mean=mean(df$Sepal_Length)) %>%
  collect  
```

```
##      Species count     mean
## 1 versicolor    44 6.050000
## 2     setosa     5 5.640000
## 3  virginica    49 6.622449
```

This is very cool. But I have a little discontent.

One of the reasons that dplyr is so much popular is the functions adopts NSE(non-standard evaluation).


```r
library(dplyr)
iris %>%
  select(Sepal.Length, Species) %>%
  filter(Sepal.Length >= 5.5) %>%
  group_by(Species) %>%
  summarize(count = n(), mean = mean(Sepal.Length))
```

```
## Source: local data frame [3 x 3]
## 
##      Species count     mean
## 1     setosa     5 5.640000
## 2 versicolor    44 6.050000
## 3  virginica    49 6.622449
```

It's very smart.  
With NSE, you don't need to type quotations or names of DataFrame that the columns belong to.

The package **SparkRext** have been created to make SparkR be closer to dplyr.




```r
library(SparkRext)
df <- createDataFrame(sqlContext, iris)
df %>%
  select(Sepal_Length, Species) %>%
  filter(Sepal_Length >= 5.5) %>%
  group_by(Species) %>%
  summarize(count=n(Sepal_Length), mean=mean(Sepal_Length)) %>%
  collect  
```

```
##      Species count     mean
## 1 versicolor    44 6.050000
## 2     setosa     5 5.640000
## 3  virginica    49 6.622449
```

SparkRext redefines the functions of SparkR to enable NSE inputs.  
As a result, the functions will be able to be used in the same way as dplyr.

## 2. How to install

The source code for SparkRext package is available on GitHub at

- https://github.com/hoxo-m/SparkRext.

You can install the package from there.


```r
install.packages("devtools") # if you have not installed "devtools" package
devtools::install_github("hoxo-m/dplyrr")
```

## 3. Functions

SparkRext redefines six functions on SparkR.

- filter()
- select()
- mutate()
- arrange()
- summarize()
- group_by()

In this section, these funcions are explained.

For illustration, let’s prepare data.


```r
library(dplyr)
library(nycflights13)

set.seed(123)
data <- sample_n(flights, 10000)

prior_package(SparkRext)

df <- createDataFrame(sqlContext, data.frame(data))
df %>% head
```

```
##   year month day dep_time dep_delay arr_time arr_delay carrier tailnum
## 1 2013    12  15     2124        -4     2322         1      UA  N801UA
## 2 2013     7  17      651        -9      936       -28      DL  N194DN
## 3 2013     3   2     1636         1     1800         0      WN  N475WN
## 4 2013     8  19     1058        -2     1203       -32      WN  N765SW
## 5 2013     9   9     1251        -9     1412         3      US  N963UW
## 6 2013     1  18     1259        -1     1556       -14      WN  N654SW
##   flight origin dest air_time distance hour minute
## 1    289    EWR  DTW       88      488   21     24
## 2    763    JFK  LAX      306     2475    6     51
## 3   1501    LGA  MKE      103      738   16     36
## 4     51    LGA  MDW      107      725   10     58
## 5   2148    LGA  BOS       38      184   12     51
## 6   2239    EWR  HOU      222     1411   12     59
```

### 3-1. `filter()`

`filter()` is used to extract rows that the conditions specified are satisfied.


```r
df %>% filter(month == 12, day == 31) %>% head
```

```
##   year month day dep_time dep_delay arr_time arr_delay carrier tailnum
## 1 2013    12  31     1155        -5     1257       -11      B6  N216JB
## 2 2013    12  31     2211        12      100        15      B6  N715JB
## 3 2013    12  31     1504         9     1620        -5      MQ  N501MQ
## 4 2013    12  31     2328        -2      412         3      B6  N651JB
## 5 2013    12  31     1922        -8     2116         1      MQ  N501MQ
## 6 2013    12  31      849        -1     1225        -3      B6  N834JB
##   flight origin dest air_time distance hour minute
## 1    316    JFK  SYR       50      209   11     55
## 2   1183    JFK  MCO      148      944   22     11
## 3   3425    JFK  DCA       52      213   15      4
## 4   1389    EWR  SJU      198     1608   23     28
## 5   3535    JFK  CMH       82      483   19     22
## 6     15    JFK  SFO      371     2586    8     49
```


```r
df %>% filter(month == 12 | day == 31) %>% head
```

```
##   year month day dep_time dep_delay arr_time arr_delay carrier tailnum
## 1 2013    12  15     2124        -4     2322         1      UA  N801UA
## 2 2013    12  30     2031        -4     2351         4      DL  N3743H
## 3 2013    12  16     1248        -4     1407        -4      EV  N11548
## 4 2013    12  27      928        28     1307        48      DL  N901DE
## 5 2013    12   7     1719       -10     2008         8      F9  N209FR
## 6 2013    12  10       NA       NaN       NA       NaN      EV  N717EV
##   flight origin dest air_time distance hour minute
## 1    289    EWR  DTW       88      488   21     24
## 2   2065    JFK  FLL      173     1069   20     31
## 3   6054    EWR  IAD       49      212   12     48
## 4   2446    LGA  FLL      186     1076    9     28
## 5    507    LGA  DEN      269     1620   17     19
## 6   5245    LGA  PIT      NaN      335  NaN    NaN
```

Note that `filter()` of SparkR cannot accept multiple conditions at once.

### 3-2. `select()`

`select()` is used to extract columns specified.


```r
df %>% select(year, month, day) %>% head
```

```
##   year month day
## 1 2013    12  15
## 2 2013     7  17
## 3 2013     3   2
## 4 2013     8  19
## 5 2013     9   9
## 6 2013     1  18
```

Continuous columns can be extracted using a colon `:`.


```r
df %>% select(year:day) %>% head
```

```
##   year month day
## 1 2013    12  15
## 2 2013     7  17
## 3 2013     3   2
## 4 2013     8  19
## 5 2013     9   9
## 6 2013     1  18
```

You can use the minus sign `-` to extract columns with the exception of columns specified.


```r
df %>% select(-year, -month, -day) %>% head
```

```
##   dep_time dep_delay arr_time arr_delay carrier tailnum flight origin dest
## 1     2124        -4     2322         1      UA  N801UA    289    EWR  DTW
## 2      651        -9      936       -28      DL  N194DN    763    JFK  LAX
## 3     1636         1     1800         0      WN  N475WN   1501    LGA  MKE
## 4     1058        -2     1203       -32      WN  N765SW     51    LGA  MDW
## 5     1251        -9     1412         3      US  N963UW   2148    LGA  BOS
## 6     1259        -1     1556       -14      WN  N654SW   2239    EWR  HOU
##   air_time distance hour minute
## 1       88      488   21     24
## 2      306     2475    6     51
## 3      103      738   16     36
## 4      107      725   10     58
## 5       38      184   12     51
## 6      222     1411   12     59
```

You can also extract columns by using column numbers.


```r
df %>% select(1, 2, 3) %>% head
```

```
##   year month day
## 1 2013    12  15
## 2 2013     7  17
## 3 2013     3   2
## 4 2013     8  19
## 5 2013     9   9
## 6 2013     1  18
```

You can use the select utility functions in dplyr such as `starts_with()`.


```r
df %>% select(starts_with("arr")) %>% head
```

```
##   arr_time arr_delay
## 1     2322         1
## 2      936       -28
## 3     1800         0
## 4     1203       -32
## 5     1412         3
## 6     1556       -14
```

All select utility functions is below.

- `starts_with(match, ignore.case = TRUE)`
- `ends_with(match, ignore.case = TRUE)`
- `contains(match, ignore.case = TRUE)`
- `matches(match, ignore.case = TRUE)`
- `num_range(prefix, range, width = NULL)`
- `one_of(...)`
- `everything()`

Note that select() of SparkR cannot accept a variety of input like this.

### 3-3. `mutate()`

`mutate()` is used to add new columns.


```r
df %>% mutate(gain = arr_delay - dep_delay, speed = distance / air_time * 60) %>% head
```

```
##   year month day dep_time dep_delay arr_time arr_delay carrier tailnum
## 1 2013    12  15     2124        -4     2322         1      UA  N801UA
## 2 2013     7  17      651        -9      936       -28      DL  N194DN
## 3 2013     3   2     1636         1     1800         0      WN  N475WN
## 4 2013     8  19     1058        -2     1203       -32      WN  N765SW
## 5 2013     9   9     1251        -9     1412         3      US  N963UW
## 6 2013     1  18     1259        -1     1556       -14      WN  N654SW
##   flight origin dest air_time distance hour minute gain    speed
## 1    289    EWR  DTW       88      488   21     24    5 332.7273
## 2    763    JFK  LAX      306     2475    6     51  -19 485.2941
## 3   1501    LGA  MKE      103      738   16     36   -1 429.9029
## 4     51    LGA  MDW      107      725   10     58  -30 406.5421
## 5   2148    LGA  BOS       38      184   12     51   12 290.5263
## 6   2239    EWR  HOU      222     1411   12     59  -13 381.3514
```

Note that `mutate()` of SparkR cannot accept multiple input at once.  
Furthermore, `mutate()` of SparkR cannot also reuse columns added like below.


```r
df %>% mutate(gain = arr_delay - dep_delay, gain_per_hour = gain/(air_time/60)) %>% head
```

```
##   year month day dep_time dep_delay arr_time arr_delay carrier tailnum
## 1 2013    12  15     2124        -4     2322         1      UA  N801UA
## 2 2013     7  17      651        -9      936       -28      DL  N194DN
## 3 2013     3   2     1636         1     1800         0      WN  N475WN
## 4 2013     8  19     1058        -2     1203       -32      WN  N765SW
## 5 2013     9   9     1251        -9     1412         3      US  N963UW
## 6 2013     1  18     1259        -1     1556       -14      WN  N654SW
##   flight origin dest air_time distance hour minute gain gain_per_hour
## 1    289    EWR  DTW       88      488   21     24    5     3.4090909
## 2    763    JFK  LAX      306     2475    6     51  -19    -3.7254902
## 3   1501    LGA  MKE      103      738   16     36   -1    -0.5825243
## 4     51    LGA  MDW      107      725   10     58  -30   -16.8224299
## 5   2148    LGA  BOS       38      184   12     51   12    18.9473684
## 6   2239    EWR  HOU      222     1411   12     59  -13    -3.5135135
```

### 3-4. `arrange()`

`arrange()` is used to sort rows by columns specified.


```r
df %>% arrange(month, day) %>% head
```

```
##   year month day dep_time dep_delay arr_time arr_delay carrier tailnum
## 1 2013     1   1     1353        -4     1549        24      EV  N14105
## 2 2013     1   1     1832         4     2144         0      UA  N18220
## 3 2013     1   1      602        -3      821        16      MQ  N730MQ
## 4 2013     1   1     1416         5     1603        14      UA  N456UA
## 5 2013     1   1     1127        -2     1303        -6      EV  N14180
## 6 2013     1   1     2323        83       22        69      EV  N13538
##   flight origin dest air_time distance hour minute
## 1   4171    EWR  MSN      152      799   13     53
## 2   1075    EWR  SNA      342     2434   18     32
## 3   4401    LGA  DTW      105      502    6      2
## 4    683    EWR  ORD      136      719   14     16
## 5   4294    EWR  RDU       73      416   11     27
## 6   4257    EWR  BTV       44      266   23     23
```

It will be sorted in ascending order if you write just column names.  
If you want to sort in descending order, you can use `desc()`.


```r
df %>% arrange(month, desc(day)) %>% head
```

```
##   year month day dep_time dep_delay arr_time arr_delay carrier tailnum
## 1 2013     1  31     1424        -5     1752        -2      UA  N512UA
## 2 2013     1  31     1853        -2     2149         7      DL  N175DZ
## 3 2013     1  31      958        -2     1251       -30      UA  N464UA
## 4 2013     1  31     1448       105     1635       131      B6  N292JB
## 5 2013     1  31       NA       NaN       NA       NaN      US        
## 6 2013     1  31     1358        -7     1717        12      B6  N554JB
##   flight origin dest air_time distance hour minute
## 1    257    JFK  SFO      355     2586   14     24
## 2    951    JFK  ATL      129      760   18     53
## 3    499    EWR  SEA      324     2402    9     58
## 4     32    JFK  ROC       54      264   14     48
## 5   1625    LGA  CLT      NaN      544  NaN    NaN
## 6     63    JFK  TPA      164     1005   13     58
```

You can also sort by values that are transformed from columns.


```r
df %>% arrange(abs(dep_delay)) %>% head
```

```
##   year month day dep_time dep_delay arr_time arr_delay carrier tailnum
## 1 2013     2  18      605         0      844       -23      B6  N629JB
## 2 2013     8  22      640         0      935        11      UA  N36207
## 3 2013     3  13     1738         0     2002        -2      FL  N944AT
## 4 2013     3   5     1840         0     2142       -23      DL  N3772H
## 5 2013    10   4     1710         0     1821       -14      MQ  N724MQ
## 6 2013     2  19     2130         0     2255         0      B6  N228JB
##   flight origin dest air_time distance hour minute
## 1    501    JFK  FLL      138     1069    6      5
## 2   1162    EWR  TPA      138      997    6     40
## 3    806    LGA  ATL      113      762   17     38
## 4   1643    JFK  SEA      343     2422   18     40
## 5   3365    JFK  DCA       43      213   17     10
## 6    104    JFK  BUF       60      301   21     30
```

### 3-5. `summarize()`

`summarize()` is used to collapse a DataFrame to a single row.


```r
df %>% summarize(count = n(year)) %>% collect
```

```
##   count
## 1 10000
```

Typically, `summarize()` is used with `group_by()` to collapse each group to a single row.

As far as I know, you can use the following functions in `summarize()`.

- `n()`
- `n_distinct()`
- `approxCountDistinct()`
- `mean()`
- `first()`
- `last()`

It seems that other aggregate functions are available in Scala (See [docs](http://spark.apache.org/docs/1.4.0/api/scala/index.html#org.apache.spark.sql.functions$)).

Like dplyr, you can use `summarise()` instead of `simmarize()`.

### 3-6. `group_by()`

`group_by()` is used to describe how to break a DataFrame down into groups of rows.  
Usually it is used with `summarize()` to collapse each group to a single row.


```r
df %>% 
  group_by(tailnum) %>%
  summarize(mean_distance = mean(distance)) %>% 
  head
```

```
##   tailnum mean_distance
## 1  N600LR         695.0
## 2  N3HAAA        1075.0
## 3  N77518         642.5
## 4  N66051        1400.0
## 5  N5DCAA        1089.0
## 6  N947DL        1016.5
```

You can indicate multiple colmuns.


```r
df %>% 
  group_by(year, month, day) %>%
  summarize(count = n(year)) %>% 
  arrange(year, month, day) %>%
  head
```

```
##   year month day count
## 1 2013     1   1    25
## 2 2013     1   2    29
## 3 2013     1   3    24
## 4 2013     1   4    30
## 5 2013     1   5    16
## 6 2013     1   6    35
```

Unlike dplyr, only `summarize()` can receive the results of `group_by()`.

## 4. How to use

To install SparkR 1.4.0, the next articles may be useful.

- [How to use SparkR within Rstudio?](http://www.r-bloggers.com/how-to-use-sparkr-within-rstudio/)
- [SparkR with Rstudio in Ubuntu 12.04](http://www.r-bloggers.com/sparkr-with-rstudio-in-ubuntu-12-04/)

When you can load SparkR package, you will be also able to use SparkRext package.


```r
# Load SparkRext
library(SparkRext)
prior_package(SparkRext)

# Create Spark context and SQL context
sc <- sparkR.init(master="local")
sqlContext <- sparkRSQL.init(sc)

# Preparation of data
prior_package(dplyr)
library(nycflights13)

set.seed(123)
data <- sample_n(flights, 10000)

# Create DataFrame
prior_package(SparkRext)
df <- createDataFrame(sqlContext, data.frame(data))

# Play with DataFrame
result <- df %>%
  filter(month == 12, day == 31) %>%
  mutate(gain = arr_delay - dep_delay, 
         gain_per_hour = gain/(air_time/60)) %>%
  select(tailnum, distance, gain_per_hour) %>%
  group_by(tailnum) %>%
  summarize(count = n(tailnum), 
            mean_distance = mean(distance), 
            mean_gain_per_hour = mean(gain_per_hour)) %>%
  collect

print(result)
```


```
##    tailnum count mean_distance mean_gain_per_hour
## 1   N299PQ     1           301         -0.8571429
## 2   N903XJ     1          1391         -6.6666667
## 3   N15555     1           266        -21.8181818
## 4   N588JB     1           264         -8.8888889
## 5   N651JB     1          1608          1.5151515
## 6   N715JB     1           944          1.2162162
## 7   N138EV     1           269        -42.0000000
## 8   N37281     1          2565         -0.3183024
## 9   N17730     1          1634         -4.7524752
## 10  N630VA     1          2475          0.3314917
## 11  N501MQ     2           348         -4.7842402
## 12  N292JB     1           301         10.6451613
## 13  N630JB     1           944         -0.3870968
## 14  N403UA     1          1065         -8.4076433
## 15  N355JB     1           266          7.3469388
## 16  N911FJ     1           544        -10.4854369
## 17  N66808     1          2565          0.3287671
## 18  N374DA     1          2454          2.3268698
## 19  N295PQ     1           765         -0.4511278
## 20  N214FR     1          1620          6.9402985
## 21  N599JB     1          1076          7.8750000
## 22  N334JB     1           301          3.8095238
## 23  N834JB     1          2586         -0.3234501
## 24  N655MQ     1           425         -2.0454545
## 25  N216JB     1           209         -7.2000000
## 26  N17719     1          1023         -5.4901961
```

## 5. Caution points

### 5-1. `prior_package()`

SparkRext is sensitive to the order of loading of libraries.  
Thus, you should use `prior_package()` after `library()`.


```r
library(SparkRext)
prior_package(SparkRext)
```

By doing this, the functions of SparkRext will be called with the highest priority.  
You can confirm this by checking the search path:


```r
head(search())
```

```
## [1] ".GlobalEnv"           "package:SparkRext"    "package:SparkR"      
## [4] "package:nycflights13" "package:dplyr"        "package:stats"
```

If you want to switch to SparkR, you can do it.


```r
prior_package(SparkR)
head(search())
```

```
## [1] ".GlobalEnv"           "package:SparkR"       "package:SparkRext"   
## [4] "package:nycflights13" "package:dplyr"        "package:stats"
```

You can also switch to dplyr.


```r
prior_package(dplyr)
head(search())
```

```
## [1] ".GlobalEnv"           "package:dplyr"        "package:SparkR"      
## [4] "package:SparkRext"    "package:nycflights13" "package:stats"
```

### 5-2. Pipe operator `%>%`

You can use pipe operator `%>%` without loading magrittr or dplyr.  
The pipe operator imports from **pipeR** package. (See [pipeR](http://renkun.me/pipeR/))

The reason of it is that the pipe operator of pipeR is faster than magrittr.  
I will show that below.




```r
library(dplyr)
library(pipeR)
library(microbenchmark)

dplyr_pipe <- function() {
  iris %>%
    select(Sepal.Length, Species) %>%
    filter(Sepal.Length >= 5.5) %>%
    group_by(Species) %>%
    summarize(count = n(), mean = mean(Sepal.Length))
}

pipeR_pipe <- function() {
  iris %>>%
    select(Sepal.Length, Species) %>>%
    filter(Sepal.Length >= 5.5) %>>%
    group_by(Species) %>>%
    summarize(count = n(), mean = mean(Sepal.Length))
}

microbenchmark(
  dplyr_pipe(),
  pipeR_pipe()
)
```

```
## Unit: milliseconds
##          expr      min       lq     mean   median       uq      max neval
##  dplyr_pipe() 2.120685 2.282281 2.438163 2.356234 2.458864 3.841641   100
##  pipeR_pipe() 1.913292 2.049066 2.195556 2.120944 2.196404 3.722005   100
```
