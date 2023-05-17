
get_score <- function(date, id_serie) {
    
    data2plot <- cbind(
        old = old_cvs[, id_serie], 
        new = new_cvs[, id_serie], 
        # raw = brutes[, id_serie]
    ) |> window(start = start2_ts, end = end2_ts)
    
}
