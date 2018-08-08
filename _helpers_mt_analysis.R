###############################################################################

spredixcan_significant_gtex_ <- function(sp) {
  sp_ <- sp %>% dplyr::filter(!is.null(pval), !(grepl("DGN",model)))
  sp_ %>% dplyr::filter(pval < 0.05/nrow(sp_))
}

spredixcan_significant_gtex_q_ <- function(sp) {
  sp_ <- sp %>% dplyr::filter(!is.null(pval), !(grepl("DGN",model)))
  q <- tryCatch({
    qvalue(p = sp_$pval)$qvalues
  }, warning = function(w) {
    NA
  }, error = function(e) {
    NA
  })
  sp_ %>% dplyr::mutate(qvalue = q) %>% dplyr::filter(qvalue < 0.05)
}

smt_significant_minus_suspicious_ <- function(smt) {
  smt_ <- smt %>% dplyr::filter(!is.null(pvalue)) %>% dplyr::mutate(gene = remove_id_from_ensemble(gene))
  smt_ %>% dplyr::filter(pvalue < 0.05/nrow(smt_) & p_i_best<1e-4)
}

smt_significant_minus_suspicious_q_ <- function(smt) {
  smt_ <- smt %>% dplyr::filter(!is.null(pvalue)) %>% dplyr::mutate(gene = remove_id_from_ensemble(gene))
  q <- tryCatch({
    qvalue(p = smt_$pvalue)$qvalues
  }, warning = function(w) {
    NA
  }, error = function(e) {
    NA
  })
  smt_ %>% dplyr::mutate(qvalue = q) %>% dplyr::filter(qvalue < 0.05 & p_i_best<1e-4)
}

smt_significant_suspicious_ <- function(smt) {
  smt_ <- smt %>% dplyr::filter(!is.null(pvalue)) %>% dplyr::mutate(gene = remove_id_from_ensemble(gene))
  smt_ %>% dplyr::filter(pvalue < 0.05/nrow(smt_)) %>% mutate(suspicious = (pvalue < 0.05/nrow(smt_) & p_i_best>1e-4))
}

get_m_smt_stats__ <- function(m_, smt_, spredixcan_significant_m=spredixcan_significant_gtex_, smt_significant_m=smt_significant_minus_suspicious_) {
  m_significant_ <- spredixcan_significant_m(m_)
  m_genes_ <- unique(m_significant_$gene)
  
  smt_significant_ <- smt_significant_m(smt_)
  smt_genes_ <- unique(smt_significant_$gene)
  
  m_not_in_smt_ <- length(m_genes_[!(m_genes_ %in% smt_genes_)])
  smt_not_in_m_ <- length(smt_genes_[!(smt_genes_ %in% m_genes_)])
  data.frame(tag=smt_$phenotype[1], n_spredixcan_significant=length(m_genes_), n_smultixcan_significant=length(smt_genes_), n_spredixcan_only=m_not_in_smt_, n_smultixcan_only=smt_not_in_m_)
}

get_m_smt_stats_ <- function(m_, smt_) {
  get_m_smt_stats__(m_, smt_, spredixcan_significant_gtex_, smt_significant_minus_suspicious_)
}

get_m_smt_stats_q_ <- function(m_, smt_) {
  get_m_smt_stats__(m_, smt_, spredixcan_significant_gtex_q_, smt_significant_minus_suspicious_q_)
}

#
get_mt_metaxcan_analysis <- function(metaxcan_data_folder, smt_folder, verbose=FALSE, stats_f_=get_m_smt_stats_, 
                                     spredixcan_significant_m=spredixcan_significant_gtex_, smt_significant_m=smt_significant_minus_suspicious_) {
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
    m_ <- suppressWarnings( r_tsv_(l_$m_p) %>% dplyr::mutate(phenotype = l_$name) )
    smt_ <- suppressWarnings( r_tsv_(l_$smt_p) %>% dplyr::mutate(phenotype = l_$name) )
    
    stats <- rbind(stats, stats_f_(m_, smt_))
    sp_significant <- rbind(sp_significant, spredixcan_significant_m(m_))
    smt_significant <- rbind(smt_significant, smt_significant_m(smt_))
  }
  
  list(stats=stats, sp_significant=sp_significant, smt_significant=smt_significant)
}

###############################################################################

predixcan_significant_ <- function(p) {
  p_ <- p %>% dplyr::filter(!is.null(pvalue))
  p_ %>% dplyr::filter(pvalue < 0.05/nrow(p_))
}

predixcan_q_significant_ <- function(p) {
  p_ <- p %>% dplyr::filter(!is.null(pvalue))
  p_ %>% dplyr::mutate(qvalue = qvalue(p = pvalue)$qvalues) %>% dplyr::filter(qvalue < 0.05)
}

multixcan_significant_ <- function(mt) {
  mt_ <- mt %>% dplyr::filter(!is.null(pvalue))
  mt_ %>% dplyr::filter(pvalue < 0.05/nrow(mt_))
}

multixcan_q_significant_ <- function(mt) {
  mt_ <- mt %>% dplyr::filter(!is.null(pvalue))
  mt_ %>% dplyr::mutate(qvalue = qvalue(p = pvalue)$qvalues) %>% dplyr::filter(qvalue < 0.05)
}

get_p_mt_stats__ <- function(p_, mt_, predixcan_significant_m, multixcan_significant_m) {
  p_significant_ <- predixcan_significant_m(p_)
  p_genes_ <- unique(p_significant_$gene)
  
  mt_significant_ <- multixcan_significant_m(mt_)
  mt_genes_ <- unique(mt_significant_$gene)
  
  p_not_in_mt_ <- length(p_genes_[!(p_genes_ %in% mt_genes_)])
  mt_not_in_p_ <- length(mt_genes_[!(mt_genes_ %in% p_genes_)])
  data.frame(tag=mt_$phenotype[1], n_predixcan_significant=length(p_genes_), n_multixcan_significant=length(mt_genes_), n_predixcan_only=p_not_in_mt_, n_multixcan_only=mt_not_in_p_)
}

get_p_mt_stats_ <- function(p_, mt_) {
  get_p_mt_stats__(p_, mt_, predixcan_significant_, multixcan_significant_)
}

get_p_mt_stats_q_ <- function(p_, mt_) {
  get_p_mt_stats__(p_, mt_, predixcan_q_significant_, multixcan_q_significant_)
}

get_mt_predixcan_analysis <- function(mt_folder, predixcan_folder, verbose=FALSE, stats_f_=get_p_mt_stats_, 
                                      predixcan_significant_f_=predixcan_significant_, multixcan_significant_f_=multixcan_significant_) {
  mt_file_logic <- get_mt_files_d_(mt_folder)
  predixcan_file_logic <- univariate_file_logic(predixcan_folder)
  
  p_significant <- data.frame()
  mt_significant <- data.frame()
  stats <- data.frame()
  for (name_ in mt_file_logic$mt_name) {
    if(verbose) { message(paste0("Processing ", name_)) }
    mt_ <- suppressWarnings(mt_file_logic %>% dplyr::filter(mt_name == name_) %>% .$mtp %>% r_tsv_() %>% dplyr::mutate(phenotype = name_))
    p_ <- suppressWarnings(load_univariate_files(predixcan_file_logic %>% filter(name == name_)))
    
    stats <- rbind(stats, stats_f_(p_, mt_))
    p_significant <- rbind(p_significant, predixcan_significant_f_(p_))
    mt_significant <- rbind(mt_significant, multixcan_significant_f_(mt_))
  }
  
  list(stats=stats, p_significant=p_significant, mt_significant=mt_significant)
}

get_mt_individual_suspicious <- function(mt_folder_0, mt_folder_30, verbose=FALSE) {
  mt_file_logic_0 <- get_mt_files_d_(mt_folder_0)
  mt_file_logic_30 <- get_mt_files_d_(mt_folder_30)
  
  stats <- data.frame()
  for (name_ in mt_file_logic_30$mt_name) {
    if(verbose) { message(paste0("Processing ", name_)) }
    mt_0 <- suppressWarnings(mt_file_logic_0 %>% dplyr::filter(mt_name == name_) %>% .$mtp %>% r_tsv_() %>% dplyr::mutate(phenotype = name_))
    mt_30 <- suppressWarnings(mt_file_logic_30 %>% dplyr::filter(mt_name == name_) %>% .$mtp %>% r_tsv_() %>% dplyr::mutate(phenotype = name_))
    d <- mt_0 %>% rename(pvalue_30 = pvalue) %>% select(gene, p_i_best, pvalue_30) %>% inner_join(mt_30 %>% select(gene, pvalue), by= "gene")

    b <- 0.05/nrow(d %>% filter(!is.na(pvalue)))
    su_ <- d %>% filter(pvalue < b, p_i_best > 1e-4) %>% nrow()
    si_ <- d %>% filter(pvalue < b) %>% nrow()
    stats <- rbind(stats, data.frame(trait=name_, n_flagged=su_, n_significant=si_, stringsAsFactors = FALSE))
  }
  
  return(stats)
}

###############################################################################

plot_n_significant_comparison_ <- function(d, threshold) {
  d %>% ggplot2::ggplot(mapping=ggplot2::aes(x=x, y=y)) + 
    ggplot2::coord_cartesian(xlim = c(0, threshold),  ylim = c(0, threshold), expand = TRUE) +
    ggplot2::geom_point(size=4) +
    ggplot2::geom_abline(slope=1, intercept=0)
}

###############################################################################

plot_n_significant_comparison <- function(stats, threshold=600) {
  p <- stats %>%
    dplyr::mutate(x=pmin(n_smultixcan_significant, threshold), y=pmin(n_spredixcan_significant,threshold)) %>%
    plot_n_significant_comparison_(threshold) 
  p + ggplot2::xlab("#(S-MulTiXcan Significant)") +
    ggplot2::ylab("#(S-PrediXcan Significant)") +
    ggplot2::ggtitle("Significant associations\nfor S-MulTiXcan and S-PrediXcan", subtitle="# significant associations for each method") + 
    paper_plot_theme_a()
}

plot_n_significant_only_comparison <- function(stats, threshold=200) {
  p <- stats %>%
    dplyr::mutate(x=pmin(n_smultixcan_only, threshold), y=pmin(n_spredixcan_only,threshold)) %>%
    plot_n_significant_comparison_(threshold)
  p + ggplot2::xlab("#(S-MulTiXcan Significant only)") +
    ggplot2::ylab("#(S-PrediXcan Significant only)") + 
    ggplot2::ggtitle("Significant associations\neither in S-MulTiXcan or S-PrediXcan", subtitle="# significant associations only on one method") + 
    paper_plot_theme_a()
}

###############################################################################

plot_n_significant_comparison_i <- function(stats, threshold=1000) {
  p <- stats %>%
    dplyr::mutate(x=pmin(n_multixcan_significant, threshold), y=pmin(n_predixcan_significant,threshold)) %>%
    plot_n_significant_comparison_(threshold) 
  p + ggplot2::xlab("#(MulTiXcan Significant)") +
    ggplot2::ylab("#(PrediXcan Significant)") +
    ggplot2::ggtitle("Significant associations\nfor MulTiXcan and PrediXcan", subtitle="# significant associations for each method") + 
    paper_plot_theme_a()
}

plot_n_significant_only_comparison_i <- function(stats, threshold=200) {
  p <- stats %>%
    dplyr::mutate(x=pmin(n_multixcan_only, threshold), y=pmin(n_predixcan_only,threshold)) %>%
    plot_n_significant_comparison_(threshold)
  p + ggplot2::xlab("#(MulTiXcan Significant only)") +
    ggplot2::ylab("#(PrediXcan Significant only)") + 
    ggplot2::ggtitle("Significant associations\neither in MulTiXcan or PrediXcan", subtitle="# significant associations only on one method") + 
    paper_plot_theme_a()
}


###############################################################################

mt_vs_smt_summary_ <- function(mt, smt, name) {
  m_ <- mt %>% dplyr::inner_join(smt, by="gene")
  m_ <- m_ %>%  dplyr::mutate(mtw=(pvalue.x < pvalue.y))
  b_ <- 0.05/nrow(mt)
  m__ <- m_ %>% dplyr::filter(pvalue.x < b_)

  data.frame(name, 
             genes_total=nrow(m_), 
             genes_conservative=sum(m_$mtw), 
             t_significant_genes=nrow(mt %>% dplyr::filter(pvalue < b_)), 
             t_significant_genes_conservative=sum(m__$mtw), 
             stringsAsFactors = FALSE)
}

get_mt_vs_smt_summary_ <- function(names, verbose=FALSE) {
  r_ <- data.frame()
  for (i in 1:nrow(names)) {
    name <- names$name[i]
    if (verbose) message(name)
    mt <- r_tsv_(names$mtp[i]) %>% dplyr::mutate(gene = remove_id_from_ensemble(gene)) %>% dplyr::select(gene, pvalue)
    smt <- r_tsv_(names$smtp[i]) %>% dplyr::select(gene, pvalue, p_i_best)
    s_ <- mt_vs_smt_summary_(mt, smt, name)
    r_ <- rbind(r_, s_)
  }
  r_
}

plot_conservative_fraction <- function(mt_vs_smt_summary) {
  mt_vs_smt_summary %>% dplyr::mutate(f = t_significant_genes_conservative/t_significant_genes) %>% ggplot2::ggplot(ggplot2::aes(f)) + 
    paper_plot_theme_a() + geom_histogram(color="black", binwidth=0.1)
}