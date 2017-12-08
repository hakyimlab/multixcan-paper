
mt_scatter_data_ <- function(mt1, mt2) {
  mt1 <- mt1 %>% dplyr::mutate(gene = remove_id_from_ensemble(gene))
  mt2 <- mt2 %>% dplyr::mutate(gene = remove_id_from_ensemble(gene))
  
  join_by_ <- if ("phenotype" %in% names(mt1)) { c("gene", "phenotype") } else { c("gene") }
  select_c_ <- if ("phenotype" %in% names(mt1)) { c("gene", "phenotype", "x", "y") } else { c("gene", "x", "y") }
  mt1 %>% dplyr::inner_join(mt2, by=join_by_) %>%
    dplyr::mutate(x=-log10(pvalue.x), y=-log10(pvalue.y)) %>%
    dplyr::select_(.dots=select_c_)
}

mt_scatter_plot_ <- function(d) {
  ggplot2::ggplot(d) + 
    ggplot2::geom_abline(slope=1,intercept=0, colour="gray") +
    ggplot2::geom_point(mapping=ggplot2::aes(x=x, y=y)) 
}

mt_scatter_plot_theme_ <-function(p) {
  p + ggplot2::theme_bw() +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust=0.5, face="bold", size=27),
                 plot.subtitle = ggplot2::element_text(hjust=0.5, face="italic", size=25),
                 axis.title = ggplot2::element_text(size=25),
                 axis.text = ggplot2::element_text(size=20),
                 strip.background = ggplot2::element_blank(),
                 strip.text = ggplot2::element_text(size=17)) +
    ggplot2::guides(fill=TRUE)
}