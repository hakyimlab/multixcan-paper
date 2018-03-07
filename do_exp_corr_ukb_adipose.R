#!/usr/bin/env Rscript
suppressWarnings(library(dplyr))
suppressWarnings(library(ggplot2))
suppressWarnings(library(readr))
suppressWarnings(source("_helpers_plots.R"))

d <- read.delim("data/ukb/ukb_exp_adipose_corr.txt")
p <- ggplot(d) + geom_histogram(aes(pearson**2), color="black", bins=10) + 
  ggtitle("Predicted Expression Correlation Distribution", subtitle="Adipose Visceral Omentum and Subcutaneous Studies") +
  xlab(expression(R^2)) + theme_bw() + paper_plot_theme_a()
save_png(p, "results/ukb_adipose_expression_correlation.png", 700, 700)

#itś too exaggerated
#y <- d %>% filter(!is.na(p)) %>% mutate(tp=pmax(p,1e-30)) %>% mutate(lp = -log10(tp))  %>% .$lp %>% sort
#x <- sort(-log10(runif(length(y))))
