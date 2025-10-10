#!/bin/bash

verkko -d asm \
  --hifi hifi/*.fastq.gz \
  --nano ont/*.fastq.gz 

ragtag.py patch target.fa query.fa

