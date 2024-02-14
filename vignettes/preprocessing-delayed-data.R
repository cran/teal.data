## -----------------------------------------------------------------------------
library(scda)
library(teal.data)
library(magrittr)

adsl_cf <- callable_function(function() synthetic_cdisc_data("latest")$adsl)
adsl <- cdisc_dataset_connector(
  dataname = "ADSL",
  pull_callable = adsl_cf,
  keys = get_cdisc_keys("ADSL")
) %>%
  mutate_dataset("ADSL$SEX <- as.factor(ADSL$SEX)")


adae_cf <- callable_function(function() synthetic_cdisc_data("latest")$adae)
adae <- cdisc_dataset_connector(
  dataname = "ADAE",
  pull_callable = adae_cf,
  keys = get_cdisc_keys("ADAE")
) %>%
  mutate_dataset("ADAE$X <- rep(ADSL$SEX[1])", vars = list(ADSL = adsl))

adsl$pull() %>%
  get_raw_data() %>%
  head(n = 3)
adae$pull() %>%
  get_raw_data() %>%
  head(n = 3)

## -----------------------------------------------------------------------------
cdisc_data(adsl, adae, check = TRUE) %>%
  mutate_data("ADAE$x <- ADSL$SUBJID[1]")

## -----------------------------------------------------------------------------
get_code(adsl)

pull_fun_adae <- callable_function(
  function() {
    synthetic_cdisc_data("latest")$adae
  }
)
adae <- dataset_connector(
  dataname = "ADAE",
  pull_callable = pull_fun_adae,
  keys = get_cdisc_keys("ADAE")
)

get_code(adae)

## -----------------------------------------------------------------------------
last_run <- Sys.Date() # constant value stored as a variable in the current session

adsl_cf <- callable_function(function() synthetic_cdisc_data("latest")$adsl)
adsl <- cdisc_dataset_connector(
  dataname = "ADSL",
  pull_callable = adsl_cf,
  keys = get_cdisc_keys("ADSL")
) %>%
  mutate_dataset("ADSL$last_run <- last_run", vars = list(last_run = last_run))

cat(get_code(adsl))

# compared to evaluating the variable at the time of loading
adsl_cf <- callable_function(function() synthetic_cdisc_data("latest")$adsl)
adsl <- cdisc_dataset_connector(
  dataname = "ADSL",
  pull_callable = adsl_cf,
  keys = get_cdisc_keys("ADSL")
) %>%
  mutate_dataset("last_run <- Sys.Date()\nADSL$last_run <- last_run")

adsl %>%
  get_code() %>%
  cat()

## -----------------------------------------------------------------------------
adsl <- synthetic_cdisc_data("latest")$adsl
adae_cf <- callable_function(function() synthetic_cdisc_data("latest")$adae)
adae <- cdisc_dataset_connector(
  dataname = "ADAE",
  pull_callable = adae_cf,
  keys = get_cdisc_keys("ADAE")
) %>%
  mutate_dataset("ADAE$n <- nrow(ADSL)")

cat(get_code(adae)) # the code returned by `adae` is not sufficient to reproduce `adae`

adsl_cf <- callable_function(function() synthetic_cdisc_data("latest")$adsl)
adsl <- cdisc_dataset_connector(
  dataname = "ADSL",
  pull_callable = adsl_cf,
  keys = get_cdisc_keys("ADSL")
)
adae_cf <- callable_function(function() synthetic_cdisc_data("latest")$adae)
adae <- cdisc_dataset_connector(
  dataname = "ADAE",
  pull_callable = adae_cf,
  keys = get_cdisc_keys("ADAE")
) %>%
  mutate_dataset("ADAE$n <- nrow(ADSL)", vars = list(ADSL = adsl))

cat(get_code(adae)) # this code can be run independently

## -----------------------------------------------------------------------------
adsl_adae <- cdisc_data(
  adsl,
  adae
) %>% mutate_data("ADAE$avg_age <- mean(ADAE$AGE)")

# the output for all 3 are the same
adsl_adae %>%
  get_code() %>%
  cat()

adsl_adae %>%
  get_code(dataname = "ADAE") %>%
  cat()

adsl_adae %>%
  get_code(dataname = "ADSL") %>%
  cat()

## -----------------------------------------------------------------------------
adsl_adae <- cdisc_data(
  adsl,
  adae %>% mutate_dataset("ADAE$avg_age <- mean(ADAE$AGE)")
)

adsl_adae %>%
  get_code() %>%
  cat()
adsl_adae %>%
  get_code("ADAE") %>%
  cat()
adsl_adae %>%
  get_code("ADSL") %>%
  cat()

## -----------------------------------------------------------------------------
adsl <- synthetic_cdisc_data("latest")$adsl
cdisc_dataset("ADSL", adsl) %>% get_code() # no reproducible code

# provide the code to reproduce the data:
cdisc_dataset("ADSL", adsl,
  code = "ADSL <- synthetic_cdisc_data(\"latest\")$adsl"
) %>%
  get_code()

# it's possible to supply the code at the `Data` level:
adae <- synthetic_cdisc_data("latest")$adae
adsl_adae <- cdisc_data(
  cdisc_dataset("ADSL", adsl),
  cdisc_dataset("ADAE", adae),
  code = "ADSL <- synthetic_cdisc_data(\"latest\")$adsl\nADAE <- synthetic_cdisc_data(\"latest\")$adae"
)

adsl_adae %>%
  get_code() %>%
  cat()

# but it's not possible then to access the code at a `Dataset` level:
adsl_adae %>%
  get_code("ADSL") %>%
  cat()

# this can be avoided by storing the code like so:
adsl_adae <- cdisc_data(
  cdisc_dataset("ADSL", adsl, code = "ADSL <- synthetic_cdisc_data(\"latest\")$adsl"),
  cdisc_dataset("ADAE", adae, code = "ADAE <- synthetic_cdisc_data(\"latest\")$adsl")
)

adsl_adae %>%
  get_code("ADSL") %>%
  cat()

