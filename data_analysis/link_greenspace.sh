#!/bin/bash
#$ -l h_vmem=10G
#$ -l mem_free=10G
#$ -l h_rt=360:00:00
#$ -cwd
#$ -j y
#$ -R y
module load conda_R
Rscript link_greenspace.R
