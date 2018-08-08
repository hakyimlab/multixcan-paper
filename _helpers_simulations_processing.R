load_mt_ <- function(path, type, label) {
  path %>% r_tsv_ %>% mutate(type = type, label = label)
}

load_d_ <- function(path, type, label) {
  load_mt_(path, type, label) %>% select(gene, pvalue, label)
}

load_mt_logic_ <- function(comb_l) {
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

get_sim_mt_logic <- function(path, pattern, transform = NULL) {
  files <- sort(list.files(path))
  files <- files[grepl(pattern, files)]
  l_ <- data.frame(file=files, stringsAsFactors = FALSE) %>%
    mutate(run = gsub(pattern, "\\1", file)) %>%
    mutate(path = file.path(path, file))
  
  if (!is.null(transform)) {
    l_ <- transform(l_)
  }
  
  l_  
}

extract_ <- function(d) {
  d %>% mutate(cn = gsub("ccn(.*)_cc(.*)_cs(.*)_t(.*)", "\\1", run) %>% as.integer) %>%
    mutate(cc = gsub("ccn(.*)_cc(.*)_cs(.*)_t(.*)", "\\2", run) %>% as.numeric ) %>%
    mutate(cs = gsub("ccn(.*)_cc(.*)_cs(.*)_t(.*)", "\\3", run) %>% as.numeric ) %>%
    mutate(t = gsub("ccn(.*)_cc(.*)_cs(.*)_t(.*)", "\\4", run) %>% as.numeric)
}

extract_2_ <- function(d) {
  d %>% mutate(cn = gsub("ccn(.*)_cc(.*)", "\\1", run) %>% as.integer) %>%
    mutate(cc = gsub("ccn(.*)_cc(.*)", "\\2", run) %>% as.numeric)
}

extract_3_ <- function(d) {
  d %>% mutate(cn = gsub("ccn_(.*)", "\\1", run) %>% as.integer)
}


choose_ <- function(d, cn_, cc_, cs_, t_) {
  d %>% filter(cn == cn_, cc == cc_, cs == cs_, t == t_) %>% .$path %>% r_tsv_
}

choose_2_ <- function(d, cn_, cc_) {
  d %>% filter(cn == cn_, cc == cc_) %>% .$path %>% r_tsv_
}

qq_compare_ <- function(d1, d2) {
  if (nrow(d1) != nrow(d2)) error("can't compare")
  
  x <- sort(-log10(d1$pvalue))
  y <- sort(-log10(d2$pvalue))
  data.frame(x=x, y=y) %>% ggplot() + theme_bw() +
    geom_point(aes(x=x, y=y)) +
    geom_abline(slope=1, intercept=0)
}

the_box_plot_ <- function(d, yl=NULL) {
  p <- ggplot(d, aes(x = label, y = y))
  if(!is.null(yl)) {
    p <- p + geom_hline(yintercept = yl)
  }
  p + paper_plot_theme_a() +
    geom_boxplot(fill="gray") +
    scale_fill_brewer(palette = "Accent")
}