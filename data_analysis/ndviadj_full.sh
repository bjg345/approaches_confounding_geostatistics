#!/bin/bash
#$ -l mem_free=15G
#$ -pe local 16
#$ -l h_vmem=15G
#$ -l h_rt=360:00:00
#$ -cwd
#$ -j y
#$ -R y
module load conda_R
Rscript ndviadj_full.R
