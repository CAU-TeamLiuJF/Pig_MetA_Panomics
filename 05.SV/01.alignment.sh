#!/bin/bash

# Minimap2
minimap2 -t 30 -ax asm5 --eqx reference_genome.fa query_genome.fa > genome_2_ref.sam

# nucmer
nucmer -t 100 -g 1000 -c 90 -l 40 reference_genome.fa query_genome.fa -p output
delta-filter -1 output.delta > output.filter.delta


