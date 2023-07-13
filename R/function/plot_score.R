
# plot_calendar
# heatmap
plot_score <- function(data_ts) {
    
    start_ts <- start(data_ts) |> date_ts2date()
    end_ts <- end(data_ts) |> date_ts2date()
    
    data_df <- data.frame(
        data_ts |> as.numeric(), 
        date = seq(from = start_ts, to = end_ts, by = "month")
    )
    data_df$year <- as.numeric(format(data_df$date, format = "%Y"))
    data_df$month <- as.numeric(format(data_df$date, format = "%m"))
    data_df$date <- NULL
    
    colnames(data_df) <- c("x", "year", "month")
    
    ggplot(data_df, aes(x = month, y = year, fill = x)) +
        geom_tile(color = "white",
                  lwd = 1.5,
                  linetype = 1) + 
        scale_y_reverse(breaks = data_df$year) + 
        scale_x_continuous(labels = function(x) month.abb[x], 
                           breaks = data_df$month) + 
        scale_fill_gradient(low="white", high="black") + 
        coord_fixed()
    
}

plot_contribution <- function(data_ts, nb = Inf) {
    
    data_vec <- data_ts |> colSums() |> sort(decreasing = TRUE)
    data_vec <- data_vec[seq_len(min(nb, length(data_vec)))]
    data_df <- as.data.frame(data_vec)
    data_df$name <- rownames(data_df)
    
    colnames(data_df) <- c("val", "name")
    
    # Basic piechart
    ggplot(data_df, aes(x = "", y = val, fill = name)) +
        geom_bar(stat = "identity", width = 1, color = "white") +
        coord_polar("y", start = 0) +
        
        theme_void() # remove background, grid, numeric labels
    
}

