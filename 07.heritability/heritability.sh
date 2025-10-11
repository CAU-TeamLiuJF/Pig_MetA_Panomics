#!/bin/bash

# Heritability estimates, Taking SNP as an example

ldak --bfile SNPclean --allow-multi YES --cut-weights snp --window-prune 0.98 --section-length 100
ldak --bfile SNPclean --allow-multi YES --calc-weights-all snp
ldak --bfile SNPclean --allow-multi YES --calc-kins-direct snp/LDAK-Thin \
     --weights snp/weights.all --power -0.5
ldak --pheno PHE.txt --covar COV0.txt --mpheno 1 \
     --mgrm SNP.All --reml result_snp --constrain YES