
ev <- function(x) {
    (x - dplyr::lag(x)) / dplyr::lag(x)
}

add_months <- function(date, n) seq(date, by = paste(n, "months"), length = 2)[2]
