#!/bin/bash

### de novo prediction pipeline

# genemark
# Gene prediction with GeneMark-ET
gmes_petap.pl --sequence genome.fa.masked \
  --ET braker/genemark_hintsfile.gff \
  --et_score 4 --cores 16

# augustus
# Gene prediction using Augustus

# Step.1 prepare training set
gff2gbSmallDNA.pl transcripts.singlecopy.gff3 genome.fa.masked 1000 trainingSetRaw.gb
new_species.pl --species=sample.sc3

# Step.2 Initial training
etraining --species=generic --stopCodonExcludedFromCDS=false trainingSetRaw.gb 2> train.err
cat train.err | perl -ne 'print "$1\n" if /in sequence (\S+):/' > badlist
filterGenes.pl badlist trainingSetRaw.gb > trainingSetFiltered.gb

# Step.3 Split and retrain
randomSplit.pl trainingSetFiltered.gb 200
etraining --species=sample.sc3 trainingSetFiltered.gb.train > train.out
augustus --species=sample.sc3 trainingSetFiltered.gb.test > test.out
optimize_augustus.pl --species=sample.sc3 --rounds=5 --cpus=16 trainingSetFiltered.gb.train


# Step.4 Generate hints
bam2hints --in=rnaseq.merged.bam --out=hints.intron.gff \
  --maxgenelen=300000 --intronsonly --source="W"

# Step.5 Final prediction with hints
augustus \
  --gff3=on \
  --species=sample.sc3 \
  --hintsfile=hints.gff \
  --extrinsicCfgFile=extrinsic.cfg \
  --allow_hinted_splicesites=gcag,atac \
  --min_intron_len=30 \
  --alternatives-from-evidence=true \
  --progress=true \
  --softmasking=1 \
  genome.fa.masked > augustus_hints.out

# glimmerhmm
# Convert GlimmerHMM output to EVM-compatible GFF3

glimmerHMM_to_GFF3.pl \
  sample.glimmerhmm.gff > sample.glimmerhmm.evm.gff


