# CodeTheFly at UAB using PIC Cluster computer
Bioinformatics practical session on how to work in the CodeTheFly project

**Melanogaster: Code the fly!** is part of the citizen science project **Melanogaster: Catch the Fly!**. Both offer citizens a first contact with scientific research through
- the collection and classification of fly samples in arid zones of Europe (Catch the Fly),
- or the bioinformatic analysis of massive genomic data (Code the Fly).

**In Melanogaster: Code the Fly!** you will analyze genomic data to estimate the frequency of transposable element (TE) insertions in the fruitfly Drosophila melanogaster. By uploading your data into the Code the Fly platform, you will contribute to the research of the European research consortia DrosEU. This tutorial contains some of the necessary information and code lines to guide your participation in the project.

Read additional information in here: 
- https://codethefly.omicsuab.org/
- https://melanogaster.eu/
- https://droseu.net/

In this github repository I have included the files for the submission of jobs for the analysis of transposon in Drosophila melanogaster.

## Material and Methods

For the development of this practical session you require access to computer power, genomic D. melanogaster sequencing samples and several scripts executiong guidelines.

### Computer power 

We will be using a computing server to the heavy analysis. This computer Server PIC (Port d'Informació científica) is located in Edifici D, Campus UAB and it is included a net of computer server in Spain.

Read additional details here: 
- https://www.pic.es/pic-included-in-the-updated-icts-map/ 
- https://www.pic.es/areas/
- https://www.pic.es/projects/ 

Once you log in to the server, ask teacher for additional details on how to access, there are already several scripts prepared to execute and produce the results. See additional details below.

### Samples
Samples are already collected, sequenced and available from the **Melanogaster Catch the Fly!** project. Samples are deposited in the SRA database: https://www.ncbi.nlm.nih.gov/sra

SRA database is the largest publicly available repository of NGS data. It accepts data from all branches of life as well as metagenomic and environmental surveys and it stores raw sequencing data and alignment information to enhance reproducibility and facilitate new discoveries through data analysis.

To get a valida SRAid you can go to the https://codethefly.omicsuab.org/, in the tab collaborate there tones of SRAs ids to use. You will find that each entry can have a different status: 0-3 according to the number of people that have successfully submit results and have been validated

![image](https://github.com/JFsanchezherrero/CodeTheFly_UAB/assets/20244642/7b34d6c1-5d4f-4b4d-a2a6-16f9f2bb9db9)

### Scripts

Once you log in to the server, ask teacher for additional details on how to access, there are already several scripts prepared to execute and produce the results.

There are three types of scripts prepare:
- HTCondor submission:
- Random SRA selector
- fly-X.sh files:

#### HTCondor submission file

A very important file is the one that configures the submission of jobs. You are going to submit your first job to a batch system, a queue that manages the order and the preference of execution of several tasks. It takes your commands and sends them to a remote machine where your commands are really executed.

Read further details about the queue system here: https://htcondor.readthedocs.io/en/latest/ 

The batch system software is called HTCondor and the configuration file that allows us to submit jobs to the cluster is named as: [`HTCondor_sender.sub`](./HTCondor_sender.sub) and available in this repository.

This file `HTCondor_sender.sub` contains some configuration but also requires additional arguments to be supplied during execution such as: executable, arguments or append. 

An example of job submissions might be:

```
condor_submit HTCondor_sender.sub executable=”example.sh” 
condor_submit HTCondor_sender.sub executable=”example.sh” arguments=”-n 1” 
condor_submit HTCondor_sender.sub executable=”example.sh” arguments=”-n 1” append=”example”
```
Each job submitted will be assigned a job ID after submission. This job ID (or ClusterID) will help you to check the status using condor_q.	

This job ID (or ClusterID) will help you to check the status using condor_q. Using the jobID you can also remove the jobID by using condor_rm.
Once the job is finished, you can see the output generated in the log/ folder. You should look for files in the log folder named with termination as log, err and output containing submission log details, error or output generated. 

Files would be something like this:
- jobID-XYZ_SRAid_ABC_scriptID_EXE.log
- jobID-XYZ_SRAid_ABC_scriptID_EXE.err
- jobID-XYZ_SRAid_ABC_scriptID_EXE.out

Where:
- XYZ is the jobID generated in the submission
- ABC is the unique identifier provided via append argument
- EXE is the executable.


####  Select a random SRA id

The first step of the analysis is to select a random SRA id entry. Here, we are going to call the [`SRA_selector.py`](./SRA_selector.py) script with a bunch of selected SRAids (available in [`SRAids.txt`](./SRAids.txt)). 

The [`SRA_selector.py`](./SRA_selector.py) is a python script that reads the SRAids.txt file that contains a selection of SRA ids and randomly selects one for you. This script uses the `random` python package to select a random entry in the list obtained from the file.

On our computer, we could just execute the script by doing 
```
python SRA_selector.py
```
but due to the configuration of the cluster at PIC, we need to submit the job to an execution host. To do so, we will use the `HTCondor_sender.sub` and name SRA_selector.py as an argument, in this case, named as executable.

To submit the job, in the directory you created that contains the script files type:

```
# submit SRA_selector.py
condor_submit HTCondor_sender.sub executable=”SRA_selector.py”
```

This submission will produce a jobID. Use this jobID to and to find if the job is running, execute the following command condor_q with your jobID obtained:

```
# check job status
condor_q jobID
```
Once the job is finished, inspect the log, output and error files generated by the submission in a log/ folder available within your path, if not, you should created first.

These files contain also the jobID submitted and as scriptID the name `SRA_selector.py`.

By inspecting the output file (jobID.*out) you see a message similar to:

```
###################################
## Script to randomly select SRAids
###################################

 + Read SRAids file...

+ List of available SRAs contains:
  55 entries

+ Random choice...

#----------------------------#
Your SRA id assigned is: SRR202127
#----------------------------#

```
In the example, the SRA id assigned has been: SRR202127. You can access the https://www.ncbi.nlm.nih.gov/sra and find additional details on your ID and access the Code The Fly website for additional information too (https://codethefly.omicsuab.org/)


#### fly-X scripts

Once you have an SRA id assigned to you, you will be able to start the analysis by downloading and validating the dataset to later process it. The steps are:
- Firts, you need to use the fly-A.sh file that contains the instructions to download and validate the SRA id dataset.
- Then, fly-B.sh will obtain the read length and
- finally fly-C.sh will call Tlex software to create the identification of transposons.

##### fly-A.sh script

We can call it in the terminal to see additional information. Just type: `$ sh fly-A.sh`

```
###############################################
### fly-A script Usage:
###############################################
This script A retrieves the SRAacc ID provided from NCBI SRA database
to the server. It requires your NIU or any unique ID to create a folder to storee your results

Usage: sh fly-A.sh -n NIU -i SRA
options:
  -h       Optional: Print this help message
  -n NIU   Unique ID identifier of each student
  -i SRA   SRA ID identifying the dataset to obtain
```

This script contains several lines that:
- Control the arguments provided
- Control the job is not previously done
- Prepare the job: move to the appropriate folder in the execution host computer
- Copy necessary files and unzips them

See details of the code in the [fly-A.sh](./fly-A.sh) file within this repository.

Again, due to the configuration of the server we need to produce a submission using the HTCondor system. fly-A.sh requires the SRAid and a unique identifier, that could you DNI, NIF, NIU, etc. As an example:

```
fly-A.sh -n 123456 -i SRR202127
```

When we submit the job through the HTCondor system, we type something like the following line, where we include 
- arguments to pass to fly-A.sh ("-n 123456 -i SRR202127")
- name ID to append to the log: unique ID, NIF, DNI, NIU (e.g. 123456)
- script to execute: fly-A.sh

```
HTCondor_sender.sub executable="fly-A.sh" arguments="-n 123456 -i SRR202127" append="123456"
```

Adapt the previous command with your NIU and SRA id assign and submit the HTCondor submission. Again, when you submit, a new jobID will be generated. Check your job status using:
```
# check job status
condor_q jobID
```

If it was successfully submitted this script might take from a few minutes to 1-1.30h. It depends on the dataset, the node and internet connection. This script calls the software sra-tools , that connects and allows to interact with the SRA database 

Some important lines at the end of the fly-A.sh are the following:

```
###############################################
## Get files
###############################################
echo "# Run SRAtools using docker"

echo "## Pre-fecth SRA id"
docker run -t --rm -v $_CONDOR_SCRATCH_DIR/$SRAacc/fastq_files/$SRAacc:/output:rw -w /output ncbi/sra-tools prefetch $SRAacc

echo "# Validate SRA id obtained"
docker run -t --rm -v $_CONDOR_SCRATCH_DIR/$SRAacc/fastq_files/$SRAacc:/output:rw -w /output ncbi/sra-tools vdb-validate $SRAacc

echo "# Create FASTQ file from file downloaded"
docker run -t --rm -v $_CONDOR_SCRATCH_DIR/$SRAacc/fastq_files/$SRAacc:/output:rw -w /output ncbi/sra-tools fasterq-dump $SRAacc --split-files --split-3
###############################################
```



##### fly-B.sh script
a

##### fly-C.sh script
a

## Results
a

