<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Build Status](https://travis-ci.org/ReportMort/rdfp.svg?branch=master)](https://travis-ci.org/ReportMort/rdfp) [![codecov.io](https://codecov.io/github/ReportMort/rdfp/coverage.svg?branch=master)](https://codecov.io/github/ReportMort/rdfp?branch=master)

------------------------------------------------------------------------

Double Click for Publishers API from R
--------------------------------------

Features:

-   Basic CRUD operations on DFP objects (Create, Read, Update, Delete)
-   Forecast
-   Report
-   Simple Administrative Tools

`rdfp` is the R implementation of Double Click for Publishers and similar in comparison to the existing client libraries supported by Google (<https://developers.google.com/doubleclick-publishers/docs/clients>). One main difference is that the client libraries directly reference the production WSDLs to interact with the API, but this package makes SOAP requests best formatted to match the WSDL standards. This articulation is not perfect and continued progress will be made to bring functionality up to par with the client libraries.

### Function naming convention

All functions start with `dfp_` to aid the user's ability to find DFP-specific operations when using code completion in RStudio.

### Install and Load rdfp

``` r

devtools::install_github("ReportMort/rdfp")
library("rdfp")
```

### Configure Authentication

First, you will need to specify a list of options in order to connect to the API. The client\_id and client\_secret must be created in via the [Google Developers Console] (<https://console.developers.google.com>), which allows R to access the API as an "application" on your behalf, whether or not you are running your R script interactively.

``` r

options(rdfp.network_code = "12345678")
options(rdfp.application_name = "MyApp")
options(rdfp.client_id = "012345678901-99thisisatest99.apps.googleusercontent.com")
options(rdfp.client_secret = "Th1s1sMyC1ientS3cr3t")
```

### Check Some Current Settings

By default most `rdfp` functions, or operations, will return a list simply parsed from the XML returned in the SOAP response. Some functions may take additional steps to format the results as data.frame or vector and this will be noted in the function documentation.

``` r

user_info <- dfp_getCurrentUser()
user_info

network_info <- dfp_getCurrentNetwork()
network_info
```

### Get Line Items By A Filter

Below is an example of how to get objects by Publishers Query Language (PQL) statement. The statement is constructed as a list of lists that are nested to emulate the hierarchy of the XML to be created. The example uses the `dfp_getLineItemsByStatement` function from the [LineItemService] (<https://developers.google.com/doubleclick-publishers/docs/reference/v201508/LineItemService>)

``` r

# Retrieve all Line Items that have a status of "DELIVERING"
dat <- list('filterStatement'=list('query'="WHERE status='DELIVERING'"))

resultset <- dfp_getLineItemsByStatement(dat)

# the result is a list
# Google uses the first two elements for metadata
head(resultset, 2)

# the rest should be parsed as needed
tail(resultset, -2)
```

### More Examples To Be Added Soon

### Credits

This application uses other open source software components. The authentication components are mostly verbatim copies of the routines established in the **googlesheets** package (<https://github.com/jennybc/googlesheets>). We acknowledge and are grateful to these developers for their contributions to open source.

### License

The **rdfp** package is licensed under the MIT License (<http://choosealicense.com/licenses/mit/>).

-   COPYING - rdfp package license (MIT)
-   NOTICE - Copyright notices for additional included software