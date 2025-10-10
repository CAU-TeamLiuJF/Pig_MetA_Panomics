#!/bin/bash

Assemblytics output.filter.delta output_prefix 10000 50 10000

run-dipcall prefix ref.fa sample.fa sample.fa > prefix.mak
run-dipcall -x ref.PAR.bed prefix ref.fa sample.fa sample.fa > prefix.mak
make -j2 -f prefix.mak

sawriter ref.fasta
snakemake -s Snakefile -w 50 -p -k -j 20

svmu output.filter.delta reference_genome.fa query_genome.fa h null prefix

syri -c output_Chr.sam \
     -r ref_Chr.fa \
     -q sample_Chr.fa \
     -k -F S \
     --nc 19 \
     --dir output \
     --prefix prefix

SURVIVOR merge sample.txt 1000 2 1 0 0 50 sample.vcf
SURVIVOR merge 31_sample.txt 50 1 0 0 0 0 31_sample.vcf

