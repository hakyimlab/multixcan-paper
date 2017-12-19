#!/usr/bin/env bash

#save data to s3
wget s3://imlab-members/alvaro/data/repro_sets/multi_tissue_paper_2017_12_19.tar.gz
tar -xzvpf multi_tissue_paper_2017_12_19.tar.gz
rm multi_tissue_paper_2017_12_19.tar.gz