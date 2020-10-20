load_years_at_usual_residence <- function() {
  data <- load_data("data/years-at-usual-residence-2018-census-csv.csv", col_names = c("code","years_at","count"))
  return(data)
}

convert_year_to_numbers <- function(data) {
  data <- data %>%
    mutate(
      year_at = as.numeric(gsub("years", "", years_at))
    )
  return (data)
}
