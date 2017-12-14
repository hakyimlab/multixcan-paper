
r_csv_ <- function(path) { suppressMessages(read_csv(path)) }
r_tsv_ <- function(path) { suppressMessages(read_tsv(path)) }

spredixcan_significant_gtex_ <- function(sp) {
  sp_ <- sp %>% dplyr::filter(!is.null(pval), !(grepl("DGN",model)))
  sp_ %>% dplyr::filter(pval < 0.05/nrow(sp_))
}

smt_significant_minus_suspicious_ <- function(smt) {
  smt_ <- smt %>% dplyr::filter(!is.null(pvalue)) %>% dplyr::mutate(gene = remove_id_from_ensemble(gene))
  smt_ %>% dplyr::filter(pvalue < 0.05/nrow(smt_) & p_i_best<1e-4)
}

smt_significant_suspicious_ <- function(smt) {
  smt_ <- smt %>% dplyr::filter(!is.null(pvalue)) %>% dplyr::mutate(gene = remove_id_from_ensemble(gene))
  smt_ %>% dplyr::filter(pvalue < 0.05/nrow(smt_)) %>% mutate(suspicious = (pvalue < 0.05/nrow(smt_) & p_i_best>1e-4))
}

get_m_smt_stats_ <- function(m_, smt_) {
  m_significant_ <-spredixcan_significant_gtex_(m_)
  m_genes_ <- unique(m_significant_$gene)
  
  smt_significant_ <- smt_significant_minus_suspicious_(smt_)
  smt_genes_ <- unique(smt_significant_$gene)
  
  m_not_in_smt_ <- length(m_genes_[!(m_genes_ %in% smt_genes_)])
  smt_not_in_m_ <- length(smt_genes_[!(smt_genes_ %in% m_genes_)])
  data.frame(tag=smt_$phenotype[1], n_spredixcan_significant=length(m_genes_), n_stissuexcan_significant=length(smt_genes_), n_spredixcan_only=m_not_in_smt_, n_stissuexcan_only=smt_not_in_m_)
}

#
get_mt_metaxcan_analysis <- function(metaxcan_data_folder, smt_folder, verbose=FALSE, stats_f_=get_m_smt_stats_) {
  metaxcan_file_logic <- get_files_d_(metaxcan_data_folder)
  smt_file_logic <- get_smt_files_d_(smt_folder)
  file_logic <- metaxcan_file_logic %>%
    dplyr::inner_join(smt_file_logic, by=c("name"="smt_name")) %>% 
    dplyr::rename(m_p=path, smt_p=smtp)
  
  sp_significant <- data.frame()
  smt_significant <- data.frame()
  stats <- data.frame()
  for (i in 1:nrow(file_logic)) {
    l_ <- file_logic[i,]
    if(verbose) { message(paste0("Processing ", l_$name)) }
    m_ <- r_tsv_(l_$m_p) %>% dplyr::mutate(phenotype = l_$name)
    smt_ <- r_tsv_(l_$smt_p) %>% dplyr::mutate(phenotype = l_$name)
    
    stats_ <-stats_f_(m_, smt_)
    stats <- rbind(stats, stats_)
    
    sp_significant_ <- spredixcan_significant_gtex_(m_)
    sp_significant <- rbind(sp_significant, sp_significant_)
    
    smt_significant_ <- smt_significant_suspicious_(smt_)
    smt_significant <- rbind(smt_significant, smt_significant_)
  }
  
  list(stats=stats, sp_significant=sp_significant, smt_significant=smt_significant)
}

plot_n_significant_comparison_ <- function(d, threshold) {
  d %>% ggplot2::ggplot(mapping=ggplot2::aes(x=x, y=y)) + 
    ggplot2::coord_cartesian(xlim = c(0, threshold),  ylim = c(0, threshold), expand = TRUE) +
    ggplot2::geom_point(size=4) +
    ggplot2::geom_abline(slope=1, intercept=0)
}

plot_n_significant_comparison <- function(stats, threshold=600) {
  p <- stats %>%
    dplyr::mutate(x=pmin(n_stissuexcan_significant, threshold), y=pmin(n_spredixcan_significant,threshold)) %>%
    plot_n_significant_comparison_(threshold) 
  p + ggplot2::xlab("#(SMT-PrediXcan Significant)") +
    ggplot2::ylab("#(S-PrediXcan Significant)") +
    ggplot2::ggtitle("Significant associations\nfor SMT-PrediXcan and S-PrediXcan", subtitle="# significant associations for each method") + 
    paper_plot_theme_a()
}

plot_n_significant_only_comparison <- function(stats, threshold=200) {
  p <- stats %>%
    dplyr::mutate(x=pmin(n_stissuexcan_only, threshold), y=pmin(n_spredixcan_only,threshold)) %>%
    plot_n_significant_comparison_(threshold)
  p + ggplot2::xlab("#(SMT-PrediXcan Significant only)") +
    ggplot2::ylab("#(S-PrediXcan Significant only)") + 
    ggplot2::ggtitle("Significant associations\nonly in SMT-PrediXcan or S-PrediXcan", subtitle="# significant associations only on one method") + 
    paper_plot_theme_a()
}