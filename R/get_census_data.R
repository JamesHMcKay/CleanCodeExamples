download_data <- function() {
  dir.create(file.path(".", "data"), showWarnings = FALSE)
  download.file(
    paste0(
      "https://www.stats.govt.nz/assets/Uploads/2018-Census-totals-by-topic/",
      "Download-data/2018-census-totals-by-topic-national-highlights-csv.zip"
    ),
    "./data/file.zip"
  )
  unzip("./data/file.zip", exdir = "./data")
}

load_data <- function(filename, col_names) {
  data <- read.csv(
    filename,
    stringsAsFactors = FALSE,
    col.names = col_names
  )
  return(data)
}

load_occupation_data <- function() {
  occupation_data <- load_data(
    "data/occupation-2018-census-csv.csv",
    col_names = c("code", "occupation", "count")
  )
}

find_most_common_occuptation <- function(occupation_data) {
  index <- which(occupation_data$count == max(occupation_data$count))
  return(occupation_data[index, ])
}
