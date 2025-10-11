#!/bin/bash

# index1
STAR \
    --runMode genomeGenerate \
    --genomeDir genome_index_dir \
    --genomeFastaFiles genome.fa \
    --outFileNamePrefix genome_index_dir/ \
    --limitGenomeGenerateRAM 240000000000 \
    --runThreadN 80

# mapping_1st
STAR \
    --genomeDir genome_index_dir \
    --readFilesIn sample_1.fq.gz sample_2.fq.gz \
    --sjdbOverhang 100 \
    --runThreadN 40 \
    --alignIntronMin 60 \
    --alignIntronMax 15000 \
    --alignMatesGapMax 2000 \
    --alignEndsType Local \
    --alignSoftClipAtReferenceEnds Yes \
    --outSAMprimaryFlag AllBestScore \
    --outFilterType BySJout \
    --outFilterMismatchNmax 0 \
    --outFilterMismatchNoverLmax 0.3 \
    --outFilterScoreMinOverLread 0.66 \
    --outFilterMatchNmin 0 \
    --outFilterScoreMin 0 \
    --outFilterMultimapNmax 15 \
    --outFilterIntronMotifs RemoveNoncanonical \
    --outFilterIntronStrands RemoveInconsistentStrands \
    --outSJfilterReads All \
    --outSJfilterCountUniqueMin -1 5 5 5 \
    --outSJfilterCountTotalMin -1 5 5 5 \
    --outSAMstrandField intronMotif \
    --outSAMtype BAM SortedByCoordinate \
    --alignTranscriptsPerReadNmax 30000 \
    --twopassMode None \
    --readFilesCommand zcat \
    --outReadsUnmapped Fastx \
    --outFileNamePrefix output_prefix_ \
    --outTmpDir tmp_dir \
    --alignSJoverhangMin 5 \
    --alignSJDBoverhangMin 3 \
    --outSJfilterOverhangMin -1 12 12 12 \
    --outFilterMatchNminOverLread 0.66 \
    --outFilterMismatchNoverReadLmax 1 \
    --alignSJstitchMismatchNmax 0 0 0 0

# index2
STAR \
    --runMode genomeGenerate \
    --genomeDir genome_index_dir_round2 \
    --genomeFastaFiles genome.fa \
    --outFileNamePrefix genome_index_dir_round2/ \
    --limitGenomeGenerateRAM 240000000000 \
    --sjdbFileChrStartEnd sj_all.txt \
    --runThreadN 120

# mapping_2nd
STAR \
    --runThreadN 120 \
    --genomeDir genome_index_dir_round2 \
    --readFilesIn sample_1.fq.gz sample_2.fq.gz \
    --outSAMtype BAM SortedByCoordinate \
    --outFileNamePrefix output_prefix_ \
    --readFilesCommand zcat \
    --outReadsUnmapped Fastx \
    --outSJfilterReads All \
    --outSJfilterCountUniqueMin -1 5 5 5 \
    --outSJfilterCountTotalMin -1 5 5 5 \
    --alignSJoverhangMin 5 \
    --alignSJDBoverhangMin 3 \
    --outSJfilterOverhangMin -1 12 12 12 \
    --alignSJstitchMismatchNmax 0 0 0 0 \
    --outSAMstrandField intronMotif \
    --outSAMattrIHstart 0

