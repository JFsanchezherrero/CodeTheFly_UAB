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

If we submit the job through the HTCondor system, we type something like the following line, where we include 
- arguments to pass to fly-A.sh ("-n 123456 -i SRR202127")
- name ID to append to the log: unique ID, NIF, DNI, NIU (e.g. 123456)
- script to execute: fly-A.sh

```
HTCondor_sender.sub executable="fly-A.sh" arguments="-n 123456 -i SRR202127" append="123456"
```

If it was successfully submitted this script might take from a few minutes to 1-1.30h. It depends on the dataset, the node and internet connection. This script calls the software sra-tools , that connects and allows to interact with the SRA database.


##### fly-B.sh script
Now, we will execute fly-B.sh in order to get the length of the reads, necessary for the next step.

You need to use the fly-B.sh file that contains the instructions to create the analysis. We can call it in the terminal to see additional help and information. 

We can call it in the terminal to see additional information. Just type: `$ sh fly-A.sh`

```
###############################################
### fly-B script Usage:
###############################################

This script B counts the sequence length of the SRAacc ID retrieved
It requires the your NIU or any unique ID you used before to check the folder generated with your results


Usage: sh fly-B.sh -n NIU -i SRA
options:
  -h       Optional: Print this help message
  -n NIU   Unique ID identifier of each student
  -i SRA   SRA ID identifying the dataset to obtain
```

This script contains several lines that:
- Control the arguments provided
- Control the job is not previously done
- Prepare the job: move to the appropriate folder in the execution host computer
- Checks the first 10.000.000 sequences and count the length of the sequence

See details of the code in the fly-B.sh file within the github repository.

As in the previous step, if we need to submit via HTCondor system. Again, we need to provide arguments, append the name and provide the executable. 
- script to execute: fly-B.sh
- arguments to pass to fly-B.sh ("-n 123456 -i SRR202127")
- name ID to append to the log: unique ID, NIF, DNI, NIU (e.g. 123456)

##### fly-C.sh script
Finally, you have the last and longest job to submit. You will have to use the Read Length of the last calculation and also the NIU for the directory and SRA id. 

You need to use the fly-C.sh file that contains the instructions to create the transposon characterization analysis. We can call it in the terminal to see additional help and information. 

Just type “sh fly-C.sh” in the terminal where the fly-C.sh file is (in the path where you started the analysis and copy the files).


```
###############################################
### fly-C script Usage:
###############################################
This script C creates the Tlex analysis using the previous SRAacc data retrieved
It requires the your NIU or any unique ID you used before to check the folder generated with your results
It also requires the length of the sequences obtained using fly-B script

Usage: sh fly-C.sh -n NIU -i SRA -l num
options:
  -h       Optional: Print this help message
  -n NIU   Unique ID identifier of each student
  -i SRA   SRA ID identifying the dataset to obtain
  -l num   Length of the sequences obtained in previous step B
```

This script requires a new argument, the length of reads, provided using option “-l”.

This script contains several lines that:
- Controls the arguments provided
- Controls the job is not previously done
- Prepares the job: move to the appropriate folder in the execution host computer
- Creates the transposon characterization using the software Tlex3

See details of the code in the fly-C.sh file within the github repository.

As in the previous step, we need to submit via HTCondor system. Again, we need to provide arguments, append the name and provide the executable. 
- script to execute: fly-C.sh
- arguments to pass to fly-C.sh ("-n 123456 -i SRR202127 -l 146")
- name ID to append to the log: unique ID, NIF, DNI, NIU (e.g. 123456)


If it was successfully submitted this script might take from 5-20 hours to finish. It will depend on the dataset. This script calls the software [Tlex3](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7703783/) that allow us to genotype and estimate population frequencies of transposable elements using the short-read whole genome sequencing data stored in fastq format.

## Results


Once the job is finished we want to retrieve the results generated for each SRA and submit it to the codethefly website in order to collaborate with the project.

Remember your login credentials. Website is https://www.codethefly.omicsuab.org/.

The summary file of interest is stored in the previous folder and named as Tresults. 

You will have to download it from PIC using WinSCP in Windows or scp in linux. Use the ssh connection and password.

Once stored in your computer, you will have to submit file Tresults to the project website in the Tab Collaborate. Search your SRA assigned and press the SUBMIT button to upload the file. You should only submite the Tresults file.



