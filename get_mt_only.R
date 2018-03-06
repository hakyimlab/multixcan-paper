#/usr/bin/env Rscript
source("_helpers_mt_vs_p_comparison_lists.R")
suppressWarnings(source("_helpers_misc.R"))

comp <- get_multixcan_vs_predixcan_significant_genes(
  "results/ukb_multixcan_significant.txt",
  "results/ukb_p_significant.txt",
  "data/ukb/mt_ukb_cn30/UKB_High_cholesterol_c20002_1536.txt",
  "UKB_High_cholesterol")

write(comp$mt_only_genes %>% remove_id_from_ensemble, "results/ukb_cholesterol_mt_genes.txt", sep="\n")
write(comp$p_only_genes %>% remove_id_from_ensemble, "results/ukb_cholesterol_p_genes.txt", sep="\n")

comp <- get_multixcan_vs_predixcan_significant_genes(
  "results/ukb_multixcan_significant.txt",
  "results/ukb_p_significant.txt",
  "data/ukb/mt_ukb_cn30/UKB_BMI_c21001.txt",
  "UKB_BMI")

write(comp$mt_only_genes %>% remove_id_from_ensemble, "results/ukb_bmi_mt_genes.txt", sep="\n")
write(comp$p_only_genes %>% remove_id_from_ensemble, "results/ukb_bmi_p_genes.txt", sep="\n")