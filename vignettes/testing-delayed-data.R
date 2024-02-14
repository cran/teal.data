## -----------------------------------------------------------------------------
library(scda)
library(teal.data)

adsl_cf <- callable_function(function() synthetic_cdisc_data("latest")$adsl)
adsl <- cdisc_dataset_connector(
  dataname = "ADSL",
  pull_callable = adsl_cf,
  keys = get_cdisc_keys("ADSL")
)
get_dataname(adsl) # "ADSL"

adae_cf <- callable_function(function() synthetic_cdisc_data("latest")$adae)
adae <- cdisc_dataset_connector(
  dataname = "ADAE",
  pull_callable = adae_cf,
  keys = get_cdisc_keys("ADAE")
)
delayed_data <- cdisc_data(adsl, adae)
get_dataname(delayed_data) # "ADSL" "ADAE"

## -----------------------------------------------------------------------------
if (interactive()) {
  delayed_data$launch()
}

## -----------------------------------------------------------------------------
if (interactive()) {
  load_datasets(delayed_data)
}
is_pulled(delayed_data)

## -----------------------------------------------------------------------------
adae$set_ui_input(function(ns) {
  list(pickerInput("name", label = "Version of the dataset", choices = ls_synthetic_cdisc_data(), selected = "latest"))
})

## ----results=FALSE------------------------------------------------------------
lapply(delayed_data$get_items(), function(item) item$pull())

# return a particular dataset by name
get_dataset(delayed_data, dataname = "ADSL")

# or return all datasets
load_datasets(delayed_data)
get_datasets(delayed_data)

## -----------------------------------------------------------------------------

# "CDISCTealDatasetConnector" "TealDatasetConnector" "R6"
class(adsl)

# "CDISCTealDataset" "TealDataset" "R6"
class(get_dataset(adsl))

## -----------------------------------------------------------------------------
# for a single <...>Dataset<..> object
head(get_raw_data(adsl), 3)

# or for a <...>Data<...> object containing multiple datasets, specify the name of the dataset of interest
raw <- get_raw_data(delayed_data, "ADSL")
head(raw, 3)

# note the raw data is now just a regular R table
class(raw)

## -----------------------------------------------------------------------------
get_code(delayed_data)

## -----------------------------------------------------------------------------
library(teal.data)
library(scda)
library(magrittr)

adsl_cf <- callable_function(function() synthetic_cdisc_data("latest")$adsl)
cdisc_dataset_connector(
  dataname = "ADSL",
  pull_callable = adsl_cf,
  keys = get_cdisc_keys("ADSL")
) %>%
  mutate_dataset("ADSL$TRTDUR <- round(as.numeric(ADSL$TRTEDTM - ADSL$TRTSDTM), 1)") %>%
  load_dataset() %>%
  get_raw_data() %>%
  head(n = 3)

