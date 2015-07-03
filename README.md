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

I have created **SparkRext** package to use NSE version of the functions in SparkR.


```
## Error in eval(expr, envir, enclos): could not find function "prior_package"
```


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
