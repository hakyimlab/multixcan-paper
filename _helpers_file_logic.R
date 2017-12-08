###############################################################################
get_ukb_columns_d_ <- function(ukb_column_to_name) {
  suppressMessages(read_csv(ukb_column_to_name)) %>% 
    dplyr::mutate(id = gsub("c", "", id)) %>% 
    dplyr::rename(name=tag) %>%
    dplyr::select(id, name)
}

get_smt_files_d_ <- function(smt) {
  files <- list.files(smt)
  regexp <- if (sum(grepl("_cer_(.*).txt$",files))>0) {
    "_cer_(.*).txt$"
  } else if (sum(grepl("_ccn_(.*).txt$",files, ignore.case=TRUE))>0) {
    "_ccn_(.*).txt$"
  } 
  data.frame(smtp=files) %>%
    dplyr::mutate(smt_name = gsub(regexp, "", smtp, perl = TRUE,  ignore.case = TRUE)) %>%
    dplyr::mutate(smtp = file.path(smt, smtp))
}

get_mt_files_d_ <- function(mt) {
  data.frame(mtp=list.files(mt)) %>%
    dplyr::mutate(mt_name = gsub("_CCN_([0-9])", "", mtp, perl=TRUE, ignore.case=TRUE)) %>% #this is a work around to naming inconsistency
    dplyr::mutate(mt_name = gsub("_c([0-9_c]*).txt$", "", mt_name, perl = TRUE,ignore.case = TRUE)) %>%
    dplyr::mutate(mtp = file.path(mt, mtp))
}

###############################################################################
ukb_file_metadata_smt_mt <- function(ukb_column_to_name, smt, mt) {
  n_ <- get_ukb_columns_d_(ukb_column_to_name)
  
  a_ <- get_mt_files_d_(mt)
  a <- n_ %>% dplyr::inner_join(a_, by=c("name"="mt_name"))
  
  b_ <- get_smt_files_d_(smt)
  b <- n_ %>% dplyr::inner_join(b_, by=c("name"="smt_name"))
  
  a %>% dplyr::inner_join(b, by=c("id", "name")) %>% dplyr::arrange(name)
}

ukb_file_metadata_smt_mt_mt <- function(ukb_column_to_name, smt, mt1, mt2){
  n_ <- get_ukb_columns_d_(ukb_column_to_name)
  
  a_ <- get_smt_files_d_(smt)
  a <- n_ %>% dplyr::inner_join(a_, by=c("name"="smt_name"))
  
  b_ <- get_mt_files_d_(mt1) %>% dplyr::rename(mtp_1=mtp)
  b <- n_ %>% dplyr::inner_join(b_, by=c("name"="mt_name"))
  
  c_ <- get_mt_files_d_(mt2) %>% dplyr::rename(mtp_2=mtp)
  c <- n_ %>% dplyr::inner_join(c_, by=c("name"="mt_name"))
  
  
  a %>% dplyr::inner_join(b, by=c("id", "name")) %>% 
    dplyr::inner_join(c, by=c("id", "name")) %>%
    dplyr::arrange(name)
}

ukb_file_metadata_mt_mt  <- function(ukb_column_to_name, mt1, mt2) {
  n_ <- get_ukb_columns_d_(ukb_column_to_name)
  
  a_ <- get_mt_files_d_(mt1) %>% dplyr::rename(mtp_1=mtp)
  a <- n_ %>% dplyr::inner_join(a_, by=c("name"="mt_name"))
  
  b_ <- get_mt_files_d_(mt2) %>% dplyr::rename(mtp_2=mtp)
  b <- n_ %>% dplyr::inner_join(b_, by=c("name"="mt_name"))

  a %>% dplyr::inner_join(b, by=c("id", "name")) %>% dplyr::arrange(name)
}

###############################################################################

#mt or smt actually
load_mt_results <- function(paths, names, columns=c("gene", "pvalue")) {
  d <- data.frame()
  for (i in 1:length(paths)) {
    path_ <- paths[i]
    name_ <- names[i]
    d_ <- suppressMessages(read_tsv(path_)) %>% dplyr::select_(.dots=columns) %>% dplyr::mutate(phenotype = name_)
    d <- rbind(d, d_)
  }
  d$phenotype <- factor(d$phenotype, levels=names)
  d
}

###############################################################################

get_ukb_names <- function(column_to_name, folder){
  n_ <- readr::read_csv(column_to_name) %>% 
    dplyr::mutate(id = gsub("c", "", id)) %>% 
    dplyr::rename(ukb_name=tag) %>%
    dplyr::select(id, ukb_name)
  
  a_ <- data.frame(mtp=list.files(folder)) %>%
    dplyr::mutate(ukb_name = gsub("_CCN_([0-9])", "", mtp, perl=TRUE, ignore.case=TRUE)) %>%
    dplyr::mutate(ukb_name = gsub("_c([0-9_c]*).txt$", "", ukb_name, perl = TRUE)) %>%
    dplyr::mutate(ukb_path = file.path(folder, mtp))
  
  n_ %>% dplyr::inner_join(a_, by="ukb_name")
}

get_gwas_names_from_multi_tissue <- function(folder) {
  data.frame(gtp=list.files(folder)) %>%
    dplyr::mutate(gwas_name = gsub("_ccn(.*).txt$", "", gtp, perl = TRUE)) %>% 
    dplyr::mutate(gwas_name = gsub("_cer(.*).txt$", "", gwas_name, perl = TRUE)) %>%
    dplyr::mutate(gwas_path = file.path(folder, gtp))
}

univariate_file_logic <- function(path) {
  names <- path %>% list.files() %>% sort()
  r <- data.frame(path = file.path(path, names), name=names)
  r <- r %>% dplyr::mutate(pheno = gsub("(.*)_TW_(.*).txt", "\\1", name)) %>%
    dplyr::mutate(tissue = gsub("(.*)_TW_(.*).txt", "\\2", name)) %>%
    dplyr::mutate(name = gsub("_c([0-9_c]*)$", "", pheno, perl = TRUE))
  r
}