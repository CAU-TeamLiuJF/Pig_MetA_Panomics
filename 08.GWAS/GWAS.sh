#!/bin/bash

# GWAS, Taking SNP as an example

gmatrix --bfile SNPcleanuseful --grm agrm --out G
uvlmm --bfile SNPcleanuseful --data data.txt \
      --grm G --trait t1 --class sex,batch --out result_t1