

qq_plot_mt_vs_all_univariate <- function(mt_predixcan, predixcan, selected_model) {
  label_s_ <- paste0("PrediXcan, ", selected_model)
  
  qq_mt_ <- qq_unif_plot_data_(mt_predixcan, label="MT-PrediXcan")
  qq_a_ <- qq_unif_plot_data_(predixcan, label="PrediXcan, All tissues")
  qq_s_ <- qq_unif_plot_data_(predixcan %>% filter(tissue == selected_model), label=label_s_)
  qq_ <- rbind(qq_a_, qq_s_, qq_mt_)
  
  config <- qq_plot_config_(
    colour_column="label",
    colour_labels=c("MT-PrediXcan", "PrediXcan, All Tissues", textify(label_s_)),
    colour_limits=c("MT-PrediXcan", "PrediXcan, All tissues", label_s_),
    colours = c("black", "dodgerblue3", "firebrick3"),
    colour_line = "black",
    point_size = 2,
    line_size =2
  )
  
  qq_plot_(qq_, config) + paper_plot_theme_a() + guides(colour = guide_legend(override.aes = list(size=4)))
}


significant_discoveries_bar_plot <- function(mt_predixcan, predixcan, selected_model) {
  mt_ <- mt_predixcan %>% dplyr::filter(!is.na(pvalue))
  p_ <- predixcan %>% dplyr::filter(!is.na(pvalue))
  
  y <- c(
    get_bonferroni_significant_gene_count(p_ %>% filter(tissue == selected_model)),
    get_bonferroni_significant_gene_count(p_),
    get_bonferroni_significant_gene_count(mt_)
  )
  x <- c( paste0(textify(selected_model)), 
          paste0("All Tissues"),
          paste0("MT-Predixcan"))
  x <- factor(x, x)
  d <- data.frame(x=x, y=y)
  
  ggplot() + paper_plot_theme_a() + geom_bar(data = d, mapping=aes(x=x, y=y, fill=x), stat="identity", show.legend=F) +
    xlab("Method") + ylab(NULL)
}
