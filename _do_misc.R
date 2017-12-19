suppressWarnings(library(readr))
suppressWarnings(library(dplyr))
suppressWarnings(library(ggplot2))
suppressWarnings(source("_helpers_misc.R"))
suppressWarnings(source("_helpers_file_logic.R"))
suppressWarnings(source("_helpers_replication.R"))

ukb_names <- get_mt_files_d_("data/ukb/mt_ukb_cn30")

tcr_info_ <- function(mt_names) {
  d <- data.frame()
  for (i in 1:nrow(mt_names)) {
    s_ <- r_tsv_(mt_names[i,]$mtp) %>% .$n_samples %>% .[1]
    d <- rbind(d, data.frame(tag=mt_names[i,]$mt_name, sample_size=s_, stringsAsFactors=FALSE))
  }
  d
}

ukb_pheno_info <- tcr_info_(ukb_names)
p_save_delim(ukb_pheno_info, "data/ukb/ukb_mt_pheno_info.txt")