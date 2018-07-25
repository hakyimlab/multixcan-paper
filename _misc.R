suppressWarnings(source("_scraps.R"))
suppressWarnings(source("_helpers_plots.R"))
suppressWarnings(source("_helpers_simulations_processing.R"))

load_ <- function(comb_l) {
  d <- data.frame()
  for (i in 1:nrow(comb_l)) {
    c_ <- comb_l[i,]
    d_ <- c_$path %>% r_tsv_ 
    d_ <- if ("n_used" %in% colnames(d_)) {
      d_ <- d_ %>% select(gene, pvalue, n_used, n_models)  %>% mutate(cn = c_$cn) 
    } else {
      d_ <- d_ %>% select(gene, pvalue, n_models)  %>% mutate(cn = c_$cn, n_used = NA) 
    }
    #
    d <- rbind(d, d_)
  }
  d
}

(function(){
  comb_l <- get_sim_mt_logic("data/simulations", "combination_brain_pce__(.*)__mt_results.txt", extract_2_)
  d <- load_(comb_l) %>% mutate(label = factor(cn), y = -log10(pvalue))
  d %>% the_box_plot_
}
)()


(function(){
  comb_l <- get_sim_mt_logic("data/simulations", "combination_all_pce__(.*)__mt_results.txt", extract_2_)
  d <- load_(comb_l) %>% mutate(label = factor(cn), y = -log10(pvalue))
  d %>% the_box_plot_
})()
