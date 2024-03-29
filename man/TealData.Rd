% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/deprecated.R
\name{TealData}
\alias{TealData}
\alias{as_cdisc}
\alias{callable_code}
\alias{callable_function}
\alias{code_dataset_connector}
\alias{code_cdisc_dataset_connector}
\alias{csv_dataset_connector}
\alias{csv_cdisc_dataset_connector}
\alias{python_code}
\alias{python_dataset_connector}
\alias{python_cdisc_dataset_connector}
\alias{cdisc_data_connector}
\alias{cdisc_dataset}
\alias{cdisc_dataset_connector}
\alias{cdisc_dataset_connector_file}
\alias{cdisc_dataset_file}
\alias{dataset}
\alias{dataset_connector}
\alias{dataset_connector_file}
\alias{dataset_file}
\alias{data_connection}
\alias{fun_dataset_connector}
\alias{fun_cdisc_dataset_connector}
\alias{relational_data_connector}
\alias{mae_dataset}
\alias{get_attrs}
\alias{get_dataset_label}
\alias{get_dataset}
\alias{get_datasets}
\alias{get_dataname}
\alias{get_key_duplicates}
\alias{get_keys}
\alias{get_raw_data}
\alias{is_pulled}
\alias{load_dataset}
\alias{load_datasets}
\alias{mutate_data}
\alias{mutate_dataset}
\alias{set_args}
\alias{rds_dataset_connector}
\alias{rds_cdisc_dataset_connector}
\alias{script_dataset_connector}
\alias{script_cdisc_dataset_connector}
\alias{set_keys}
\alias{read_script}
\alias{to_relational_data}
\alias{validate_metadata}
\alias{get_cdisc_keys}
\alias{cdisc_data_file}
\alias{teal_data_file}
\alias{get_join_keys}
\alias{get_join_keys<-}
\title{Deprecated \code{TealData} class and related functions}
\usage{
as_cdisc(...)

callable_code(...)

callable_function(...)

code_dataset_connector(...)

code_cdisc_dataset_connector(...)

csv_dataset_connector(...)

csv_cdisc_dataset_connector(...)

python_code(...)

python_dataset_connector(...)

python_cdisc_dataset_connector(...)

cdisc_data_connector(...)

cdisc_dataset(...)

cdisc_dataset_connector(...)

cdisc_dataset_connector_file(...)

cdisc_dataset_file(...)

dataset(...)

dataset_connector(...)

dataset_connector_file(...)

dataset_file(...)

data_connection(...)

fun_dataset_connector(...)

fun_cdisc_dataset_connector(...)

relational_data_connector(...)

mae_dataset(...)

get_attrs(...)

get_dataset_label(...)

get_dataset(...)

get_datasets(...)

get_dataname(...)

get_key_duplicates(...)

get_keys(...)

get_raw_data(...)

is_pulled(...)

load_dataset(...)

load_datasets(...)

mutate_data(...)

mutate_dataset(...)

set_args(...)

rds_dataset_connector(...)

rds_cdisc_dataset_connector(...)

script_dataset_connector(...)

script_cdisc_dataset_connector(...)

set_keys(...)

read_script(...)

to_relational_data(...)

validate_metadata(...)

get_cdisc_keys(...)

cdisc_data_file(...)

teal_data_file(...)

get_join_keys(...)

get_join_keys(...) <- value
}
\arguments{
\item{...}{any argument supported in \code{TealData} related functions.}

\item{value}{value to assign}
}
\value{
nothing
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}}

The \code{TealData} class and associated functions have been deprecated. Use \code{\link[=teal_data]{teal_data()}} instead.
See the \href{https://github.com/insightsengineering/teal/discussions/945}{Migration guide} for details.
}
\seealso{
\code{\link[=cdisc_data]{cdisc_data()}} , \code{\link[=join_keys]{join_keys()}}
}
