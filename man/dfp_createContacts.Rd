% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ContactService.R
\name{dfp_createContacts}
\alias{dfp_createContacts}
\title{ContactService}
\usage{
dfp_createContacts(request_data, as_df = TRUE, verbose = FALSE)
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
a \code{data.frame} or \code{list} containing all the elements of a createContactsResponse
}
\description{
Provides methods for creating, updating and retrieving Contact objects.
}
\details{
createContacts

Creates new Contact objects.
}
\seealso{
\href{https://developers.google.com/doubleclick-publishers/docs/reference/v201702/ContactService#createContacts}{Google Documentation for createContacts}
}

