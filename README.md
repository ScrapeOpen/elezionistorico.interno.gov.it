# elezionistorico.interno.gov.it

Scraper for Historical archive of Italian elections published by the Italy's Ministry of Interior. The dataset is stored on [Dataverse](https://doi.org/10.7910/DVN/QXUVIG). To cite:

```
@data{QXUVIG_2018,
author = {Bailo, Francesco},
publisher = {Harvard Dataverse},
title = {Historical Archive of Elections | elezionistorico.interno.gov.it},
year = {2018},
doi = {10.7910/DVN/QXUVIG},
url = {https://doi.org/10.7910/DVN/QXUVIG}
}
```

# Source

[elezionistorico.interno.gov.it](http://elezionistorico.interno.gov.it/index.php?tpel=C&dtel=04/03/2018) is the web archive curated by Italy's Ministry of Interiors. It render Italian election and referendum results hold since 1946 at different level of granularity. 

# Code

The currently available scraping scripts are:
* `scrape_19460602_F.py`
* `scrape_19480418-19920405.py`
* `scrape_20060409.py`
* `scrape_20161204_F.py`
* `scrape_20180304.py`

They can be easily applied to scrape different elections but they must be edited and tested. 


# Data
* [Italian institutional referendum 2 June 1946](open_details_19460602_F.md)
* [Italian general elections 1948-1992 (Chamber of Deputy and Senate of the Republic)](open_details_19480418-19920405.md)
* [General election 9 March 2006 (Chamber of Deputy and Senate of the Republic)](open_details_20060409.md)
* [Italian constitutional referendum 4 December 2016](open_details_20161204_F.md)
* [General elections 4 March 2018 (Chamber of Deputy and Senate of the Republic)](open_details_20180304.md)


