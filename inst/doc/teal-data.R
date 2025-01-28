## ----results = 'hide', message = FALSE----------------------------------------
library(teal.data)

# create teal_data object
my_data <- teal_data()

# run code within teal_data to create data objects
my_data <- within(
  my_data,
  {
    data1 <- data.frame(id = 1:10, x = 11:20)
    data2 <- data.frame(id = 1:10, x = 21:30)
    data3 <- data.frame(id = 1:10, x = 31:40)
  }
)

# get objects stored in teal_data
my_data[["data1"]]
my_data[["data2"]]

# limit objects stored in teal_data
my_data[c("data1", "data3")]

# get reproducible code
get_code(my_data)

# get code just for specific object
get_code(my_data, names = "data2")

# get datanames
names(my_data)

# print
print(my_data)

## -----------------------------------------------------------------------------
my_data <- teal_data()
my_data <- within(my_data, data <- data.frame(x = 11:20))
my_data <- within(my_data, data$id <- seq_len(nrow(data)))
my_data # is verified

## -----------------------------------------------------------------------------
my_data <- teal_data()
my_data <- within(my_data, {
  data <- data.frame(id = 1:10, x = 11:20)
  child <- data.frame(id = 1:20, data_id = c(1:10, 1:10), y = 21:30)
})

join_keys(my_data) <- join_keys(
  join_key("data", "data", key = "id"),
  join_key("child", "child", key = "id"),
  join_key("child", "data", key = c("data_id" = "id"))
)

join_keys(my_data)

# join_keys for limited object
join_keys(my_data["child"])

## -----------------------------------------------------------------------------
my_data <- teal_data()
my_data <- within(my_data, {
  data <- data.frame(id = 1:10, x = 11:20)
  .data2 <- data.frame(id = 1:20, data_id = c(1:10, 1:10), y = 21:30)
})

ls(my_data)
names(my_data)

