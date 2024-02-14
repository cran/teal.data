## ----setup, include = FALSE, echo=FALSE---------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(teal.data)
library(scda)

# initialize object
fun <- callable_function(fun = synthetic_cdisc_dataset)

# set arguments to function
fun$set_args(list(dataset_name = "adsl", name = "latest"))

# execute function with arguments set
df <- fun$run()
head(df, 3)

# check reproducible code
cat(fun$get_call())

## -----------------------------------------------------------------------------

# initialize object
fun <- callable_function(fun = synthetic_cdisc_dataset)

# add arguments on the fly
df <- fun$run(args = list(dataset_name = "adae", name = "latest"))
head(df, 3)

# dynamic arguments not reflected in the call
cat(fun$get_call())

## -----------------------------------------------------------------------------
adsl_raw <- synthetic_cdisc_dataset(dataset_name = "adsl", name = "latest")

fun <- callable_function(fun = function(adsl) {
  adsl_2 <- adsl
  adsl_2$new_col <- TRUE
  adsl_2
})

# copy adsl to CallableFunction environment
fun$assign_to_env("adsl", adsl_raw)

# set arguments
fun$set_args(args = list(adsl = as.name("adsl")))

# execute function
df <- fun$run()
head(df, 3)

# get R code
fun$get_call()

## -----------------------------------------------------------------------------
code <- callable_code(
  "library(scda)
  ADTTE <- synthetic_cdisc_dataset(dataset_name = \"adtte\", name = \"latest\")
  ADTTE$x1 <- x1
  ADTTE <- dplyr::filter(ADTTE, PARAMCD %in% c('EFS', 'OS'))"
)

# examine call
cat(code$get_call())

# assign x1 to environment (otherwise code would run with error as x1 would not be defined)
code$assign_to_env("x1", 1)

# evaluate call
df <- code$run()
head(df$x1, 3)

## -----------------------------------------------------------------------------
library(magrittr)

adsl_raw <- synthetic_cdisc_dataset(dataset_name = "adsl", name = "latest") %>% head(3)

adsl_dataset <- cdisc_dataset(
  dataname = "ADSL",
  x = adsl_raw,
  code = "ADSL <- synthetic_cdisc_dataset(dataset_name = \"adsl\", name = \"latest\") %>% head(3)"
)

## -----------------------------------------------------------------------------
# check if code is reproducible
get_dataname(adsl_dataset)

# get label
get_dataset_label(adsl_dataset)

# get reproducible code
get_code(adsl_dataset)

# get data.frame
get_raw_data(adsl_dataset)

# get keys (i.e. the primary keys of the dataset)
adsl_dataset$get_keys()

## -----------------------------------------------------------------------------
adsl_conn <- dataset_connector(
  dataname = "ADSL",
  pull_callable = callable_function("synthetic_cdisc_dataset") %>%
    set_args(list(dataset_name = "adsl", name = "latest")),
  keys = get_cdisc_keys("ADSL"),
  label = "Subject-Level Analysis Dataset"
)

## -----------------------------------------------------------------------------
# get raw data
try(get_raw_data(adsl_conn))

## -----------------------------------------------------------------------------
# execution/reproducible code
get_code(adsl_conn)

# pull data
load_dataset(adsl_conn)

# get raw data
get_raw_data(adsl_conn)

## -----------------------------------------------------------------------------
# here we use the general dataset_connector function which pulls an object of type TealDataset
# there is also a cdisc_dataset_connector function which pulls an object of type CDISCTealDataset
adsl_2 <- dataset_connector(
  dataname = "ADSL_2",
  pull_callable = callable_function(fun = function(ADSL) ADSL_2 <- ADSL) %>% # nolint
    set_args(list(ADSL = as.name("dummy_name"))),
  keys = get_cdisc_keys("ADSL"),
  label = "Example label",
  vars = list(dummy_name = adsl_raw)
)

load_dataset(adsl_2)

## -----------------------------------------------------------------------------
adsl_3 <- dataset_connector(
  dataname = "ADSL_3",
  pull_callable = callable_function(fun = function(ADSL, n) ADSL_3 <- head(ADSL, n)) %>% # nolint
    set_args(list(ADSL = as.name("ADSL"))),
  keys = get_cdisc_keys("ADSL"),
  label = "Example label",
  vars = list(ADSL = adsl_raw)
)

adsl_3$set_ui_input(function(ns) {
  list(
    numericInput(inputId = ns("n"), label = "Choose number of records", min = 0, value = 1)
  )
})

if (interactive()) {
  adsl_3$launch()
}

## -----------------------------------------------------------------------------
open_fun <- callable_function(data.frame) # define opening function
open_fun$set_args(list(x = 1:5)) # define fixed arguments to opening function

close_fun <- callable_function(sum) # define closing function
close_fun$set_args(list(x = 1:5)) # define fixed arguments to closing function

ping_fun <- callable_function(function() TRUE)

x <- data_connection(
  ping_fun = ping_fun, # define ping function
  open_fun = open_fun, # define opening function
  close_fun = close_fun # define closing function
)

## -----------------------------------------------------------------------------
# create TealDatasetConnectors
adsl <- dataset_connector(
  dataname = "ADSL",
  pull_callable = callable_function("synthetic_cdisc_dataset") %>%
    set_args(list(dataset_name = "adsl", name = "latest")),
  keys = get_cdisc_keys("ADSL"),
  label = "Subject-Level Analysis Dataset"
)

adsl_3 <- dataset_connector(
  dataname = "ADSL_3",
  pull_callable = callable_function(fun = function(ADSL, name, n = 5) { # nolint
    print(paste("slicing data from", name))
    ADSL_3 <- head(ADSL, n) # nolint
  }) %>%
    set_args(list(ADSL = as.name("ADSL"))),
  keys = get_cdisc_keys("ADSL"),
  label = "Example label",
  vars = list(ADSL = adsl)
)

adsl_3$set_ui_input(function(ns) {
  list(
    numericInput(inputId = ns("n"), label = "Choose number of records", min = 0, value = 1)
  )
})

connectors <- list(adsl, adsl_3)

# create connection
scda_open_fun <- callable_function(fun = library)
scda_open_fun$set_args(list(package = "scda"))
scda_conn <- teal.data:::TealDataConnection$new(open_fun = scda_open_fun) # nolint

# create TealDataConnector
data <- teal.data:::TealDataConnector$new(
  connection = scda_conn,
  connectors = connectors
)

## -----------------------------------------------------------------------------
cat(get_code(data))

# pull ADSL and ADSL_3
data$set_pull_args(args = list(name = "latest"))
data$pull()

## -----------------------------------------------------------------------------
data$set_ui(
  function(id, ...) {
    ns <- NS(id)
    tagList(
      scda_conn$get_open_ui(ns("open_connection")),
      textInput(ns("name"), p("Choose", code("name")), value = "latest"),
      do.call(
        what = "tagList",
        args = lapply(
          connectors,
          function(connector) {
            div(
              connector$get_ui(
                id = ns(connector$get_dataname())
              ),
              br()
            )
          }
        )
      )
    )
  }
)

data$set_server(
  function(id, connection, connectors) {
    moduleServer(
      id = id,
      module = function(input, output, session) {
        # opens connection
        if (!is.null(connection$get_open_server())) {
          connection$get_open_server()(
            id = "open_connection",
            connection = connection
          )
        }
        for (connector in connectors) {
          # set_args before to return them in the code (fixed args)
          set_args(connector, args = list(name = input$name))
          # pull each dataset
          connector$get_server()(id = connector$get_dataname())
          if (connector$is_failed()) {
            break
          }
        }
      }
    )
  }
)

## -----------------------------------------------------------------------------
if (interactive()) {
  data$launch()
}

## -----------------------------------------------------------------------------
data <- cdisc_data(
  cdisc_dataset(
    dataname = "ADSL",
    synthetic_cdisc_dataset(dataset_name = "adsl", name = "latest"),
    code = "ADSL <- synthetic_cdisc_dataset(dataset_name = \"adsl\", name = \"latest\")"
  ),
  cdisc_dataset(
    dataname = "ADTTE",
    synthetic_cdisc_dataset(dataset_name = "adtte", name = "latest"),
    code = "ADTTE <- synthetic_cdisc_dataset(dataset_name = \"adtte\", name = \"latest\")"
  )
)

## -----------------------------------------------------------------------------
adsl <- scda_cdisc_dataset_connector("ADSL", "adsl")
adae <- scda_cdisc_dataset_connector("ADAE", "adae")
advs <- scda_cdisc_dataset_connector("ADVS", "advs")
adtte <- scda_cdisc_dataset_connector("ADTTE", "adtte")

data <- cdisc_data(adsl, adae, advs, adtte)

## -----------------------------------------------------------------------------
if (interactive()) {
  data$launch()
}

## -----------------------------------------------------------------------------
get_code(data)
get_code(data, dataname = "ADSL")
get_code(data, dataname = "ADTTE")

## -----------------------------------------------------------------------------
# if you launched the shiny app and pressed the submit button above to load the data,
# then these 4 lines do not need to be run
adsl$pull()
adae$pull()
advs$pull()
adtte$pull()

## ----results=FALSE------------------------------------------------------------
# get loaded datasets
data$get_datasets()

# get single dataset
data$get_dataset(dataname = "ADSL")

# get data and dataset connectors
data$get_connectors()

# get all datasets/connectors
data$get_items()

## -----------------------------------------------------------------------------
adsl <- cdisc_dataset(
  dataname = "ADSL",
  synthetic_cdisc_dataset(dataset_name = "adsl", name = "latest"),
  code = "ADSL <- synthetic_cdisc_dataset(dataset_name = \"adsl\", name = \"latest\")"
) %>%
  mutate_dataset(code = "ADSL$x1 <- 1")


adtte <- scda_cdisc_dataset_connector(
  dataname = "ADTTE", "adtte"
) %>%
  mutate_dataset(code = "ADTTE$x2 <- 2")

## -----------------------------------------------------------------------------
cat(get_code(adsl))
cat(get_code(adtte))

## -----------------------------------------------------------------------------
data <- cdisc_data(adsl, adtte) %>%
  mutate_dataset(code = "ADSL$x3 <- 3", dataname = "ADSL")

# get reproducible code of all datasets
cat(get_code(data))

# get ADSL reproducible code
cat(get_code(data, dataname = "ADSL"))

## -----------------------------------------------------------------------------
data <- mutate_dataset(data, code = "ADTTE$x4 <- 4", dataname = "ADTTE") %>%
  mutate_dataset(code = "ADSL <- dplyr::filter(ADSL, SEX == 'F')", dataname = "ADSL")

cat(get_code(data, "ADSL"))
# note that the code for ADTTE below does not contain any mention of ADSL
cat(get_code(data, "ADTTE"))

## -----------------------------------------------------------------------------
data <- mutate_dataset(
  data,
  code = "ADTTE <- filter(ADTTE, USUBJID %in% ADSL$USUBJID)",
  dataname = "ADTTE",
  vars = list(ADSL = adsl) # vars = list(<DATANAME> = <dataset name>))
) %>%
  mutate_dataset("ADSL$var_created_after <- NA", dataname = "ADSL")

# note that the code that defines ADSL is now part of the code of ADTTE below
cat(get_code(data, dataname = "ADTTE"))

# moreover, note that the code inserted to the mutate_dataset after the pipe was not included.

## -----------------------------------------------------------------------------
data <- mutate_data(data,
  code = "
    ADSL$x3 <- 3
    proxy_var <- 4
    ADTTE$x4 <- proxy_var
  "
)

# single dataset code is not possible to obtain anymore
cat(adsl_code <- get_code(data, "ADSL"))
cat(adtte_code <- get_code(data, "ADTTE"))

# TRUE
as.character(adsl_code) == as.character(adtte_code)

## -----------------------------------------------------------------------------
adsl <- scda_cdisc_dataset_connector("ADSL", "adsl")
adrs <- scda_cdisc_dataset_connector("ADRS", "adrs")
x <- dataset("x", data.frame(x = 1, b = 2), code = "x <- data.frame(x = 1, b = 2)")

data <- teal_data(adsl, adrs, x)

shinyApp(
  ui = fluidPage(
    shinyjs::useShinyjs(),
    titlePanel("Delayed data loading"),
    sidebarLayout(
      sidebarPanel(data$get_ui("data"), uiOutput("dataset")),
      mainPanel(tableOutput("dist_plot"))
    )
  ),
  server = function(input, output, session) {
    data_reactive <- data$get_server()("data")
    observeEvent(data_reactive(), ignoreNULL = TRUE, {
      shinyjs::hide("data-delayed_data")
    })
    output$dataset <- renderUI({
      req(data_reactive())
      datanames <- names(get_raw_data(data_reactive()))
      radioButtons("dataname", "Select dataname", datanames, datanames[1])
    })
    output$dist_plot <- renderTable({
      req(input$dataname)
      dataset <- get_raw_data(data_reactive())[[input$dataname]]
      head(dataset)
    })
  }
)

