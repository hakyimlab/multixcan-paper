library(dplyr)

sps <- read.delim("results/gwas_sp_significant.txt")
smts <- read.delim("results/gwas_summary_smultixcan_significant.txt")

egg_sp <- sps %>% filter(name == "Body Mass Index Standard Deviation Score") %>% arrange(pvalue)
egg_sp_ <- egg_sp %>% group_by(gene_name) %>% top_n(n=-1, wt=pvalue)
egg_sp_ %>% arrange(pvalue) %>% select(gene_name, model, pvalue) %>%  head(10)

egg_smt <- smts %>% filter(tag=="EGG_BMI_HapMapImputed") %>% arrange(pvalue)

egg_sp_genes <- egg_sp$gene_name %>% unique()
egg_smt_genes <- egg_smt$gene_name %>% unique()
egg_c_genes <- egg_sp_genes[egg_sp_genes %in% egg_smt_genes]
egg_d_genes <- egg_sp_genes[!(egg_sp_genes %in% egg_smt_genes)]
egg_n_genes <- egg_smt_genes[!(egg_smt_genes %in% egg_sp_genes)]
egg_smt %>% filter(gene_name %in% egg_n_genes) %>% select(gene_name, pvalue)

cad_sp <- sps %>% filter(tag == "CARDIoGRAM_C4D_CAD_ADDITIVE") %>% arrange(pvalue)
cad_sp_top_genes <- cad_sp %>% group_by(gene_name) %>% top_n(n=-1, wt=pvalue)
cad_sp_top_genes %>% arrange(pvalue) %>% select(gene_name, model, pvalue)

cad_smt <- smts %>% filter(tag=="CARDIoGRAM_C4D_CAD_ADDITIVE") %>% arrange(pvalue)

cad_sp_genes <- cad_sp$gene_name %>% unique()
cad_smt_genes <- cad_smt$gene_name %>% unique()
cad_c_genes <- cad_sp_genes[cad_sp_genes %in% cad_smt_genes]
cad_d_genes <- cad_sp_genes[!(cad_sp_genes %in% cad_smt_genes)]
cad_n_genes <- cad_smt_genes[!(cad_smt_genes %in% cad_sp_genes)]
cad_smt %>% filter(gene_name %in% cad_n_genes) %>% select(gene_name, pvalue)