## -----------------------------------------------------------------------------
library(teal.data)
library(scda)

# specialized function to create delayed data using scda (could also set keys when using cdisc_dataset_connector)
adlb <- scda_dataset_connector(
  "ADLB",
  "adlb",
  keys = get_cdisc_keys("ADLB")
)

# generalized function to create delayed data from code - see package help for other connectors
x <- code_dataset_connector(
  dataname = "ADSL",
  keys = get_cdisc_keys("ADSL"),
  code = "library(scda)\nADSL <- synthetic_cdisc_data(\"latest\")$adsl"
)

## -----------------------------------------------------------------------------
# using scda
adsl <- scda_cdisc_dataset_connector(dataname = "ADSL", scda_dataname = "adsl")
adae <- scda_cdisc_dataset_connector(dataname = "ADAE", scda_dataname = "adae")
adsl_adae <- relational_data_connector(
  connection = data_connection(),
  connectors = list(adsl, adae)
)

## -----------------------------------------------------------------------------
# create a TealDatasetConnector for ADVS
advs <- scda_cdisc_dataset_connector(dataname = "ADVS", scda_dataname = "advs")
# use cdisc_data() to create a `DDL` object
delayed_data <- cdisc_data(adsl_adae, advs)

## -----------------------------------------------------------------------------
adsl <- scda_cdisc_dataset_connector(dataname = "ADSL", "adsl")
adsl_2 <- code_cdisc_dataset_connector("ADSL_2",
  code = "head(ADSL, 5)",
  keys = get_cdisc_keys("ADSL"), ADSL = adsl
)

# launch method will be able to load the data as adsl will be pulled first
cdisc_data(adsl, adsl_2)

# launch method will not be able to load the data as adae is pulled first but it depends on adsl
cdisc_data(adsl_2, adsl)

