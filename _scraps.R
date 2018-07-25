library(dplyr)
library(readr)
library(ggplot2)

r_tsv_ <- function(path, col_types=NULL) { suppressMessages(read_tsv(path, col_types=col_types)) }
r_csv_ <- function(path, col_types=NULL) { suppressMessages(read_csv(path, col_types=col_types)) }

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

print_plot_ <- function(p, path, height, width) {
  png(path, width=width, height=height)
  print(p)
  dev.off()
}
