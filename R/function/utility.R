
ev <- function(x) {
    (x - dplyr::lag(x)) / dplyr::lag(x)
}

add_months <- function(date, n) seq(date, by = paste(n, "months"), length = 2L)[2L]

diff_month <- function(date1, date2) {
    return(
        12L * (as.numeric(format(date2, format = "%Y")) - 
                  as.numeric(format(date1, format = "%Y"))) + 
            as.numeric(format(date2, format = "%m")) - 
            as.numeric(format(date1, format = "%m")) + 1L
    )
}

date2date_ts <- function(date) {
    return(c(as.numeric(format(date, format = "%Y")), 
             as.numeric(format(date, format = "%m"))))
}

date_ts2date <- function(date_ts) {
    year <- date_ts[1]
    month <- "01"
    if (length(date_ts) == 2) {
        month <- sprintf("%02d", date_ts[2])
    }
    return(as.Date(paste(year, month, "01", sep = "-")))
}

