#!/bin/bash

helpFunction()
{
        echo
        echo "###############################################"
        echo "### fly-A script Usage:"
        echo "###############################################"
        echo "This script A retrieves the SRAacc ID provided from NCBI SRA database"
        echo "to the server. It requires your NIU or any unique ID to create a folder to storee your results"
        echo
        echo "Usage: sh fly-A.sh -n NIU -i SRA"
        echo "options:"
        echo "  -h       Optional: Print this help message"
        echo "  -n NIU   Unique ID identifier of each student"
        echo "  -i SRA   SRA ID identifying the dataset to obtain"
        echo
        exit
}

while getopts "i:n:" flag
do
    case "${flag}" in
        i) SRAacc=${OPTARG};;
        n) NIU=${OPTARG};;
        *) helpFunction;; ## prints help if other option
    esac
done
shift "$(( OPTIND - 1 ))"

SECONDS=0
current_time=$(date "+%Y.%m.%d_%H.%M.%S")

echo ""
echo ""
echo "###############################"
echo "Job started at: "$current_time
echo "###############################"
echo ""


echo "#------------------#"
echo "Parameters provided:"
echo "#------------------#"
echo "SRA: $SRAacc";
echo "NIU: $NIU";
echo "#------------------#"
echo ""
if [ -z "$SRAacc" ] || [ -z "$NIU" ]; then
        echo 'Missing -n or -i parameters' >&2
        helpFunction
fi

###############################################
## Prepare the data and folders
###############################################
echo
echo "#---------------------------#"
echo " Start the processing"
echo "#---------------------------#"

## apptainer image
IMAGE=/data/codefly/scratch/apptainer/sra-tools.sif

## create directory in scratch partition disk
MYDIR=/data/codefly/scratch/results/$NIU

if [ -d "$MYDIR" ]; then
        echo "Directory exists for this NIU id!"
else
        echo "# Create a directory"
        echo $MYDIR
        mkdir $MYDIR
fi

### Check folder exists
mySRA_Dir=/data/codefly/scratch/results/$NIU/$SRAacc/fastq_files/$SRAacc

if [ -d "$mySRA_Dir" ]; then
        echo "Directory exists for: SRAid and seems ok!"
        echo "Exiting job"
        exit
fi

# Create directory for your sample
echo "Change to directory path where computation occurs:"
cd $_CONDOR_SCRATCH_DIR

## create a directory within to store fastq
echo ""
echo "# Create a directory to store the FASTQ files and change to it"
mkdir -p $SRAacc/fastq_files
cd $SRAacc/fastq_files

###############################################
## Get files
###############################################
echo "# Run SRAtools using apptainer"

echo "## Pre-fecth SRA id"
apptainer run $IMAGE prefetch $SRAacc
# Run a second time if the first one fails
if [ $? -ne 0 ]; then
  apptainer run $IMAGE prefetch $SRAacc
fi

echo "# Validate SRA id obtained"
apptainer run $IMAGE vdb-validate $SRAacc

echo "# Create FASTQ file from file downloaded"
apptainer run $IMAGE fasterq-dump $SRAacc --split-files --split-3
###############################################

###############################################
## Copy files and finish
###############################################
echo "# Copy files and finish"
cp -r $_CONDOR_SCRATCH_DIR/$SRAacc $MYDIR/

echo "# Check folder for results in: $MYDIR"
echo ""

elapsedseconds=$SECONDS
echo "Job took: "
TZ=UTC0 printf '%(%H:%M:%S)T\n' "$elapsedseconds"
echo ""
