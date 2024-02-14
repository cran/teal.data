## ----setup, include = FALSE, echo = FALSE-------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(reticulate) # may need to be installed if not available
# reticulate function to call to install the pandas package if not installed: py_install("pandas")
library(teal.data)

## -----------------------------------------------------------------------------
python_code <- "import pandas as pd
data = pd.DataFrame({\"id\" : range(r.num_rows), \"val\" : range(r.num_rows)})"

## -----------------------------------------------------------------------------
x <- python_dataset_connector(
  dataname = "DATA", # the teal dataset name
  code = python_code, # the code used to generate the dataset
  object = "data", # the object in the python code to be converted to a data.frame for the teal dataset
  keys = "id", # the key for teal dataset object
  vars = list(num_rows = 5L) # any variables passed from R into python (note this could be an R variable)
)

## ----eval = FALSE-------------------------------------------------------------
#  x$pull()
#  print(x)

