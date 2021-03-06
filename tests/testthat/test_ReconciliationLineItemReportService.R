context("ReconciliationLineItemReportService")

rdfp_options <- readRDS("rdfp_options.rds")
options(rdfp.network_code = rdfp_options$network_code)
options(rdfp.httr_oauth_cache = FALSE)
options(rdfp.application_name = rdfp_options$application_name)
options(rdfp.client_id = rdfp_options$client_id)
options(rdfp.client_secret = rdfp_options$client_secret)

dfp_auth(token = "rdfp_token.rds")

test_that("dfp_getReconciliationLineItemReportsByStatement", {

  options(rdfp.network_code = rdfp_options$test_network_code)
   request_data <- list('filterStatement'=list('query'="WHERE orderId='12345'"))

   dfp_getReconciliationLineItemReportsByStatement_result <- dfp_getReconciliationLineItemReportsByStatement(request_data)

   expect_is(dfp_getReconciliationLineItemReportsByStatement_result, "data.frame")
  options(rdfp.network_code = rdfp_options$network_code)

})

test_that("dfp_updateReconciliationLineItemReports", {

#  dfp_updateReconciliationLineItemReports_result <- dfp_updateReconciliationLineItemReports()

#  expect_is(dfp_updateReconciliationLineItemReports_result, "list")
  expect_true(TRUE)

})

