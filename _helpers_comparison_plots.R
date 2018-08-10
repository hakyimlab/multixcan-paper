

qq_plot_mt_vs_all_univariate <- function(mt_predixcan, predixcan, selected_model, t_method_name="MultiXcan", p_method_name="PrediXcan") {
  label_s_ <- paste0(p_method_name," (", selected_model, ")")
  label_a_ <- paste0(p_method_name, " (all tissues)")
  
  qq_mt_ <- qq_unif_plot_data_(mt_predixcan, label=t_method_name)
  qq_a_ <- qq_unif_plot_data_(predixcan, label=label_a_)
  qq_s_ <- qq_unif_plot_data_(predixcan %>% filter(tissue == selected_model), label=label_s_)
  qq_ <- rbind(qq_a_, qq_s_, qq_mt_)
  
  label_s__ <- paste0(p_method_name,"\n(", textify(selected_model), ")")
  label_a__ <- paste0(p_method_name, "\n(all tissues)")
  
  config <- qq_plot_config_(
    colour_column="label",
    colour_labels=c(t_method_name, label_a__, label_s__),
    colour_limits=c(t_method_name, label_a_,  label_s_),
    colours = c("#0072B2", "#009E73", "#D55E00"),
    colour_line = "black",
    point_size = 2,
    line_size =2
  )
  
  qq_plot_(qq_, config) + paper_plot_theme_a() + guides(colour = guide_legend(override.aes = list(size=4)))
}

significant_discoveries_bar_plot_ <- function(y, selected_model, t_method_name="MultiXcan", p_method_name="PrediXcan", label=NULL) {
  label_s_ <- paste0(p_method_name,"\n(", textify(selected_model), ")")
  label_a_ <- paste0(p_method_name, "\n(all tissues)")
  x <- c( label_s_, label_a_, t_method_name)
  x <- factor(x, x)
  d <- data.frame(x=x, y=y)
  if (!is.null(label)) {
    d$label <- label
  }
  ggplot() + paper_plot_theme_a() + geom_bar(data = d, mapping=aes(x=x, y=y, fill=x), stat="identity", show.legend=F) +
    xlab(NULL) + ylab(NULL) + 
    scale_fill_manual(values=c("#0072B2", "#009E73", "#D55E00"),
                      limits=c(t_method_name, label_a_, label_s_))
}

significant_discoveries_bar_plot <- function(mt_predixcan, predixcan, selected_model, t_method_name="MultiXcan", p_method_name="PrediXcan", significant_f=get_bonferroni_significant_gene_count) {
  mt_ <- mt_predixcan %>% dplyr::filter(!is.na(pvalue))
  p_ <- predixcan %>% dplyr::filter(!is.na(pvalue))
  
  y <- c(
    significant_f(p_ %>% filter(tissue == selected_model)),
    significant_f(p_),
    significant_f(mt_)
  )
  significant_discoveries_bar_plot_(y, selected_model, t_method_name, p_method_name)
}

scatter_plot_mt <- function(mt1, mt2) {
  mt_scatter_data_(mt1, mt2) %>% mt_scatter_plot_() %>% mt_scatter_plot_theme_()
}

do_scatter_plot_mt_vs_smt <- function(names) {
  mtm <- load_mt_results(names$mtp, names$name)
  smtm <- load_mt_results(names$smtp, names$name)
  scatter_plot_mt(mtm, smtm) + 
    xlab(expression(bold('MultiXcan (-log'[10]*'(p-value))'))) +
    ylab(expression(bold('S-MultiXcan (-log'[10]*'(p-value))')))
}
