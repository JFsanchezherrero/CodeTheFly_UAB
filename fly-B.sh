#!/bin/bash
helpFunction()
{
        echo
        echo "###############################################"
        echo "### fly-B script Usage:"
        echo "###############################################"
        echo "This script B counts the sequence length of the SRAacc ID retrieved"
        echo "It requires the your NIU or any unique ID you used before to check the folder generated with your results"
        echo
        echo "Usage: sh fly-B.sh -n NIU -i SRA"
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
echo "Job started at: "$current_time


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

### Check folder exists
myDir=/data/codefly/scratch/results/$NIU/$SRAacc/fastq_files

if [ -d "$myDir" ]; then
        echo "Directory exists: SRAid and NIU seems ok!"
else
        echo "ERROR: Data directory does not exists!"
        echo
        echo "Check the SRAid and the NIU provided are the same as for fly-A script"
        exit
fi

cd $myDir
echo "Statistics for sequencing reads downloaded"
stats=`head -10000000 *_1.fastq | awk '{if(NR%4==2) print length($1)}' | sort | uniq -c`
stats_string=(${stats//\t/})
echo "      - First " ${stats_string[0]} " checked"
echo "      - Length:" ${stats_string[1]}

elapsedseconds=$SECONDS
echo "Job took: "
TZ=UTC0 printf '%(%H:%M:%S)T\n' "$elapsedseconds"
