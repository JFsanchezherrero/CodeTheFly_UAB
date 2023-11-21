
#!/bin/bash
helpFunction()
{
        echo
        echo "###############################################"
        echo "### fly-C script Usage:"
        echo "###############################################"
        echo "This script C creates the Tlex analysis using the previous SRAacc data retrieved"
        echo "It requires the your NIU or any unique ID you used before to check the folder generated with your results"
        echo "It also requires the length of the sequences obtained using fly-B script"
        echo
        echo "Usage: sh fly-C.sh -n NIU -i SRA -l num"
        echo "options:"
        echo "  -h       Optional: Print this help message"
        echo "  -n NIU   Unique ID identifier of each student"
        echo "  -i SRA   SRA ID identifying the dataset to obtain"
        echo "  -l num   Length of the sequences obtained in previous step B"
        echo
        exit
}

while getopts "i:n:l:" flag
do
    case "${flag}" in
        i) SRAacc=${OPTARG};;
        n) NIU=${OPTARG};;
        l) ReadLength=${OPTARG};;
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
echo "Length: $ReadLength";
echo "#------------------#"
echo ""
if [ -z "$SRAacc" ] || [ -z "$NIU" ] || [ -z "$ReadLength" ]; then
        echo 'Missing -n, -i or -l parameters' >&2
        helpFunction
fi

### Check folder exists
myDir=/data/codefly/scratch2/results/$NIU/$SRAacc/fastq_files/$SRAacc

if [ -d "$myDir" ]; then
        echo "Directory exists: SRAid and NIU seems ok!"
else
        echo "ERROR: Data directory does not exists!"
        echo
        echo "Check the SRAid and the NIU provided are the same as for fly-A script"
        exit
fi


### Move to directory and copy files necessary
MYDIR=/data/codefly/scratch2/results/$NIU/
cp -r $MYDIR/$SRAacc $_CONDOR_SCRATCH_DIR/
cd $_CONDOR_SCRATCH_DIR/$SRAacc

## Execute Tlex
docker run -t -v $_CONDOR_SCRATCH_DIR/$SRAacc:/data mctf/tlex -O $SRAacc -pairends yes -A $ReadLength -T /data/TElist_1630_v6.04.txt -M /data/TEcopies_1630_v6.04.txt -G /data/dmel-all-chromosome-r6.04.fa -R /data/fastq_files
cp -r ./tlex* $MYDIR/$SRAacc/

elapsedseconds=$SECONDS
echo "Job took: "
TZ=UTC0 printf '%(%H:%M:%S)T\n' "$elapsedseconds"
