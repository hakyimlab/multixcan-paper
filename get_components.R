library(readr)
library(dplyr)
source("_helpers_misc.R")

mt <- r_tsv_("results/ukb_multixcan_significant.txt")

message("MultiXcan significant # components")
quantile(mt$n_models) %>% print

message("MultiXcan significant # surviving components")
quantile(mt$n_used) %>% print

message("MultiXcan significant % surviving components")
quantile(mt$n_used/mt$n_models*100) %>% print

message("MultiXcan significant mean % surviving components")
mean(mt$n_used/mt$n_models*100) %>% print

smt <- r_tsv_("results/gwas_smultixcan_significant.txt")

message("S-MultiXcan significant # components")
quantile(smt$n) %>% print

message("S-MultiXcan significant # surviving components")
quantile(smt$n_indep) %>% print

message("S-MultiXcan significant % surviving components")
quantile(smt$n_indep/smt$n*100) %>% print

message("S-MultiXcan significant mean % surviving components")
mean(smt$n_indep/smt$n*100) %>% print
