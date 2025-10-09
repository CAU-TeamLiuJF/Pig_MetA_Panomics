#!/bin/bash

### RepeatModeler + RepeatMasker pipeline

# Step.1
# build repeat library
BuildDatabase -name genome genome.fa
RepeatModeler -database genome -threads 110

# extract unknown and identified reapeats
seqkit grep -nrp Unknown consensi.fa.classified > Modelerunknown.lib
seqkit grep -vnrp Unknown consensi.fa.classified >  ModelerID.lib
 
# classify unknown and identified repeats
TEclassTest.pl Modelerunknown.lib

# Process TEclass results
less Modelerunknown.lib.lib|sed 's/, Localized to 24 out of 25 contigs//g' > Modelerunknown.lib.lib2
cat Modelerunknown.lib.lib2| awk '/^>/ {split($16,a,"|");split($1,b,"#");print b[1]"#"a[1];next}{print $0}' >  Modelerunknown.lib.lib3
sed 's/unclear/Unknown/g' Modelerunknown.lib.lib3 > Modelerunknown.lib.lib4

# Merge identified and classified unknown repeats into a custom repeat library
cat ModelerID.lib Modelerunknown.lib.lib4 > genome.modeler.fa

# Step.2
# Run RepeatMasker with custom library
RepeatMasker -e ncbi -pa 110 \
  -lib genome.modeler.fa \
  -dir repeatmask_custom \
  -gff -no_is -xsmall genome.fa

# Run RepeatMasker with species-specific option (example: pig)
RepeatMasker -pa 110 -e ncbi \
  -species pig \
  -dir repeatmask_sp2 \
  -gff -no_is -xsmall genome.fa
