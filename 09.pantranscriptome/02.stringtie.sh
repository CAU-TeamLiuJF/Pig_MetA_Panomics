#!/bin/bash

stringtie input.bam \
    -o output/Stringtie_output.gtf \
    -a 10 \
    -c 2.5 \
    -f 0 \
    -g 50 \
    -j 0.1 \
    -M 1 \
    -p 40

