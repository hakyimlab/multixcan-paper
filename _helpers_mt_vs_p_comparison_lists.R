library(readr)
library(dplyr)

get_multixcan_vs_predixcan_significant_genes <- function(mtfile, pfile, mtukbphenofile, pheno) {
  mt_ <- read_tsv(mtfile) %>% filter(phenotype == pheno)
  
  mtp_ <- read.delim(mtukbphenofile)
  
  p_ <- read_tsv(pfile) %>% filter(phenotype == pheno)
  p_ <- p_ %>% group_by(gene, gene_name) %>% 
    summarise(n_significant_models=n()) %>% 
    inner_join(p_ %>% group_by(gene, gene_name)  %>% top_n(1,pvalue))
  
  p_genes <- p_$gene %>% unique()
  mt_genes <- mt_$gene %>% unique()
  mt_all_genes <- mtp_$gene
  shared_genes <- p_genes[p_genes %in% mt_genes]
  p_only_genes <- p_genes[!(p_genes %in% mt_genes)]
  mt_only_genes <- mt_genes[!(mt_genes %in% p_genes)]
  
  list(p_genes=p_genes, mt_genes=mt_genes, mt_all_genes=mt_all_genes, 
     shared_genes=shared_genes, 
       p_only_genes=p_only_genes, mt_only_genes=mt_only_genes)
}