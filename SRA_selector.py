#!/usr/bin/env python3

##
print("\n###################################")
print ("## Scrip to randomly select SRAids")
print("###################################")

print("\n + Read SRAids file...")
SRA_file = "/data/codefly/scratch/fly/SRAids.txt"
print("")
## get contents into a list
with open(SRA_file, "r") as reader:
    SRA_list = reader.readlines()

print("+ List of available SRAs contains: ")
print("  " + str(len(SRA_list)) + " entries")

print("\n+ Randome choice...\n")
import random
rnd_entry = random.choice(SRA_list).replace("\n", "")

print("#----------------------------#")
print("Your SRA id assigned is: " + rnd_entry)
print("#----------------------------#")
print("\n")
