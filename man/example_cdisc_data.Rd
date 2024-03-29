% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dummy_function.R
\name{example_cdisc_data}
\alias{example_cdisc_data}
\title{Generate sample CDISC datasets}
\usage{
example_cdisc_data(
  dataname = c("ADSL", "ADAE", "ADLB", "ADCM", "ADEX", "ADRS", "ADTR", "ADTTE", "ADVS")
)
}
\arguments{
\item{dataname}{(\code{character(1)}) name of a CDISC dataset}
}
\value{
A CDISC dataset as a \code{data.frame}.
}
\description{
Retrieves example CDISC datasets for use in examples and testing.
}
\details{
This function returns a dummy dataset and should only be used within \code{teal.data}.
Note that the datasets are not created and maintained in \code{teal.data}, they are retrieved its dependencies.
}
