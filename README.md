# CodeTheFly at UAB using PIC Cluster computer
Bioinformatics practical session on how to work in the CodeTheFly project

Read additional information in here: https://codethefly.omicsuab.org/

In this repository I have included the files for the submission of jobs for the analysis of transposon in Drosophila melanogaster.

## Scripts

### HTCondor submission file

A very important file is the one that configures the submission of jobs. You are going to submit your first job to a batch system, a queue that manages the order and the preference of execution of several tasks. It takes your commands and sends them to a remote machine where your commands are really executed.

Read further details about the queue system here: https://htcondor.readthedocs.io/en/latest/ 

The batch system software is called HTCondor and the configuration file that allows us to submit jobs to the cluster is named as: HTCondor_sender.sub. 

This file HTCondor_sender.sub contains some configuration but also requires additional arguments to be supplied during execution such as: executable, arguments or append. 

An example of job submissions might be:

```
condor_submit HTCondor_sender.sub executable=”example.sh” 
condor_submit HTCondor_sender.sub executable=”example.sh” arguments=”-n 1” 
condor_submit HTCondor_sender.sub executable=”example.sh” arguments=”-n 1” append=”example”
```
Each job submitted will be assigned a job ID after submission. This job ID (or ClusterID) will help you to check the status using condor_q.	

###  Select a random SRA id

The first step of the analysis is to select a random SRA id entry. We are going to call the `SRA_selector.py` script with a bunch of selected SRAids (available in `SRAids.txt`) but you can also go to the https://codethefly.omicsuab.org/, in the tab collaborate there tones of SRAs ids to use. 

The `SRA_selector.py` is a python script that reads the SRAids.txt file that contains a selection of SRA ids and randomly selects one for you.

This script uses the random python package to select a random entry in the list, that contains the contents of the file SRAids.txt

On our computer, we could just execute the script by doing “python SRA_selector.py” but due to the configuration of the cluster, we need to submit the job to an execution host. To do so, we will use the HTCondor_sender.sub and SRA_selector.py as an argument, in this case, named as executable.

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
