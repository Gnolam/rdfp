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

### Run a Report

Below is an example of how to make a simple report request and format to `data.frame`. The example uses 3 functions from the [ReportService] (<https://developers.google.com/doubleclick-publishers/docs/reference/v201508/ReportService>) to request the report, check on its status, and download. This basic process flow is required for all reports requested via this service.

``` r

# create a reportJob object
# reportJobs consist of a reportQuery
# Documentation for the reportQuery object can be found in R using 
# ?dfp_ReportService_object_factory and searching for ReportQuery
# Also online documentation is available that lists available child elements for reportQuery
# https://developers.google.com/doubleclick-publishers/docs/reference/v201508/ReportService.ReportQuery
request_data <- list(reportJob=list(reportQuery=list(dimensions='MONTH_AND_YEAR', 
                                                     dimensions='AD_UNIT_ID',
                                                     adUnitView='FLAT',
                                                     columns='TOTAL_INVENTORY_LEVEL_IMPRESSIONS', 
                                                     startDate=list(year=2015, month=10, day=1),
                                                     endDate=list(year=2015, month=10, day=31),
                                                     dateRangeType='CUSTOM_DATE'
                                                     )))

# a convenience function has been provided to you to manage the report process workflow
# if you would like more control, see the example below which moves through each step in the process
report_data <- dfp_full_report_wrapper(request_data)

head(report_data)


# the result is a list and most importantly the ID is included for checking its status
dfp_runReportJob_result <- dfp_runReportJob(request_data)
dfp_runReportJob_result$id
dfp_runReportJob_result$reportJobStatus

# to check the status repeatedly you just need to provide the id
# dfp_getReportJobStatus_result returns a character string of the reportJob status
request_data <- list(reportJobId=dfp_runReportJob_result$id)
dfp_getReportJobStatus_result <- dfp_getReportJobStatus(request_data)
dfp_getReportJobStatus_result

# a simple while loop can keep checking a long running request until ready
counter <- 0
while(dfp_getReportJobStatus_result!='COMPLETED' & counter < 10){
  dfp_getReportJobStatus_result <- dfp_getReportJobStatus(request_data)
  Sys.sleep(3)
  counter <- counter + 1
}

# once the status is "COMPLETED" the data download URL can be retrieved
request_data <- list(reportJobId=dfp_runReportJob_result$id, exportFormat='CSV_DUMP')
dfp_getReportDownloadURL_result <- dfp_getReportDownloadURL(request_data)

# convenience function has been provided to download the data from URL
# and convert to a data.frame
# supported exportFormats are currently c('CSV_DUMP', 'TSV', 'CSV_EXCEL')
report_dat <- dfp_report_url_to_dataframe(report_url=dfp_getReportDownloadURL_result, 
                                          exportFormat='CSV_DUMP')
head(report_dat)
```

### More Examples To Be Added Soon

### Credits

This application uses other open source software components. The authentication components are mostly verbatim copies of the routines established in the **googlesheets** package (<https://github.com/jennybc/googlesheets>). We acknowledge and are grateful to these developers for their contributions to open source.

### License

The **rdfp** package is licensed under the MIT License (<http://choosealicense.com/licenses/mit/>).

-   COPYING - rdfp package license (MIT)
-   NOTICE - Copyright notices for additional included software
