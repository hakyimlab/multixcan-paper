
qq_unif_plot_data_ <- function(data, threshold=30, label=NULL) {
  if("pvalue" %in% colnames(data)) {
    p_val <- data$pvalue
  } else if ("zscore" %in% colnames(data)) {
    p_val <- 2*pnorm(-abs(data$zscore))   
  } else {
    stop("Can't build QQ Unif from data")
  }
  
  y <- -sort(log10(p_val))
  if (!is.null(threshold)) {
    y <- pmin(y, threshold) #upper threshold value    
  }

  nn <- length(y)
  x <- -log10((1:nn)/(nn+1))
  b <- -log10(0.05/nn) #bonferroni
  
  d <- data.frame(x=x, y=y, b=b)
  if (!is.null(label)) {
    d$label <- label
  }
  d
}

qq_plot_config_ <- function(columns=2,
                           point_size=1,
                           line_size = 1,
                           legend_label="",
                           colour_column=NULL,
                           colour_labels=NULL,
                           colour_limits=NULL,
                           colour_line=NULL,
                           colours = NULL,
                           scales="free",
                           facet_column=NULL,
                           facet_order=NULL,
                           threshold=NULL) {
  config <- list()
  config$point_size <- point_size
  config$line_size <- line_size
  config$scales <- scales
  config$columns <- columns
  config$facet_column <- facet_column
  config$facet_order <- facet_order
  config$threshold <- threshold
  
  config$legend_label <- legend_label
  config$colour_column <- colour_column
  config$colour_labels <- colour_labels
  config$colours <- colours
  config$colour_limits <- colour_limits
  config$colour_line <- colour_line
  
  config
}

qq_plot_ <- function(qq_data, config=NULL) {
  p <-ggplot() + theme_bw() +
    xlab(expression(Expected~~-log[10](italic(p)))) +
    ylab(expression(Observed~~-log[10](italic(p))))
  
  if (!is.null(config)) {
    select_s_ <- c("b", config$colour_column)
    decoration_ <- qq_data %>% select_(.dots=select_s_) %>% unique()
    
    p <- p + geom_point(data = qq_data, mapping=aes_string(x="x", y="y", colour=config$colour_column), size=config$point_size)  +
      geom_hline(data = decoration_, mapping=aes_string(yintercept="b", colour=config$colour_column), size=config$line_size, show.legend = F) +
      geom_abline(intercept=0, slope=1, colour=config$colour_line, size=config$line_size, show.legend = F) +
      scale_colour_manual(values = config$colours, labels = config$colour_labels, limits = config$colour_limits, name=config$legend_label)
  } else {
    decoration_ <- qq_data %>% .[1,]
    
    p <- p + 
      ggplot2::geom_abline(data = qq_data, mapping=aes(intercept=0, slope=1), colour='black', show.legend = F) +
      ggplot2::geom_hline(data = decoration_, mapping=aes(yintercept=b), colour='black', show.legend = F) +
      ggplot2::geom_point(data = qq_data, mapping=aes(x=x, y=y), colour="black")
  }
  
  p
}