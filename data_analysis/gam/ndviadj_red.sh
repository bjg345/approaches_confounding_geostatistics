#!/bin/bash
#$ -l mem_free=10G
#$ -pe local 8
#$ -l h_vmem=10G
#$ -l h_rt=360:00:00
#$ -cwd
#$ -j y
#$ -R y
module load conda_R
Rscript ndviadj_red.R
