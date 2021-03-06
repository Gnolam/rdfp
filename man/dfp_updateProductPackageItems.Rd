% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ProductPackageItemService.R
\name{dfp_updateProductPackageItems}
\alias{dfp_updateProductPackageItems}
\title{updateProductPackageItems}
\usage{
dfp_updateProductPackageItems(request_data, as_df = TRUE, verbose = FALSE)
}
\arguments{
\item{request_data}{a \code{list} or \code{data.frame} of data elements
to be formatted for a SOAP
request (XML format, but passed as character string)}

\item{as_df}{a boolean indicating whether to attempt to parse the result into
a \code{data.frame}}

\item{verbose}{a boolean indicating whether to print the service URL and POSTed XML}
}
\value{
a \code{data.frame} or \code{list} containing all the elements of a updateProductPackageItemsResponse
}
\description{
Updates the specified ProductPackageItem objects.
}
\seealso{
\href{https://developers.google.com/doubleclick-publishers/docs/reference/v201702/ProductPackageItemService#updateProductPackageItems}{Google Documentation for updateProductPackageItems}
}

