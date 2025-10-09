#!/bin/bash

### gap-filling

# verkko 
verkko -d asm \
  --hifi hifi/*.fastq.gz \
  --nano ont/*.fastq.gz 

# ragtag
ragtag.py correct ref.fasta query.fasta
ragtag.py scaffold ref.fasta query.fasta
ragtag.py patch target.fa query.fa

