
create_graph <- function(serie, eps = NULL) {
    
    data2plot <- cbind(
        old = old_cvs[, serie] |> window(end = c(2014, 12)), 
        new = new_cvs[, serie] |> window(start = 2012)#, 
        # raw = brutes[, serie]
    )
    
    find_raccord <- cbind(
        old = old_cvs[, serie] |> window(start = 2012, end = c(2014, 12)), 
        new = new_cvs[, serie] |> window(start = 2012, end = c(2014, 12))) |> 
        as.data.frame() |> 
        dplyr::mutate(
            date = seq.Date(from = start2, 
                            to = end2, by = "month"), 
            ev_old = ev(old), 
            ev_new = ev(new), 
            mm_sgn = sign(old) == sign(new), 
            mm_sgn_ev = sign(ev_old) == sign(ev_new), 
            diff = abs(new - old) * 100 / new, 
            diff_ev = abs(ev_new - ev_old) * 100
        ) |> 
        dplyr::select(date, old, ev_old, new, ev_new, 
                      mm_sgn, mm_sgn_ev, diff, diff_ev)
    
    graph <- dygraph(data2plot, main = paste("Comparaison cvs de la série", serie))
    found <- FALSE
    if (is.null(eps)) eps <- 0.0625
    
    while (!found) {
        
        condition <- find_raccord$diff < eps
        k <- 1
        compte <- 0
        
        while (k < 37) {
            if (condition[k] 
                && find_raccord$mm_sgn[k] 
                && (k == 1 || find_raccord$mm_sgn_ev[k])) {
                compte <- compte + 1
            } else if (compte > 2) {
                graph <- graph |> 
                    dyShading(from = add_months(start2, k - compte - 1), 
                              to = add_months(start2, k - 2), 
                              color = "#FFE6E6") |> 
                    dyAnnotation(add_months(start2, k - compte), 
                                 text = eps, width = 30, height = 30, attachAtBottom = TRUE)
                compte <- 0
                found <- TRUE
            } else {
                compte <- 0
            }
            k <- k + 1
        }
        
        if (eps >= .5) {
            eps <- eps + .5
        } else {
            eps <- eps * 2
        }
    }
    
    # print(paste0("eps final : ", eps - .5))
    # View(find_raccord)
    graph
}

create_graph2 <- function(serie, largeur_ma = NULL) {
    data2plot <- cbind(
        old = old_cvs[, serie] |> window(end = c(2014, 12)), 
        new = new_cvs[, serie] |> window(start = 2012)#, 
        # raw = brutes[, serie]
    )
    
    find_raccord <- cbind(
        old = old_cvs[, serie] |> window(start = 2012, end = c(2014, 12)), 
        new = new_cvs[, serie] |> window(start = 2012, end = c(2014, 12))) |> 
        as.data.frame() |> 
        dplyr::mutate(
            date = seq.Date(from = start2, 
                            to = end2, by = "month"), 
            ev_old = ev(old), 
            ev_new = ev(new), 
            mm_sgn = sign(old) == sign(new), 
            mm_sgn_ev = sign(ev_old) == sign(ev_new), 
            diff = abs(new - old) * 100 / new, 
            diff_ev = abs(ev_new - ev_old) * 100
        ) |> 
        dplyr::select(date, old, ev_old, new, ev_new, 
                      mm_sgn, mm_sgn_ev, diff, diff_ev)
    
    find_raccord[1, c("ev_new", "ev_old")] <- 0
    find_raccord[1, c("mm_sgn_ev")] <- TRUE
    
    if (is.null(largeur_ma)) largeur_ma <- 3
    record <- Inf
    k_record <- 0
    
    for (k in 1:(36 - largeur_ma + 1)) {
        
        inter <- k:(k + largeur_ma - 1)
        
        val <- ifelse(all(c(find_raccord$mm_sgn[inter], 
                            find_raccord$mm_sgn_ev[inter])), 0, Inf) + 
            sum((find_raccord$old[inter] - find_raccord$new[inter]) ** 2) + 
            sum((find_raccord$old_ev[inter] - find_raccord$new_ev[inter]) ** 2)
        
        if (val < record) {
            record <- val
            k_record <- k
        }
    }
    
    graph <- dygraph(data2plot, main = paste("Comparaison cvs de la série", serie)) |> 
        dyShading(from = add_months(start2, k_record), 
                  to = add_months(start2, k_record + largeur_ma - 1), 
                  color = "#FFE6E6") |> 
        dyAnnotation(add_months(start2, k_record + 1), 
                     text = record, width = 30, height = 30, attachAtBottom = TRUE)
    
    graph
}
