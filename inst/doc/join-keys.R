## ----include=FALSE------------------------------------------------------------
# nolint start: commented_code_linter.

## ----results="hide", message=FALSE, tidy=FALSE--------------------------------
library(teal.data)
jk <- join_keys(
  join_key("ds1", keys = "col_1"), # ds1: [col_1]
  join_key("ds2", keys = c("col_1", "col_2")), # ds2: [col_1, col_2]
  join_key("ds3", keys = c("col_1", "col_3")), # ds3: [col_1, col_3]
  join_key("ds1", "ds2", keys = "col_1"), # ds1 <-- ds2
  join_key("ds1", "ds3", keys = "col_1"), # ds1 <-- ds3
  join_key("ds4", "ds5", keys = c("col_4" = "col_5"), directed = FALSE) # ds4 <--> ds5
)

# The parent-child relationships are created automatically (unless 'parent' parameter is "none")
jk

## ----include=FALSE------------------------------------------------------------
# nolint end: commented_code_linter.

## -----------------------------------------------------------------------------
# Using the jk object defined in "Anatomy of Join Keys"
jk

# Getting primary key of "ds1"
jk["ds1", "ds1"]

# Getting foreign keys between "ds4" and "ds5"
jk["ds4", "ds5"]

## -----------------------------------------------------------------------------
jk["ds5", "ds4"]
jk["ds5", "ds4"]

## -----------------------------------------------------------------------------
# Using the jk object defined in "Anatomy of Join Keys"
jk

# Getting primary key of "ds1"
jk["ds1", "ds1"]

# Getting keys of "ds1" and "ds2"
jk[c("ds1", "ds2")]

## -----------------------------------------------------------------------------
# Adding a new ds5 <-- ds1 key
jk["ds1", "ds5"] <- "a_column"

# Removing an existing key
jk["ds4", "ds5"] <- NULL

## -----------------------------------------------------------------------------
jk1 <- join_keys(join_key("ds1", "ds1", "col_1"))
jk2 <- join_keys(join_key("ds2", "ds2", "col_1"), join_key("ds1", "ds2", "col_1"))

# Merging
c(jk1, jk2)

# Keeping last occurence
c(jk1, jk2, join_keys(join_key("ds2", "ds2", "col_2"), join_key("ds1", "ds2", c("col_1" = "col_2"))))

# Merges join_key and join_key_set objects (from join_key function)
c(jk1, join_key("ds3", "ds3", "col_3"))

## ----include=FALSE------------------------------------------------------------
# nolint start: commented_code_linter.

## ----message=FALSE------------------------------------------------------------
library(teal.data)

td_pk <- within(
  teal_data(),
  ds1 <- transform(iris, id = seq_len(nrow(iris)))
)

join_keys(td_pk) <- join_keys(join_key("ds1", keys = "id"))

join_keys(td_pk)

## ----message=FALSE------------------------------------------------------------
td_pk <- within(
  td_pk,
  {
    ds2 <- data.frame(W = 10:1, V = 5:14, M = rep(1:5, 2))
    ds3 <- data.frame(V = 5:14, N = 4)
  }
)

join_keys(td_pk)["ds2", "ds2"] <- c("V", "W")
join_keys(td_pk)["ds3", "ds3"] <- c("V", "W")

join_keys(td_pk)

## ----include=FALSE------------------------------------------------------------
# nolint end: commented_code_linter.

## -----------------------------------------------------------------------------
library(teal.data)

td_fk <- within(
  teal_data(),
  {
    ds1 <- data.frame(X = 1:10, Y = 21:30, Z = 1:10)
    ds2 <- data.frame(W = 10:1, V = 5:14, M = rep(1:5, 2))
    ds3 <- data.frame(V = 5:14, N = 4)
  }
)

join_keys(td_fk) <- join_keys(
  # Primary keys
  join_key("ds1", keys = c("X")),
  join_key("ds2", keys = c("V", "W")),
  join_key("ds3", keys = c("V")),
  # Foreign keys
  join_key("ds1", "ds2", c("X" = "W")),
  join_key("ds2", "ds3", c("V" = "V"))
)

join_keys(td_fk)

## -----------------------------------------------------------------------------
library(teal.data)

td <- within(
  teal_data(),
  {
    ds1 <- data.frame(X = 1:10, Y = 21:30, Z = 1:10)
    ds2 <- data.frame(W = 10:1, V = 5:14, M = rep(1:5, 2))
    ds3 <- data.frame(V = 5:14, N = 4)
    ds4 <- data.frame(V = 5:14, R = rnorm(10))
  }
)

join_keys(td) <- join_keys(
  # Primary keys
  join_key("ds1", keys = c("X")),
  join_key("ds2", keys = c("V", "W")),
  join_key("ds3", keys = c("V")),
  join_key("ds4", keys = c("V")),
  # Foreign keys
  join_key("ds1", "ds2", c("X" = "W")),
  join_key("ds2", "ds3", c("V" = "V")),
  join_key("ds1", "ds4", c("X" = "B"))
)

join_keys(td)

join_keys(td)["ds2", "ds4"]

## -----------------------------------------------------------------------------
names(default_cdisc_join_keys) |> sort()

## -----------------------------------------------------------------------------
default_cdisc_join_keys

default_cdisc_join_keys["ADSL"]

default_cdisc_join_keys["ADTTE"]

default_cdisc_join_keys[c("ADSL", "ADTTE", "ADRS")]

