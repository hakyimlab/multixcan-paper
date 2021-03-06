p_save_delim <- function(data, path){
  write.table(data, file=path, row.names = FALSE, sep="\t", quote=FALSE)
}

textify <- function(text) {
  text <- gsub("_", " ",text)
  text
}

r_csv_ <- function(path, col_types=NULL) { suppressMessages(read_csv(path, col_types=col_types)) }

r_tsv_ <- function(path, col_types=NULL) { suppressMessages(read_tsv(path, col_types=col_types)) }

remove_id_from_ensemble <- function(v) {
  k <- gsub("\\.(.*)", "", v)
  return(k)
}

significant_by_tissue <- function(data) {
  d_ <- data %>% filter(!is.na(pvalue))
  b_ <- 0.05/nrow(d_)
  d_ %>% filter(pvalue < b_) %>% group_by(tissue) %>% summarise(n = n()) %>% arrange(-n)
}

get_bonferroni_significant_gene_count <- function(data) {
  data %>% filter(pvalue < 0.05/nrow(data)) %>% .$gene %>% unique() %>% length()
}

get_fdr_significant_gene_count_ <- function(data, fdr) {
  q <- tryCatch({
    qvalue(p = data$pvalue)$qvalues
  }, warning = function(w) {
    NA
  }, error = function(e) {
    NA
  })
  #q <- p.adjust(data$pvalue, method="BH")
  data %>% mutate(qvalue = q) %>% filter(qvalue < fdr) %>% .$gene %>% unique() %>% length()
}

get_fdr_significant_gene_count <- function(data) {
  get_fdr_significant_gene_count_(data, fdr)
}

smultixcan_remove_suspicious <- function(d) {
  d_ <- d %>% dplyr::filter(!is.na(pvalue))
  b_ <- 0.05/nrow(d_)
  d_ %>% dplyr::filter(!(pvalue < b_ & p_i_best>1e-4))
}