#!/usr/bin/env python3
import argparse
import os
import subprocess
from datetime import datetime


### doctrsing : example usage 

'''
Example usage: 
    python run_fastqc.py -d /path/to/reads_dir -t 8 -o /path/to/output_dir -f /path/to/fastqc_binary

This script performs initial QC on raw reads using the FastQC command line tool
'''


def main():
    # Define and parse command line arguments
    parser = argparse.ArgumentParser(description='This script performs initial\
         QC on raw reads using the FastQC command line tool.')
    parser.add_argument('-d', '--reads_dir', type=str, required=True, help='directory containing paired reads')
    parser.add_argument('-t', '--threads', type=int, default=8, help='number of threads to use for fastqc')
    parser.add_argument('-o', '--output_dir', type=str, default='./FastQC_output', help='output directory for fastqc results')
    parser.add_argument('-f', '--fastqc_binary', type=str, default='fastqc', help='path to fastqc binary')
  
    args = parser.parse_args()
    

    # Print start of the process and date time
    print("==========================")
    start_date_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    print(f"{start_date_time} : RUNNING ...fastqc for all samples...")
    print("==========================")
    
    # Check if the READS_DIR directory exists and contains fastq files
    if not os.path.isdir(args.reads_dir) or not os.listdir(args.reads_dir):
        print("Error: directory does not exist or is empty.")
        exit(1)
    
    # Check if the output directory exists
    if os.path.isdir(args.output_dir):
        print("Warning: Output directory already exists. Files may be overwritten.")
    else:
        os.makedirs(args.output_dir)
    
    # Check if fastqc is installed and in the PATH or specified by user
    try:
        subprocess.run(f"which {args.fastqc_binary}", shell=True, check=True)
    except subprocess.CalledProcessError:
        print("Error: fastqc binary not found")
        exit(1)
    
    # Run fastqc to check reads quality - Visual inspection needed.

    for file in os.listdir(args.reads_dir):
        fwd = os.path.join(args.reads_dir, file)
        rev = os.path.join(args.reads_dir, file.replace("_1.fastq", "_2.fastq"))
        if os.path.isfile(fwd) and os.path.isfile(rev):
            base = os.path.splitext(file)[0].split("_")[0]
            sample_out_dir = os.path.join(args.output_dir, base)
            if not os.path.isdir(sample_out_dir):
                os.mkdir(sample_out_dir)
            subprocess.run(f"{args.fastqc_binary} -t {args.threads} -o {sample_out_dir} {fwd} {rev}", shell=True)
        else:
            if not os.path.isfile(fwd):
                print(f"{fwd} does not exist, skipping it.")
            elif not os.path.isfile(rev):
                print(f"{rev} does not exist, skipping it.")


    
    print("==========================")
    end_date_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    print(f"{end_date_time} : FASTQC FOR ALL SAMPLES FINISHED. HAVE FUN!")
    print("==========================")

if __name__ == '__main__':
    main()
