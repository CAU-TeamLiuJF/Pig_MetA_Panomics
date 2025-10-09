#!/bin/bash

### EVM gene model integration pipeline

EVidenceModeler \
  --weights weights.txt \
  --sample_id sample \
  --genome genome.fa \
  --gene_predictions augustus.gff3 \
  --protein_alignments gemoma.gff3 \
  --transcript_alignments pasa.gff3 \
  --segmentSize 950000 \
  --overlapSize 100000

# pasa update
# Step.1 First round of PASA update
Launch_PASA_pipeline.pl \
  --CPU 4 \
  -c annotCompare.config \
  -A \
  -g genome.fa \
  -t transcripts.fasta.clean \
  -T -u transcripts.fasta \
  -L --annots evm.gff3

# Step.2 Iterative PASA update
first_update_gff3=$(ls *gene_structures_post_PASA_updates*.gff3 -t | head -n 1)

Launch_PASA_pipeline.pl \
  --CPU 4 \
  -c annotCompare.config \
  -A \
  -g genome.fa \
  -t transcripts.fasta.clean \
  -T -u transcripts.fasta \
  -L --annots $first_update_gff3

second_update_gff3=$(ls *gene_structures_post_PASA_updates*.gff3 -t | head -n 1)

Launch_PASA_pipeline.pl \
  --CPU 16 \
  -c annotCompare.config \
  -A \
  -g genome.fa \
  -t transcripts.fasta.clean \
  -T -u transcripts.fasta \
  -L --annots $second_update_gff3

third_update_gff3=$(ls *gene_structures_post_PASA_updates*.gff3 -t | head -n 1)

# Step.3 Clean final PASA update
gff3_clear.pl --prefix evmPasa $third_update_gff3 > final.evmPasa.gff3


