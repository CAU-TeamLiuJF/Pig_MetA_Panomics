#!/bin/bash

orthofinder -f input_proteomes_dir \
            -a 120 \
            -t 120 \
            -T iqtree \
            -M msa
