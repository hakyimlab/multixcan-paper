pheno_model_from_file_name_ <- function(text, remove_postfix=NULL) {
  if (!is.null(remove_postfix)) {
    text <- gsub(remove_postfix, "", text)
  }
  pheno <- NULL
  model <- NULL
  if (grepl("_DGN", text)) {
    pheno <- strsplit(text, "_DGN")[[1]][1]
    model <- "DGN_WB"
  } else if (grepl("-TW_", text)) {
    comps = strsplit(text, "-TW_")
    pheno <- comps[[1]][1]
    model <- comps[[1]][2]
  } else if (grepl("_TW_", text)) {
    comps = strsplit(text, "_TW_")
    pheno <- comps[[1]][1]
    model <- comps[[1]][2]
  } else if (grepl("_eQTL_", text)) {
    comps = strsplit(text, "_eQTL_")
    pheno <- comps[[1]][1]
    model <- comps[[1]][2]
  }else if (grepl("_gEUVADIS", text)) {
    comps <- strsplit(text, "_gEUVADIS")
    pheno <- comps[[1]][1]
    model <- paste0("Geuvadis",comps[[1]][2])
  }
  
  list(pheno=pheno,model=model)
}

is_listed_ <- function(text, list=NULL) {
  is <- FALSE;
  for (w in list) {
    if (grepl(w, text)) {
      is <- TRUE
      break;
    }
  }
  is
}

load_folder <- function(folder, remove_postfix=NULL, white_list=NULL, black_list=NULL,
                                          s=c("gene", "effect", "se", "zscore", "pvalue", "n_samples", "status", "pheno", "model"), csv=FALSE) {
  names <- list.files(folder)
  names <- sort(names)
  r <- data.frame()
  for(i in 1:length(names)) {
    name <- names[i]
    if (!is.null(white_list)) {
      skip <- !is_listed_(name, white_list)
      if (skip) { next; }
    }
    if (!is.null(black_list)) {
      skip <- is_listed_(name, black_list)
      if (skip) { next; }
    }
    path <- file.path(folder,name)
    l_ <- if(csv) {readr::read_csv} else {readr::read_tsv}
    d <- suppressMessages(l_(path))
    parts <- pheno_model_from_file_name_(name, remove_postfix)
    d$pheno <- parts$pheno
    d$model <- parts$model
    if (!is.null(s)) {
      d <- d %>% dplyr::select_(.dots=s) 
    }
    r <- rbind(r, d)
  }
  
  r
}