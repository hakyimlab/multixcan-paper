library(readr)
library(dplyr)
source("_helpers_misc.R")

mt <- r_tsv_("results/ukb_multixcan_significant.txt")

message("MulTiXcan significant # components")
quantile(mt$n_models) %>% print

message("MulTiXcan significant # surviving components")
quantile(mt$n_used) %>% print

message("MulTiXcan significant % surviving components")
quantile(mt$n_used/mt$n_models*100) %>% print

message("MulTiXcan significant mean % surviving components")
mean(mt$n_used/mt$n_models*100) %>% print

smt <- r_tsv_("results/gwas_smultixcan_significant.txt")

message("S-MulTiXcan significant # components")
quantile(smt$n) %>% print

message("S-MulTiXcan significant # surviving components")
quantile(smt$n_indep) %>% print

message("S-MulTiXcan significant % surviving components")
quantile(smt$n_indep/smt$n*100) %>% print

message("S-MulTiXcan significant mean % surviving components")
mean(smt$n_indep/smt$n*100) %>% print
