<!-- README.md is generated from README.Rmd. Please edit that file -->
rdfp
====

[![Build Status](https://travis-ci.org/ReportMort/rdfp.png?branch=master)](https://travis-ci.org/ReportMort/rdfp) [![Coverage Status](https://img.shields.io/codecov/c/github/ReportMort/rdfp/master.svg)](https://codecov.io/github/ReportMort/rdfp?branch=master)

**rdfp** is the R implementation of Double Click for Publishers and similar in comparison to the existing client libraries supported by Google (<https://developers.google.com/doubleclick-publishers/docs/clients>). One main difference is that the client libraries directly reference the production WSDLs to interact with the API, but this package makes SOAP requests best formatted to match the WSDL standards. This articulation is not perfect and continued progress will be made to bring functionality up to par with the client libraries. Currently, this package is leveraging the DFP API version: `v201702`. Most all operations supported by the DFP API are available via this package.

Features:

-   Basic CRUD operations on DFP objects (Create, Read, Update, Delete)
-   Forecasting/Inventory Management/Reporting
-   Simple Administrative Tools

### Vignettes

The README below outlines some basic functionality, for more practical scenarios, please refer to the vignettes:

-   [Availability and Reporting](https://rawgit.com/ReportMort/rdfp/master/vignettes/availability-and-reporting.html)

### Functions

All functions start with `dfp_` to aid the user's ability to find DFP-specific operations when using code completion in RStudio. By default most **rdfp** functions will return a `data.frame` or `list` parsed from the XML returned in the SOAP response.

### Install and Load rdfp Library

``` r

devtools::install_github("ReportMort/rdfp")
library("rdfp")
```

### Authenticate

First, you will need to specify the `network_code` of the DFP instance you'd like to connect to. This is the only required option that the user must specify when using the **rdfp** package. There are also other options like a client\_id and client\_secret which must be created via the \[Google Developers Console\] (<https://console.developers.google.com>), which allows R to access the API as an "application" on your behalf, whether or not you are running your R script interactively. After specifying the 4 options listed below, simply run `dfp_auth()` to authenticate.

``` r

options(rdfp.network_code = "12345678")
options(rdfp.application_name = "MyApp")
options(rdfp.client_id = "012345678901-99thisisatest99.apps.googleusercontent.com")
options(rdfp.client_secret = "Th1s1sMyC1ientS3cr3t")

# this function will use the options set above and 
# cache an OAuth token in the working directory
# the token will be refreshed when necessary
dfp_auth()
```

### Simple Administrative Tasks

### Check Current User Info

``` r

# Check current user or network
user_info <- dfp_getCurrentUser()
user_info
network_info <- dfp_getCurrentNetwork()
network_info
```

### Create Team and Users

``` r
# create a team and user and add the user to that team

#first create the team
request_data <- list(teams=list(name="TestTeam1", 
                                description='API Test Team 1', 
                                hasAllCompanies='true', 
                                hasAllInventory='true',
                                teamAccessType='READ_WRITE'))
dfp_createTeams_result <- dfp_createTeams(request_data)

# second create the user
request_data <- data.frame(name=paste0("TestUser", 1:3),
                           email=paste0('testuser', 1:3, '@gmail.com'), 
                           roleId=rep(-1,3))
dfp_createUsers_result <- dfp_createUsers(request_data)

# third associate the user to that team
request_data <- data.frame(teamid=rep(dfp_createTeams_result$id, 3),
                           userid=dfp_createUsers_result$id)
dfp_createUserTeamAssociations_result <- dfp_createUserTeamAssociations(request_data)

# Note: User roleId = -1 is the Administrative role
# use dfp_getAllRoles() to view other options

# Creating custom roles is a premium feature, which
# small business accounts won't have and creating the roles 
# can only be done from the user interface, not the API.
```

### Create Companies and Contacts

``` r
# create a company and add a contact to it

# first create the company
request_data <- list(companies=list(name="TestCompany1", 
                                    type='HOUSE_ADVERTISER', 
                                    address='123 Main St Hometown, FL USA', 
                                    email='testcompany1@gmail.com', 
                                    comment='API Test'))
dfp_createCompanies_result <- dfp_createCompanies(request_data)

# second create the contact and specify the companyId
request_data <- list(contacts=list(name="TestContact1", 
                                    companyId=dfp_createCompanies_result$id, 
                                    status='UNINVITED', 
                                    cellPhone='(888) 999-7777',
                                    comment='API Test', 
                                    email='testcontact1@gmail.com'))
dfp_createContacts_result <- dfp_createContacts(request_data)
```

Ad Trafficking Setup
--------------------

### Setup Custom Labels for Items

Custom labels are helpful for "tagging" DFP items with metadata that can later be used frequency capping, doing competitive exclusion or other specific actions. See the following link for Google's explanation on their uses: ([https://support.google.com/dfp\\\_premium/answer/190565?hl=en&ref\_topic=30224](https://support.google.com/dfp\_premium/answer/190565?hl=en&ref_topic=30224))

``` r

# this creates a label called "Last Minute Change" that we can add
# to any line item or order that we felt deserved this label.
request_data <- data.frame(name="auto - competitive exclusion", 
                           description=paste0("A label to prevent two different car ",
                                              "companies from showing ads together"), 
                           types='COMPETITIVE_EXCLUSION')
dfp_createLabels_result <- dfp_createLabels(request_data)
```

### Setup Custom Fields for Items

Custom fields are helpful for "tagging" DFP items with metadata that can later be used filtering or reporting. See the following link for Google's explanation on their uses: ([https://support.google.com/dfp\\\_premium/answer/2694303?hl=en](https://support.google.com/dfp\_premium/answer/2694303?hl=en))

``` r

# this creates an extra field on the USER entity type that denotes what shift 
# the user works during the day. First we create the field, then populate
# with potential options since it is a dropdown field.
request_data <- data.frame(name='Shift',
                           description='The shift that this user usually works.', 
                           entityType='USER',
                           dataType='DROP_DOWN',
                           visibility='FULL')
dfp_createCustomFields_result <- dfp_createCustomFields(request_data)

request_data <- data.frame(customFieldId=rep(dfp_createCustomFields_result$id, 3),
                           displayName=c('Morning', 'Afternoon', 'Evening'))
dfp_createCustomFieldOptions_result <- dfp_createCustomFieldOptions(request_data)
```

### Setup Custom Targeting Keys and Values

DFP allows traffickers to create custom tags to better target line items on their site. For example, a certain section of the site or search term used by a visitor can be encoded as custom targeting keys and values that can later be used when creating orders and line items, and evaluating potential inventory. See the following link for Google's explanation on their uses: ([https://support.google.com/dfp\\\_premium/answer/188092?hl=en](https://support.google.com/dfp\_premium/answer/188092?hl=en))

``` r

# create the key
request_data <- list(keys=list(name='Test1', 
                               displayName='TestKey1', 
                               type='FREEFORM'))
dfp_createCustomTargetingKeys_result <- dfp_createCustomTargetingKeys(request_data)

# create the values
request_data <- data.frame(customTargetingKeyId=rep(dfp_createCustomTargetingKeys_result$id,2),
                           name=c('TestValue1','TestValue2'), 
                           displayName=c('TestValue1','TestValue2'), 
                           matchType=rep('EXACT', 2))
dfp_createCustomTargetingValues_result <- dfp_createCustomTargetingValues(request_data)
```

### Find All Levels of Geotargeting and their Ids

Having a complete list of locations is useful for filtering and/or adding geotargeting on line items. Locations are ordered as a hierarchy and have unique ids.

``` r

request_data <- list(selectStatement=
                       list(query=paste('select Id, Name,', 
                                        'CanonicalParentId, CountryCode,',
                                        "Type from Geo_Target where CountryCode='US'")))

dfp_select_result <- dfp_select(request_data)$rval
final_result <- dfp_select_parse(dfp_select_result)
head(final_result)
```

### Create an Order

This example uses a test company as an advertiser and yourself as the trafficker, to create an order.

``` r

request_data <- list('filterStatement'=list('query'="WHERE name = 'TestCompany1'"))
dfp_getCompaniesByStatement_result <- dfp_getCompaniesByStatement(request_data) 

request_data <- list(list(name=paste0('TestOrder'), 
                          startDateTime=list(date=list(year=2017, month=12, day=1), 
                                             hour=0,
                                             minute=0,
                                             second=0,
                                             timeZoneID='America/New_York'),
                          endDateTime=list(date=list(year=2017, month=12, day=31), 
                                           hour=23,
                                           minute=59,
                                           second=59,
                                           timeZoneID='America/New_York'), 
                          notes='API Test Order', 
                          externalOrderId=99999, 
                          advertiserId=dfp_getCompaniesByStatement_result$id, 
                          traffickerId=dfp_getCurrentUser()$id))
dfp_createOrders_result <- dfp_createOrders(request_data)
```

### Get Line Items By A Filter

Below is an example of how to get objects by Publishers Query Language (PQL) statement. The statement is constructed as a list of lists that are nested to emulate the hierarchy of the XML to be created. The example uses the `dfp_getLineItemsByStatement` function from the \[LineItemService\] (<https://developers.google.com/doubleclick-publishers/docs/reference/v201702/LineItemService>)

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

Below is an example of how to make a simple report request.

``` r

# create a reportJob object
# reportJobs consist of a reportQuery
# Documentation for the reportQuery object can be found in R using 
# ?dfp_ReportService_object_factory and searching for ReportQuery
# Also online documentation is available that lists available child elements for reportQuery
# https://developers.google.com/doubleclick-publishers/docs/reference/v201702/ReportService.ReportQuery
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
```

### A More Detailed Explanation of the Report Process

Reports actually require 3 steps from the \[ReportService\] (<https://developers.google.com/doubleclick-publishers/docs/reference/v201702/ReportService>): 1) to request the report, 2) check on its status, and 3) download. This basic process flow is required for all reports requested via this service. The wrapper function used above named `dfp_full_report_wrapper` manages all aspects of reporting, so this level of detail is not needed unless the wrapper service does not quite fit your needs.

``` r

# create a reportJob object
# reportJobs consist of a reportQuery
# Documentation for the reportQuery object can be found in R using 
# ?dfp_ReportService_object_factory and searching for ReportQuery
# Also online documentation is available that lists available child elements for reportQuery
# https://developers.google.com/doubleclick-publishers/docs/reference/v201702/ReportService.ReportQuery
request_data <- list(reportJob=list(reportQuery=list(dimensions='MONTH_AND_YEAR', 
                                                     dimensions='AD_UNIT_ID',
                                                     adUnitView='FLAT',
                                                     columns='TOTAL_INVENTORY_LEVEL_IMPRESSIONS', 
                                                     startDate=list(year=2015, month=10, day=1),
                                                     endDate=list(year=2015, month=10, day=31),
                                                     dateRangeType='CUSTOM_DATE'
                                                     )))

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

### Credits

This application uses other open source software components. The authentication components are mostly verbatim copies of the routines established in the **googlesheets** package (<https://github.com/jennybc/googlesheets>). We acknowledge and are grateful to these developers for their contributions to open source.

### License

The **rdfp** package is licensed under the MIT License (<http://choosealicense.com/licenses/mit/>).

-   COPYING - rdfp package license (MIT)
-   NOTICE - Copyright notices for additional included software
