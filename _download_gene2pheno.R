#! /usr/bin/env Rscript
library(dplyr)
source("_helpers_postgre.R")

download_gene2pheno <- function(connection, pheno_info, folder) {
  for (pheno_ in sort(pheno_info$tag)) {
    message(pheno_)
    metaxcan <- build_data_2(connection, c(pheno_))
    path <- file.path(folder, paste0(pheno_, ".csv"))
    metaxcan %>% write.table(path, row.names=FALSE, quote=FALSE, sep="\t")
  }
}

destination <- "data/gene2pheno_dev_hm_1.5"
if (!file.exists(destination)) dir.create(destination)

connection <- db_v6p_hapmap_advanced_5_()
pheno_info <- get_pheno_info(connection)
download_gene2pheno(connection, pheno_info, destination)
DBI::dbDisconnect(connection)