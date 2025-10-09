#!/bin/bash

python RTDmaker.py ShortReads \
    --assemblies stringtie_or_scallop_dir \
    --SJ-data star_merge_pass2_dir \
    --genome genome.fa \
    --fastq fastq_dir \
    --SJ-reads 2 1 \
    --tpm 1 1 \
    --fragment-len 0.7 \
    --antisense-len 0.5 \
    --add uniform \
    --ram 8 \
    --outpath output_dir \
    --outname SAMPLE \
    --prefix SAMPLE \
    --keep intermediary
