#!/bin/bash
#$ -l h_vmem=7.5G
#$ -l mem_free=7.5G
#$ -l h_rt=360:00:00
#$ -cwd
#$ -j y
#$ -R y
module load conda_R
Rscript normalize.R
