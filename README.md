
<!-- README.md is generated from README.Rmd. Please edit that file -->
RTransferEntropy
================

The goal of RTransferEntropy is to implement transfer entropy for the Shannon and the Renyi-methodology.

Installation
------------

You can install RTransferEntropy from github with:

``` r
# install.packages("devtools")
devtools::install_github("BZPaper/Transfer-Entropy")
```

Example using simulated data
----------------------------

Simulate a simple model to obtain two time series that are not independent (see simulation study in Dimpfl and Peter (2013)), i.e. one time series is lag of the other plus noise. In this case, one expects significant information flow from x to y and none from y to x.

### Simulating a Time-Series

``` r
library(RTransferEntropy)
set.seed(20180108)
n <- 100000
x <- rep(0, n + 1)
y <- rep(0, n + 1)

for (i in seq(n)) {
  x[i + 1] <- 0.2 * x[i] + rnorm(1, 0, 2)
  y[i + 1] <- x[i] + rnorm(1, 0, 2)
}

x <- x[-1]
y <- y[-1]
```

### Visualisation

``` r
library(data.table)
library(ggplot2)
library(latex2exp)
theme_set(theme_light())

df <- rbindlist(list(
  data.table(x, y, grp = "Contemporaneous Effect"),
  data.table(shift(x, 1), y, grp = "Time-Delayed Effect")
))

ggplot(df, aes(x = x, y = y, color = grp)) + 
  geom_point(alpha = 0.1) +
  geom_smooth() +
  facet_wrap(~grp) +
  labs(x = TeX("Left: x_t Right: x_{t-1}"), y = TeX("y_t"), 
       title = "Scatterplot of the Time-Series") +
  scale_color_brewer(palette = "Set1", guide = F)
#> `geom_smooth()` using method = 'gam'
#> Warning: Removed 1 rows containing non-finite values (stat_smooth).
#> Warning: Removed 1 rows containing missing values (geom_point).
```

![](README-contemp_plot-1.png)

### Shannon Transfer Entropy

``` r
set.seed(20180108 + 1)
n_cores <- parallel::detectCores() - 1

shannon_te <- transfer_entropy(x = x,
                               y = y,
                               lx = 1,
                               ly = 1,
                               nboot = n_cores,
                               cl = n_cores)
#> Calculating Shannon's entropy on 7 cores with 6 shuffle(s) and 7 bootstrap(s)
#> The timeseries have length 100000 (0 NAs removed)
#> Calculate the X->Y transfer entropy
#> Calculate the Y->X transfer entropy
#> Bootstrap the transfer entropies
#> Done - Total time 13.91 seconds

shannon_te
#> Shannon Transfer Entropy Results:
#> -----------------------------------------------------------------
#>  Direction          TE     Eff. TE    Std.Err.     p-value    sig
#> -----------------------------------------------------------------
#>       X->Y      0.0969      0.0968      0.0000      0.0000    ***
#>       Y->X      0.0001      0.0000      0.0000      1.0000       
#> -----------------------------------------------------------------
#> Bootstrapped TE Quantiles (7 replications):
#> -----------------------------------------------------------------
#> Direction        0%       25%       50%       75%      100%
#> -----------------------------------------------------------------
#>     X->Y    0.0001    0.0001    0.0001    0.0001    0.0001
#>     Y->X    0.0001    0.0001    0.0001    0.0001    0.0001
#> -----------------------------------------------------------------
#> Number of Observations: 100000
#> -----------------------------------------------------------------
#> p-values: < 0.001 ‘***’, < 0.01 ‘**’, < 0.05 ‘*’, < 0.1 ‘.’
```

### Renyi Transfer Entropy

``` r
set.seed(20180108 + 1)
n_cores <- parallel::detectCores() - 1

renyi_te <- transfer_entropy(x = x,
                             y = y,
                             lx = 1,
                             ly = 1,
                             entropy = "renyi",
                             q = 0.5,
                             nboot = n_cores,
                             cl = n_cores)
#> Calculating Renyi's entropy on 7 cores with 6 shuffle(s) and 7 bootstrap(s)
#> The timeseries have length 100000 (0 NAs removed)
#> Calculate the X->Y transfer entropy
#> Calculate the Y->X transfer entropy
#> Bootstrap the transfer entropies
#> Done - Total time 13.57 seconds

renyi_te
#> Renyi Transfer Entropy Results:
#> -----------------------------------------------------------------
#>  Direction          TE     Eff. TE    Std.Err.     p-value    sig
#> -----------------------------------------------------------------
#>       X->Y      0.0861      0.0836      0.0010      0.0000    ***
#>       Y->X      0.0003      0.0000      0.0007      1.0000       
#> -----------------------------------------------------------------
#> Bootstrapped TE Quantiles (7 replications):
#> -----------------------------------------------------------------
#> Direction        0%       25%       50%       75%      100%
#> -----------------------------------------------------------------
#>     X->Y    0.0004    0.0013    0.0016    0.0020    0.0024
#>     Y->X   -0.0013   -0.0000    0.0005    0.0010    0.0020
#> -----------------------------------------------------------------
#> Number of Observations: 100000
#> Q: 0.5
#> -----------------------------------------------------------------
#> p-values: < 0.001 ‘***’, < 0.01 ‘**’, < 0.05 ‘*’, < 0.1 ‘.’
```
