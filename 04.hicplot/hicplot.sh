#!/bin/bash

# hicpro
bowtie2-build genome.fa ./bowtie2_index/genome --threads 56
digest_genome.py -r ^GATC -o genome.DpnII.bed genome.fa
HiC-Pro --input ./rawdata --output hicpro_out --conf config-hicpro.txt

# hicexplorer
hicConvertFormat \
    --matrices raw_or_iced_matrix.h5 \
    --bedFileHicpro raw.bed \
    --inputFormat hicpro \
    --outputFormat h5 \
    --outFileName converted_matrix.h5

hicCorrectMatrix correct \
    -m iced_matrix.h5 \
    --filterThreshold -1.5 5 \
    -o corrected_matrix.h5

hicPlotMatrix \
    -m corrected_matrix.h5 \
    -o matrix_plot.pdf \
    --log1p \
    --clearMaskedBins \
    --region chr:start-end

hicPCA \
    -m corrected_matrix.h5 \
    --numberOfEigenvectors 2 \
    --outputFileName pca1.bw pca2.bw

hicFindTADs \
    -m pearson_matrix.h5 \
    --outPrefix TADs_output_prefix \
    --numberOfProcessors 16 \
    --correctForMultipleTesting fdr

hicPlotTADs \
    --tracks pygenometracks.ini \
    -o TADs_plot.png \
    --region chr:start-end

