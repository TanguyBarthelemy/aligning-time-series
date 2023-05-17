
ev <- function(x) {
    (x - dplyr::lag(x)) / dplyr::lag(x)
}

add_months <- function(date, n) seq(date, by = paste(n, "months"), length = 2)[2]

diff_month <- function(date1, date2) {
    return(
        12 * (as.numeric(format(date2, format = "%Y")) - 
                  as.numeric(format(date1, format = "%Y"))) + 
            as.numeric(format(date2, format = "%m")) - 
            as.numeric(format(date1, format = "%m"))
    )
}


