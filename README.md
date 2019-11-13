
<!-- README.md is generated from README.Rmd. Please edit that file -->
overwatchr
==========

<!-- badges: start -->
<!-- badges: end -->
The goal of overwatchr is to provide a framework for collecting and analyzing game statistics about public Overwatch accounts. The package relies on [OWAPI](https://github.com/Fuyukai/OWAPI) to collect information from play.overwatch.com. It is not suitable for high-frequency querying, but aims to provide tools for users to analyze their long-term progression as Overwatch players. Currently, overwatchr only collects statistics from competitive gameplay.

The package consists of two main functions. The first function (scrape\_ow\_data) queries OWAPI for a specific profile and saves the data in a dedicated folder as multiple CSV files, one for each hero. This file structure supports multiple queries over time, which are appended to any existing CSV files, and can store data about multiple accounts. The second function (load\_ow\_data) loads this data into an R session for analysis. It also automatically transforms the raw information collected and stored by scrape\_ow\_data into more usable data by isolating gameplay between each OWAPI query, and by calculating stats per 10 minutes for each of these "sessions".

Installation
------------

You can install overwatchr from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("benbellman/overwatchr")
```

Usage
-----

The first step to using the package is to attach it in your R session:

``` r
library(overwatchr)
```

Next, a user needs to start collecting data. I suggest running a query at least half an hour after each session of competitive play, as Overwatch's website does not seem to update profile stats very quickly. This is simple to do with scrape\_ow\_data. All you need to specify is the account name, the gaming platform, and the file path to store collected data.

``` r
# create an empty folder to store all future overwatch data
# this function is from base R, not this package
dir.create("~/Desktop/ow_data")

# save new data query
# future queries will be appended to same files automatically
scrape_ow_data(
  profile_name = "catmaps", 
  platform = "psn", 
  file_path = "~/Desktop/ow_data"
)
```

When loading data from this folder, load\_ow\_data() must pull data for a single hero, for a single account, and for a single season in order for data transformation to be reliable and accurate.

``` r
load_ow_data(
  profile_name = "catmaps", 
  hero_table = "moira", 
  season_choice = 19, 
  file_path = "~/Desktop/ow_data"
)
```
