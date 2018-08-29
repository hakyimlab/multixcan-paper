# MultiXcan Paper Analysis

This repository contains software and instructions to reproduce all material and analysis in the MulTiXcan paper ([biorxiv](https://doi.org/10.1101/292649)).

You can find MultiXcan and S-MultiXcan implementations in [Github](https://github.com/hakyimlab/MetaXcan).

## Abstract

* Integration of genome-wide association studies (GWAS) and expression quantitative trait loci (eQTL) studies is needed to improve our understanding of the biological mechanisms underlying GWAS hits, and our ability to identify therapeutic targets. Gene-level association methods such as PrediXcan can prioritize candidate targets.
However, limited eQTL sample sizes and absence of relevant developmental and disease context restrict our ability to detect associations. 
Here we propose an efficient statistical method (MultiXcan) that leverages the substantial sharing of eQTLs across tissues and contexts to improve our ability to identify potential target genes.
MultiXcan integrates evidence across multiple panels using multivariate regression, which naturally takes into account the correlation structure.
We apply our method to simulated and real traits from the UK Biobank and show that, in realistic settings, we can detect a larger set of significantly associated genes than using each panel separately.
To improve applicability, we developed a summary result-based extension called S-MultiXcan, which we show yields highly concordant results with the individual level version when LD is well matched.
Our multivariate model-based approach allowed us to use the individual level results as a gold standard to calibrate and develop a robust implementation of the summary-based extension.
Results from our analysis as well as software and necessary resources to apply our method are publicly available. *

## Instructions

Download the data release from [10.5281/zenodo.1402225](https://doi.org/10.5281/zenodo.1402225).
Unpack it into `data` subfolder so that it looks like:
```
$ tree -d -L 1 data
data
├── additional
├── correlation
├── gene2pheno_dev_hm_1.5
├── simulations
├── smt
├── ukb
└── wtccc
```

Then, knit the R markdown files in succession (You can use RStudio for that, or R command line):
- 00_UKB.Rmd
- 01_GWAS.Rmd
- 02_Spotlight.Rmd
- 03_UKB_Spotlight.Rmd
- 04_Replication.Rmd
- 05_Simulations.Rmd
- 06_WTCCC.Rmd
- 07_Suspicious.Rmd

Finally, run:
```
#compiles figures and supplementary data
./paper_material.py
```

## Data Availability

### Reproducible Analysis

The data strictly necessary to reproduce this paper is publicly available in zenodo:
- [Data](https://zenodo.org/record/1402226#.W4bMQhgna90), doi `10.5281/zenodo.1402225`

This release contains all method results, and supporting display information; no other data is needed for the analysis scripts in this repository.

### Analyzed Data

The methods were run on data obtained from publicly available resources:

- Publicly available transcriptome prediction models and LD reference trained on GTEx data release `v6p` (obtained from [PredictDB](http://predictdb.org/)
- De-identified genotype and phenotype information from [UK Biobank](http://www.ukbiobank.ac.uk), obtained under Application Number 19526.
- De-identified genotype and phenotype information from [WTCCC](https://www.wtccc.org.uk/)
- De-identified genotype and phenotype information from [GERA](https://rpgehportal.kaiser.org/)
- Publicly available GWAS summary statistics

The GWAS summary statistics were obtained from:
| consortium | tag | portal |
| ---------- | --- | ------ |
| ADIPOGen  | ADIPOGen_Adiponectin  | http://www.mcgill.ca/genepi/adipogen-consortium  | 
| ANGST  | ANGST_ANXIETY_CC  | https://www.med.unc.edu/pgc/results-and-downloads  | 
| AMD  | AdvancedAMD_2015  | http://csg.sph.umich.edu/abecasis/public/amd2015/  | 
| CARDIoGRAM_C4D  | CARDIoGRAM_C4D_CAD_ADDITIVE  | http://www.cardiogramplusc4d.org/downloads/  | 
| CARDIoGRAM_C4D  | CARDIoGRAM_C4D_MI_ADDITIVE  | http://www.cardiogramplusc4d.org/downloads/  | 
| CIAC  | CIAC  | https://www.med.unc.edu/pgc/results-and-downloads  | 
| CKDGen  | CKDGen_Chronic_Kidney_Disease  | https://fox.nhlbi.nih.gov/CKDGen/  | 
| CKDGen  | CKDGen_MA  | https://fox.nhlbi.nih.gov/CKDGen/  | 
| CKDGen  | CKDGen_UACR_DM  | https://fox.nhlbi.nih.gov/CKDGen/  | 
| CKDGen  | CKDGen_UACR_Overall  | https://fox.nhlbi.nih.gov/CKDGen/  | 
| CKDGen  | CKDGen_UACR_nonDM  | https://fox.nhlbi.nih.gov/CKDGen/  | 
| CKDGen  | CKDGen_eGFRcrea_DM  | https://fox.nhlbi.nih.gov/CKDGen/  | 
| CKDGen  | CKDGen_eGFRcrea_Overall  | https://fox.nhlbi.nih.gov/CKDGen/  | 
| CKDGen  | CKDGen_eGFRcrea_Overall_AFR  | https://fox.nhlbi.nih.gov/CKDGen/  | 
| CKDGen  | CKDGen_eGFRcrea_nonDM  | https://fox.nhlbi.nih.gov/CKDGen/  | 
| CONVERGE  | CONVERGE_MDD  | http://www.well.ox.ac.uk/converge  | 
| DIAGRAM  | DIAGRAM_T2D_TRANS_ETHNIC  | http://diagram-consortium.org/downloads.html  | 
| EAGLE  | EAGLE_Eczema  | https://data.bris.ac.uk/data/dataset/28uchsdpmub118uex26ylacqm  | 
| EGG  | EGG_BL  | http://egg-consortium.org/  | 
| EGG  | EGG_BMI_HapMapImputed  | http://egg-consortium.org/  | 
| EGG  | EGG_BW3_EUR  | http://egg-consortium.org/  | 
| EGG  | EGG_BW3_TransEthnic  | http://egg-consortium.org/  | 
| EGG  | EGG_HC  | http://egg-consortium.org/  | 
| EGG  | EGG_Obesity  | http://egg-consortium.org/  | 
| EGG  | EGG_Pubertal_growth_12M  | http://egg-consortium.org/  | 
| Gabriel  | GABRIEL_Asthma  | http://www.cng.fr/gabriel/results.html  | 
| GEFOS  | GEFOS_FemoralNeck  | http://www.gefos.org/?q=content/data-release-2015  | 
| GEFOS  | GEFOS_Forearm  | http://www.gefos.org/?q=content/data-release-2015  | 
| GEFOS  | GEFOS_LumbarSpine  | http://www.gefos.org/?q=content/data-release-2015  | 
| GERA  | GERA_ALLERGIC_RHINITIS  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_ASTHMA  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_CANCER  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_CARD  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_DEPRESS  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_DERMATOPHYTOSIS  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_DIA2  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_DYSLIPID  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_HEMORRHOIDS  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_HERNIA_ABDOMINOPELVIC  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_HYPER  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_INSOMNIA  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_IRON_DEFICIENCY  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_IRRITABLE_BOWEL  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_MACDEGEN  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_OSTIOA  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_OSTIOP  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_PEPTIC_ULCERS  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_PSYCHIATRIC  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_PVD  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_STRESS  | https://rpgehportal.kaiser.org/ | 
| GERA  | GERA_VARICOSE_VEINS  | https://rpgehportal.kaiser.org/ | 
| GIANT  | GIANT_BMI_All_Ancestries  | http://www.broadinstitute.org/collaboration/giant/index.php/GIANT_consortium_data_files  | 
| GIANT  | GIANT_HEIGHT  | http://www.broadinstitute.org/collaboration/giant/index.php/GIANT_consortium_data_files  | 
| GIANT  | GIANT_HIP_Combined_All_Ancestries  | http://www.broadinstitute.org/collaboration/giant/index.php/GIANT_consortium_data_files  | 
| GIANT  | GIANT_WC_Combined_All_Ancestries  | http://www.broadinstitute.org/collaboration/giant/index.php/GIANT_consortium_data_files  | 
| GIANT  | GIANT_WHR_Combined_All_Ancestries  | http://www.broadinstitute.org/collaboration/giant/index.php/GIANT_consortium_data_files  | 
| GLGC  | GLGC_Mc_HDL  | http://csg.sph.umich.edu//abecasis/public/lipids2013/  | 
| GLGC  | GLGC_Mc_LDL  | http://csg.sph.umich.edu//abecasis/public/lipids2013/  | 
| GLGC  | GLGC_Mc_TG  | http://csg.sph.umich.edu//abecasis/public/lipids2013/  | 
| GPC  | GPC-NEO-CONSCIENTIOUSNESS  | http://www.tweelingenregister.org/GPC/  | 
| GUGC  | GUGC_Gout  | http://metabolomics.helmholtz-muenchen.de/gugc/  | 
| GUGC  | GUGC_UA  | http://metabolomics.helmholtz-muenchen.de/gugc/  | 
| HRGene  | HRGene_HeartRate  | https://walker05.u.hpc.mssm.edu/  | 
| IBD  | IBD.EUR.Crohns_Disease  | http://www.ibdgenetics.org/  | 
| IBD  | IBD.EUR.Inflammatory_Bowel_Disease  | http://www.ibdgenetics.org/  | 
| IBD  | IBD.EUR.Ulcerative_Colitis  | http://www.ibdgenetics.org/  | 
| IGAP  | IGAP  | http://web.pasteur-lille.fr/en/recherche/u744/igap/igap_download.php  | 
| IM_IGROWTH  | IGROWTH  |   | 
| IHGC  | IHGC_Any_Migraine  | http://www.headachegenetics.org/content/datasets-and-cohorts  | 
| IHGC  | IHGC_Migraine_with_Aura  | http://www.headachegenetics.org/content/datasets-and-cohorts  | 
| IHGC  | IHGC_Migraine_without_Aura  | http://www.headachegenetics.org/content/datasets-and-cohorts  | 
| ILAE  | ILAE_All_epilepsies  | http://www.epigad.org/gwas_ilae2014/  | 
| ILAE  | ILAE_Focal_epilepsy  | http://www.epigad.org/gwas_ilae2014/  | 
| ILAE  | ILAE_Genetic_generalised_epilepsy  | http://www.epigad.org/gwas_ilae2014/  | 
| IMMUNOBASE  | IMMUNOBASE_Celiac_disease_hg19  | https://www.immunobase.org/downloads/protected_data/GWAS_Data/  | 
| IMMUNOBASE  | IMMUNOBASE_Multiple_sclerosis_hg19  | https://www.immunobase.org/downloads/protected_data/GWAS_Data/  | 
| IMMUNOBASE  | IMMUNOBASE_Systemic_lupus_erythematosus_hg19  | https://www.immunobase.org/downloads/protected_data/GWAS_Data/  | 
| Jones  | Jones_Chronotype  | http://www.t2diabetesgenes.org/data/  | 
| Jones  | Jones_SleepDuration  | http://www.t2diabetesgenes.org/data/  | 
| Kilpelainen  | Kilpelainen_Leptin_Adjusted_for_BMI  | https://walker05.u.hpc.mssm.edu/  | 
| Kilpelainen  | Kilpelainen_Leptin_Not_Adjusted_for_BMI  | https://walker05.u.hpc.mssm.edu/  | 
| Lu Y  | LuY_BodyFat  | https://walker05.u.hpc.mssm.edu/  | 
| MAGIC  | MAGIC_HbA1C  | http://www.magicinvestigators.org/downloads/  | 
| MAGIC  | MAGIC_LN_FastingProinsulin  | http://www.magicinvestigators.org/downloads/  | 
| MAGIC  | MAGIC_Manning_et_al_FastingGlucose_Interaction  | http://www.magicinvestigators.org/downloads/  | 
| MAGIC  | MAGIC_Scott_et_al_FG  | http://www.magicinvestigators.org/downloads/  | 
| MAGIC  | MAGIC_Scott_et_al_FI_adjBMI  | http://www.magicinvestigators.org/downloads/  | 
| MAGIC  | MAGIC_ln_HOMA-B  | http://www.magicinvestigators.org/downloads/  | 
| MAGIC  | MAGIC_ln_HOMA-IR  | http://www.magicinvestigators.org/downloads/  | 
| RA_OKADA  | RA_OKADA_TRANS_ETHNIC  | http://plaza.umin.ac.jp/yokada/datasource/software.htm  | 
| ReproGen  | ReproGen_Menarche  | http://www.reprogen.org/data_download.html  | 
| ReproGen  | ReproGen_Menopause  | http://www.reprogen.org/data_download.html  | 
| SSGAC  | SSGAC_College  | http://ssgac.org/Data.php  | 
| SSGAC  | SSGAC_Education_Years  | http://ssgac.org/Data.php  | 
| Wood  | Wood_BMI  | http://www.t2diabetesgenes.org/data/  | 
| Wood  | Wood_T2D  | http://www.t2diabetesgenes.org/data/  | 
| Baranzini  | dbGAP_Baranzini_MultipleSclerosis  | https://www.ncbi.nlm.nih.gov/projects/SNP/gViewer/gView.cgi?aid=2861  | 
| COG  | dbGAP_COG_Neuroblastoma  | https://www.ncbi.nlm.nih.gov/projects/SNP/gViewer/gView.cgi?aid=2895  | 
| Duerr  | dbGAP_Duerr_InflammatoryBowelDisease  | https://www.ncbi.nlm.nih.gov/projects/SNP/gViewer/gView.cgi?aid=2847  | 
| Hom  | dbGAP_Hom_SystemicLupusErythematosus  | http://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/analysis.cgi?study_id=phs000501.v1.p1\ |pha=2848  | 
| Hunter  | dbGAP_Hunter_BreastCancer  | ftp://ftp.ncbi.nlm.nih.gov/dbgap/studies/phs000147/analyses/  | 
| ISGS  | dbGAP_ISGS_IschemicStroke  | http://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/analysis.cgi?study_id=phs000102.v1.p1\ |pha=2844  | 
| Li H  | dbGAP_LiH_Alzheimer  | http://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/analysis.cgi?study_id=phs000219.v1.p1\ |pha=2879  | 
| PGC  | pgc.adhd  | https://www.med.unc.edu/pgc/results-and-downloads  | 
| PGC  | pgc.aut.euro  | https://www.med.unc.edu/pgc/results-and-downloads  | 
| PGC  | pgc.bip.full.2012-04  | https://www.med.unc.edu/pgc/results-and-downloads  | 
| PGC  | pgc.mdd.full.2012-04  | https://www.med.unc.edu/pgc/results-and-downloads  | 
| PGC  | pgc.scz2  | https://www.med.unc.edu/pgc/downloads  | 
| TAG  | tag.cpd.tbl  | https://www.med.unc.edu/pgc/results-and-downloads  | 


## Dependencies

This project was developed with R:
```
R 3.4.2
#most of them installed via devtools
ggplot2   2.2.0
dplyr 0.7.2.9
readr 1.1.1.9000
tidyr   0.6.3
reshape2   1.4.2
knittr 1.2
```
You can check `r_packages.txt` for the full list of packages installed. Not all of them are necessary.

Python was used to compile images and data:
```
python 2.7
#
svgwrite
```

