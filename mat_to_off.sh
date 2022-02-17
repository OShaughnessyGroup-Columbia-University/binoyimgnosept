#!/bin/sh
#
# Simple Matlab submit script for Slurm.
#
#
#SBATCH -A cheme                 # The account name for the job.
#SBATCH -J matToOff              # The job name.
#SBATCH -t 2:00:00               # The time the job will take to run.
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4gb        # The memory the job will use per cpu core.

module load matlab/2018b

# Program to automate septum formation in rings with a uniform septum
#matlab script to generate off files for each matfile
matlab -nosplash -nodisplay -nodesktop -r "mat_to_off;quit"
