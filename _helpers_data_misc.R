

significant_by_tissue <- function(data) {
  d_ <- data %>% filter(!is.na(pvalue))
  n_ <- d_ %>% nrow()
  d_ %>% filter(pvalue < 0.05/n_) %>% group_by(tissue) %>% summarise(n = n()) %>% arrange(-n)
}

get_bonferroni_significant_gene_count <- function(data) {
  data %>% filter(pvalue < 0.05/nrow(data)) %>% .$gene %>% unique() %>% length()
}
