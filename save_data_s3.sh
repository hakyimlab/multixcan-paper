#!/usr/bin/env bash

#save data to s3
tar --dereference -czvpf data.tar.gz data/
aws s3 cp data.tar.gz s3://imlab-members/alvaro/data/repro_sets/multi_tissue_paper_2017_12_08.tar.gz
rm data.tar.gz