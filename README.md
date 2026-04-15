# Pig_MetA_Panomics

## 📌 Overview

This repository provides analysis pipelines for pig multi-omics integration, including genome assembly, annotation, pangenome construction, structural variation (SV) detection, and downstream genetic analyses.



## ⚠️ Note

Some scripts were adapted based on the configuration of the High-Performance Computing (HPC) platform at China Agricultural University.

Please modify:
- file paths  
- software environments (e.g., module load / conda)  
- computational resources  

before running the pipelines on your system.



## 📁 Directory Structure
- **01.assembly/**  
  Genome assembly: HiFi assembly, Hi-C scaffolding, gap filling, polishing.

- **02.annotation/**  
  Genome annotation: TE prediction, gene annotation, EvidenceModeler integration.

- **03.chipseq/**  
  ChIP-seq processing: alignment, deduplication, peak calling.

- **04.hicplot/**  
  Hi-C analysis: contact matrix construction and visualization.

- **05.SV/**  
  Structural variation detection: alignment and SV calling.

- **06.graph_pangenome/**  
  Graph pangenome: construction, comparison, benchmarking, growth analysis.

- **07.heritability/**  
  Heritability estimation: SNP weighting, kinship matrix, REML.

- **08.GWAS/**  
  GWAS analysis: GRM construction and association testing.

- **09.pantranscriptome/**  
  Pan-transcriptome: RNA-seq alignment and transcript assembly.

- **10.orthofinder/**  
  Ortholog analysis: cross-species gene clustering.
