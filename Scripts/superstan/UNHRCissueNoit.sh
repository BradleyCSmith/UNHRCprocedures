#!/bin/bash

#NOTE: Make sure to set the present working directory to the folder that
#    contains this sbatch file (e.g. /scratch/gjudd/UNHRC). Open the
#    terminal using "Applications>SystemTools>Terminal", then enter the command:
#    cd "/scratch/gjudd/UNHRC/Scripts"

# Name the job.
#SBATCH -J UNHRC

# Set the partition type to standard.
#SBATCH -p standard

#Set the name of the output file to outputnameJOBNUMBER
#    This output file updates as the job progresses.  It displays
#    the output shown in the Command Window in the Matlab GUI.
#SBATCH -o outname%j

#Set the number of nodes to 1.
#SBATCH -N 1 

#Set the number of cores per node to 12.
#SBATCH --ntasks-per-node=12

#Set the memory amount per cpu.
#SBATCH --mem-per-cpu=1GB

#Set the time limit to 5 days (this is the maximum allowable)
#SBATCH -t 5-00:00:00

#Get e-mail alerts for job activity.
#SBATCH --mail-type=All

#Start R version 3.1.0 b2
module load r/3.1.0/b2


#     The workspace variables are stored in 
#     UNHRCfit.RData

R --save <  superstan_issue_noit.R 