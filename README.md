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

