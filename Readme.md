# MultiTissue analysis paper

# Dependencies

This project was developed with:

```
R 3.4.2
#most of them installed via devtools
ggplot2   2.2.0
dplyr 0.7.2.9
readr 1.1.1.9000
tidyr   0.6.3
reshape2   1.4.2
```
You can check `r_packages.txt` for the full list of packages installed. Not all of them are necessary.


In order to use this code, you should first run at this project's root folder:

```
bash get_data.sh
```

Then you can run the `.Rmd` markdown files in order. They are mostly wrappers for running the analysis, but for `02_Spotlight.Rmd` and `03_UKB_Spotlight.Rmd` that features some data listing used in the paper.

Finally, run:

```
#compiles figures and supplementary data
./paper_material.py
```
This will produce a folder with all the products used for the Multi-Tissue paper.

# Note on data sources

Data was generated mostly from runs on Gardner. 
Some scripts in this repo acquired data from other repositories or SQL databases (`_do_misc.R` and `_download_gene2pheno.R`).

`save_data_s3.sh` saved the necessary data to Amazon S3
