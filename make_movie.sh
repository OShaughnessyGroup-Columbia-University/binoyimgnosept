#!/bin/sh
#
# Simple Matlab submit script for Slurm.
#
#
#SBATCH -A cheme                 # The account name for the job.
#SBATCH -J makeMovie       # The job name.
#SBATCH -t 00:20:00                  # The time the job will take to run.
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=3gb        # The memory the job will use per cpu core.
#SBATCH --array=1

module load matlab
# running movie making script to stitch all images together to make a .avi video file
matlab -nosplash -nodisplay -nodesktop -r "make_movie1('png/selfass_${SLURM_ARRAY_TASK_ID}_','png/selfass_${SLURM_ARRAY_TASK_ID}.avi');quit"
