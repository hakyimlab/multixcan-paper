
mt_vs_smt_comparison_qq_data_ <- function(mtp, smtp, label) {
  mtp_ <- read.delim(mtp) %>% mutate(gene = remove_id_from_ensemble(gene))
  smtp_ <- read.delim(smtp) %>% mutate(gene = remove_id_from_ensemble(gene))
  
  m <- mtp_ %>% inner_join(smtp_, by="gene") %>%
    mutate(x=-log10(pvalue.x), y=-log10(pvalue.y))
  
  x = sort(m$x)
  y = sort(m$y)
  
  data.frame(x=x, y=y, label=label)
}

do_mt_vs_smt_qq <- function(names) {
  
  for (i in 1:nrow(names)) {
    
  }
}