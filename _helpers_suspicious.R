
load_s_data <- function(names) {
  d <- data.frame()
  for (i in 1:nrow(names)) {
    n_ <- names[i,]
    smtp <- n_$smtp %>% r_tsv_
    b_ <- 0.05/nrow(smtp)
    smtp <- smtp %>% mutate(b = b_, trait=n_$name) %>%
      filter(pvalue < b) %>% mutate(s_best=-log10(p_i_best), s_worst=-log10(p_i_worst))
    
    mtp <- n_$mtp %>% r_tsv_ %>% select(gene, pvalue) %>% 
      rename(mt_pvalue = pvalue) %>% mutate(gene = remove_id_from_ensemble(gene))
    d_ <- smtp %>% left_join(mtp, by="gene") %>%
      mutate(right = (mt_pvalue<b_), trait=n_$name)
    d <- rbind(d, d_)
  }
  d
}

proportion_true_positive_ <- function(d_, threshold) {
  true_reliable <- d_ %>% filter(p_i_best<threshold & mt_pvalue <b) %>% nrow()
  significant <- d_ %>% filter(mt_pvalue < b) %>% nrow()
  true_reliable/significant
}

proportion_true_negative_ <- function(d_, threshold) {
  true_unreliable <- d_ %>% filter(p_i_best>=threshold, mt_pvalue >= b) %>% nrow()
  insignificant <- d_ %>% filter(mt_pvalue >= b) %>% nrow()
  true_unreliable/insignificant
}

roc_ <- function(d_, threshold) {
  trait_ <- d_$trait %>% unique()
  data.frame(trait=trait_, 
             true_positive=proportion_true_positive_(d_, threshold), 
             true_negative=proportion_true_negative_(d_, threshold),
             threshold=threshold)
}

proportion_p_ <- function(d_, threshold) {
  reliable <- d_ %>% filter(p_i_best<threshold) %>% nrow()
  significant <- d_ %>% filter(p_i_best<threshold & mt_pvalue > 1e-4) %>% nrow()
  significant/reliable
}

flagged_c_ <- function(d_, threshold) { 
  message(nrow(d_))
  d %>% filter(p_i_best>threshold) %>% nrow() }

get_significance_comparison_ <- function(d, thresholds=unlist(lapply(seq(1,10),  function(x){10**(-x)})), f=roc_) {
  r <- data.frame()
  traits <- unique(d$trait)
  for (trait_ in traits) {
    d_ <- d %>% filter(trait == trait_)
    if (nrow(d_) == 0) next
    for (threshold in thresholds) {
      r_ <- f(d_, threshold)
      r <- rbind(r, r_)
    }
  }
  r
}

plot_suspicious_c_ <- function(d, thresholds=unlist(lapply(seq(1,10),  function(x){10**(-x)})), f=proportion_significant_) {
  f_ <- function(d_, threshold) {
    trait_ <- d$trait %>% unique()
    data.frame(trait=trait_, proportion=f(d_, threshold), threshold=threshold)
  }
  r <- get_significance_comparison_(d, thresholds, f_)
  ggplot(r) + geom_boxplot(aes(x=factor(-log10(threshold)), y=proportion)) + theme_bw()
}