#!/bin/sh
#
# Simple Matlab submit script for Slurm.
#

mkdir -p png log tcl
# End of script# looping through all files with format .mat in current directory
for file in *.mat
do

#variable for file name
FNAME="$file" 
FNAME=${FNAME/.mat/}

jid1=$(sbatch -A cheme -J vis_1 -t 3:00:00 --cpus-per-task=1 --mem-per-cpu=20gb task_binoy_6_subroutine.sh $FNAME)

done
