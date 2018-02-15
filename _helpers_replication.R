discovery_f_smultixcan <- function(d) {
  d  %>% smultixcan_remove_suspicious() %>% dplyr::select(gene=gene, pvalue_d=pvalue, n_used_d=n_indep, n_models_d=n) %>% dplyr::filter(!is.na(pvalue_d)) 
}

replication_f_multixcan <- function(d) {
  d %>% dplyr::select(gene, pvalue_r=pvalue, n_used_r=n_used, n_models_r=n_models) %>% dplyr::filter(!is.na(pvalue_r))
}

get_replication_spec_gwas_ukb <- function(replication_file, gwas_names, ukb_names) {
  replication <- readr::read_csv(replication_file) %>% 
    dplyr::inner_join(gwas_names %>% dplyr::select(gwas=name, discovery_path=path), by="gwas") %>% 
    dplyr::inner_join(ukb_names %>% dplyr::select(ukb=mt_name, replication_path=mtp), by="ukb") %>%
    dplyr::rename(discovery=gwas, replication=ukb)
  list(replication_table=replication, discovery_f=discovery_f_smultixcan, replication_f=replication_f_multixcan)
}

###############################################################################

get_replication_stats_ <- function(discovery_d, replication_d, discovery_name, replication_name) {
  bonferroni_d <- 0.05/nrow(discovery_d)
  bonferroni_r <- 0.05/nrow(replication_d)
  
  m_ <- discovery_d %>% dplyr::inner_join(replication_d, by="gene") %>%
    dplyr::mutate(chi_d = qchisq(pvalue_d, n_used_d, lower.tail=FALSE), chi_r = qchisq(pvalue_r, n_used_r, lower.tail=FALSE)) %>%
    dplyr::mutate(pvalue_m = pchisq(chi_d+chi_r,n_used_d+n_used_r, lower.tail=FALSE))
  
  data.frame(
    discovery = discovery_name, replication = replication_name,
    discovery_significant_genes = discovery_d %>% dplyr::filter(pvalue_d < bonferroni_d) %>% nrow(),
    replication_available_genes = replication_d %>% dplyr::filter(pvalue_r < 0.05) %>% nrow(),
    replication_significant_genes = replication_d %>% dplyr::filter(pvalue_r < bonferroni_r) %>% nrow(),
    replicated_genes = m_ %>% dplyr::filter(pvalue_d < bonferroni_d & pvalue_r<0.05 & pvalue_m < bonferroni_d) %>% nrow(),
    stringsAsFactors = FALSE
  )
}

#################################################################################

get_replication_analisis <- function(replication_spec, verbose=FALSE) {
  replication_table <- replication_spec$replication_table
  d <- data.frame()
  for (i in 1:nrow(replication_table)) {
    if (verbose) { message(paste0(replication_table[i,]$discovery,"-", replication_table[i,]$replication))}
    discovery_d <- r_tsv_ (replication_table[i,]$discovery_path) %>% dplyr::mutate(gene = remove_id_from_ensemble(gene)) %>% replication_spec$discovery_f()
    replication_d <- r_tsv_(replication_table[i,]$replication_path) %>% dplyr::mutate(gene = remove_id_from_ensemble(gene)) %>% replication_spec$replication_f()
    d <- rbind(d, get_replication_stats_(discovery_d, replication_d, replication_table[i,]$discovery, replication_table[i,]$replication))
  }
  d %>% dplyr::arrange(-replicated_genes)
}

#################################################################################

replication_supplement_stx_tx <- function(replication_stats, discovery_pheno_info, replication_pheno_info) {
  replication_stats %>% 
    dplyr::inner_join(discovery_pheno_info %>% dplyr::select(discovery=tag, discovery_sample_size=sample_size), by="discovery") %>%
    dplyr::inner_join(replication_pheno_info %>% dplyr::select(replication=tag, replication_sample_size=sample_size), by="replication")
}