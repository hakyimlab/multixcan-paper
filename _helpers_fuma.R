library(ggplot2)
library(dplyr)
suppressWarnings(source("_helpers_plots.R"))

fuma_enrichment_comparison <- function(file_a, file_b) {
  a <- read.delim(file_a)
  b <- read.delim(file_b)
  

  m <- a %>% full_join(b, by="GeneSet") %>% 
    mutate(x=ifelse(is.na(p.x),0,-log10(p.x)), y = ifelse(is.na(p.y), 0, -log10(p.y)))
  
  ggplot() + 
    geom_point(mapping=aes(x=x, y=y), data=m) + 
    geom_abline(intercept=0,slope=1) + 
    coord_fixed() +
    theme_bw() +
    ggtitle("FUMA Enrichment comparison") + xlab("PrediXcan-significant only [-log10(p)]") + ylab("MultiXcan-significant only [-log10(p)]") + 
    ggrepel::geom_label_repel(fontface = 'bold', size=3, segment.color = 'grey20', box.padding = grid::unit(0.5, "lines"),
                              mapping=aes(x=x, y=y, label=GeneSet), data=(m %>% filter(y>10)))
    #xlim(0,21) + ylim(0,21)
    #stat_density2d(aes(x=x,y=y), data=(m %>% filter(x!=0,y!=0)))
}

p <- fuma_enrichment_comparison("data/fuma/FUMA_gene2func_chol_p_only/GS.txt", "data/fuma/FUMA_gene2func_chol_mt_only/GS.txt")
save_png(p, "results/fuma_chol.png", 1200, 400)

p <- fuma_enrichment_comparison("data/fuma/FUMA_gene2func_bmi_p_only/GS.txt", "data/fuma/FUMA_gene2func_bmi_mt_only/GS.txt")
save_png(p, "results/fuma_bmi.png", 1200, 400)