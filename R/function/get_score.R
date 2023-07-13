
# Calcule le score d'une série à une date précise
get_score <- function(date_ts, id_serie) {
    
    return(
        ((old_cvs[, id_serie] - new_cvs[, id_serie]) |> 
            window(start = date_ts, end = date_ts) |> 
            abs())[1]
    )
    
}

# Calcule le score de toutes les séries à une date précise
get_combined_scores <- function(date_ts, list_id_serie = serie_a_expertiser) {
    
    vapply(X = list_id_serie, 
           FUN = get_score, date_ts = date_ts, 
           FUN.VALUE = numeric(1)) |> 
        sum()
    
}

# Calcule le score combiné de toutes les séries à une date précise
get_all_score <- function(id_serie) {
    
    return(
        (old_cvs[, id_serie] - new_cvs[, id_serie]) |> 
             window(start = start2_ts, end = end2_ts) |> 
             abs()
    )
    
}

# Calcule les scores combinés de toutes les séries sur toute la période
get_all_combined_scores <- function(list_id_serie = serie_a_expertiser) {
    
    return(
        vapply(X = serie_a_expertiser, 
               FUN = get_all_score,  
               FUN.VALUE = numeric(diff_month(start2, end2))) |> rowSums() |> 
            ts(start = start2_ts, end = end2_ts, frequency = 12L)
    )
    
}

# Calcule la contribution d'une série à au score cumulé
get_contribution <- function(id_serie, list_id_serie = serie_a_expertiser) {
    
    score_serie <- get_all_score(id_serie)
    score_all_series <- get_all_combined_scores(list_id_serie)
    
    return((1 + score_serie) / (1 + score_all_series))
    
}

# Calcule toutes les contribution à au score cumulé
get_all_contribution <- function(list_id_serie = serie_a_expertiser) {
    
    combined_score <- get_all_combined_scores(list_id_serie)
    all_score <- vapply(X = serie_a_expertiser, 
                        FUN = get_all_score,  
                        FUN.VALUE = numeric(diff_month(start2, end2))) |> 
        ts(start = start2_ts, frequency = 12L)
    
    contributions <- all_score / combined_score
    colnames(contributions) <- colnames(all_score)
    
    return(
        contributions
    )
    
}

