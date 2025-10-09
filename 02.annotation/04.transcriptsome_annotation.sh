#!/bin/bash

### Transcriptome-assisted genome annotation pipeline

# RNA-seq
# Step.1 Index genome for RNA-seq alignment
hisat2-build -p 16 genome.fa genome

# Step.2 
# RNA-seq mapping
hisat2 --dta -p 16 -x genome \
  -1 sample/sample_1.clean.fq.gz \
  -2 sample/sample_2.clean.fq.gz \
  | samtools sort -@ 16 -o sample.bam

# multiple RNA-seq samples, map each separately and merge
samtools merge -@ 16 merged.bam sample1.bam sample2.bam sample3.bam

# Step.3
# Transcript assembly
stringtie -p 16 -o merged.gtf merged.bam

# Compare with reference isoforms
gffcompare merged.gtf reference_isoforms.gtf -o compare

# Step.4 Extract transcript sequences & ORF prediction
gtf_genome_to_cdna_fasta.pl merged.gtf genome.fa > transcripts.fasta

# Step.5 
Trinity --seqType fq \
  --left trans_R1.fq.gz \
  --right trans_R2.fq.gz \
  --CPU 16 --max_memory 100G \
  --output trinity_out

# Step.6 Homology-based gene annotation with GeMoMa
java -jar GeMoMa-1.9.jar CLI ERE \
  m=sample1.bam \
  m=sample2.bam \
  outdir=gemoma_out

# Step.7 Gene prediction with BRAKER
braker.pl --cores 16 --species=genome_species \
  --genome=genome.fa.masked \
  --softmasking --bam=merged.bam --gff3

# Step.8 Gene prediction with GeneMark-ET
gmes_petap.pl --sequence genome.fa.masked \
  --ET braker/genemark_hintsfile.gff \
  --et_score 4 --cores 16

# Iso-Seq 
# Step.1 Generate CCS reads
ccs sample.subreads.bam sample.ccs.bam \
  -j 16 --minPasses 1 --min-rq 0.9

# Step.2 Primer removal with lima
lima sample.ccs.bam primers.fa sample.lima.bam \
  --isoseq --peek-guess -j 16

# Step.3 Full-length non-chimeric reads
isoseq3 refine sample.lima.primer_5p--primer_3p.bam \
  primers.fa sample.flnc.bam -j 16

# Step.4 Convert
bamtools convert -format fasta -in sample.flnc.bam > sample.flnc.fa

# Step.5 PolyA cleanup
python tama_flnc_polya_cleanup.py \
  -f sample.flnc.fa \
  -p sample.rmploya

# Step.6 Align to reference genome
minimap2 -ax splice -t 16 -uf --secondary=no -C5 \
  genome.fa sample.rmploya.fa > sample.rmploya.sam
sort -k 3,3 -k 4,4n sample.rmploya.sam > sample.rmploya.sort.sam

# Step.7 Collapse isoforms
collapse_isoforms_by_sam.py \
  --input sample.rmploya.fa \
  -s sample.rmploya.sort.sam \
  -c 0.95 -i 0.99 \
  --dun-merge-5-shorter \
  -o cupcake
gffread cupcake.collapsed.gff -T -o cupcake.collapsed.gtf

###  pasa 
# Step.1 Prepare PASA database
accession_extractor.pl transcripts.fasta > tdn.accs
seqclean transcripts.fasta -v /path/to/UniVec
Launch_PASA_pipeline.pl \
  -c alignAssembly.config \
  --trans_gtf transcripts.gtf \
  --TDN tdn.accs \
  -C -R \
  -g genome.fa \
  -t transcripts.fasta.clean \
  -T -u transcripts.fasta \
  --ALIGNERS blat \
  --CPU 8

# Step.2 Convert PASA results into training set
pasa_asmbls_to_training_set.dbi \
  --pasa_transcripts_fasta pasa.sqlite.assemblies.fasta \
  --pasa_transcripts_gff3 pasa.sqlite.pasa_assemblies.gff3
pasa_asmbls_to_training_set.extract_reference_orfs.pl \
  pasa.sqlite.assemblies.fasta.transdecoder.gff3 > best_candidates.gff3

# Step.3 Convert GFF → GTF → fasta
agat_convert_sp_gff2gtf.pl \
  --gff best_candidates.gff3 \
  -o best_candidates.gtf
gtf_genome_to_cdna_fasta.pl \
  best_candidates.gtf \
  pasa.sqlite.assemblies.fasta > best_candidates.fasta

# Step.4 Cluster proteins with cd-hit
cd-hit \
  -i pasa.sqlite.assemblies.fasta.transdecoder.pep \
  -o pasa.sqlite.assemblies.fasta.transdecoder.pep.cdhit \
  -c 0.7 -M 100000 -d 0 -T 8

# Step.5 Extract CDS for single-copy genes
python extract_cds_gff.py \
  -g pasa.sqlite.assemblies.fasta.transdecoder.genome.gff3 \
  -l singlecopy.list \
  -o pasa.sqlite.assemblies.fasta.transdecoder.cdhit.gff3.singlecopy


