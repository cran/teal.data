## ----message=FALSE, error=TRUE------------------------------------------------
library(teal.data)

data_empty <- teal_data()
data_empty # is verified
data_empty <- within(data_empty, i <- head(iris))
data_empty # remains verified

data_with_data <- teal_data(i = head(iris), code = "i <- head(iris)")
data_with_data # is unverified
data_with_data <- within(data_with_data, i$rand <- sample(nrow(i)))
data_with_data # remains unverified
cat(get_code(data_with_data)) # warning is prepended

## -----------------------------------------------------------------------------
library(teal.data)

data <- data.frame(x = 11:20)
data$id <- seq_len(nrow(data))

data_right <- teal_data(
  data = data,
  code = quote({
    data <- data.frame(x = 11:20)
    data$id <- seq_len(nrow(data))
  })
)
(data_right_verified <- verify(data_right)) # returns verified object

## -----------------------------------------------------------------------------
library(teal.data)

data <- within(teal_data(), {
  i <- iris
  m <- mtcars
  head(i)
})
cat(get_code(data)) # retrieve all code
cat(get_code(data, datanames = "i")) # retrieve code for `i`

