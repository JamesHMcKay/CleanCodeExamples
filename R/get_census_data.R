download_data <- function() {
  dir.create(file.path(".", "data"), showWarnings = FALSE)
  download.file(
    paste0(
      "https://www.stats.govt.nz/assets/Uploads/2018-Census-totals-by-topic/",
      "Download-data/2018-census-totals-by-topic-national-highlights-csv.zip"
    ),
     "./data/file.zip"
  )
  #unz("./data/file.zip")
  unzip("./data/file.zip",exdir = "./data")
}


load_data <- function(filename, col_names) {
  data <- read.csv(
    filename,
    stringsAsFactors = F,
    col.names = col_names
  )
  return(data)
}

get_most_common_row_by_count <- function(occupation_data) {
  index <- which(occupation_data$count == max (occupation_data$count))
  return(occupation_data[index,])
}

get_most_common_occupation <- function () {
  occupation_data <- load_data("data/occupation-2018-census-csv.csv", col_names = c("code", "occupation", "count"))
  most_common_value <- get_most_common_row_by_count(occupation_data)
  return(most_common_value)
}

