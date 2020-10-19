condition_equal <- function(operator, value) {
  structure(operator, class = "condition_equal")
}

condition_range <- function(operator, value) {
  structure(operator, class = "condition_range")
}

get_operator <- function(obj) {
  UseMethod("get_operator")
}

get_operator.default <- function(obj) {
  print("default")
}

get_operator.condition_equal <- function(obj) {
  return("equal")
}

get_operator.condition_range <- function(obj) {
  return("range")
}

