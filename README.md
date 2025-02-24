# COVID19_wastewater_freyja
COVID-19 analysis of sewage samples using Freyja

This pipeline is designed to automate SARS-CoV-2 wastewater sequencing data. It uses PE illumina sequencing data with BWA-mem, then processes the BAM files with Freyja to create an aggregated csv summary file and figure. 

This pipeline was written as a shell script, and the results can be obtained through the oneline command line.

**Configuration**
1. BWA and Freyja must be installed in advance
2. Clone repo

If only a R1 filename is found, it will be error.

By simply changing the type of ref file, analysis of all pathogens provided by freyja other than sars-cov-2 is possible.

Example of diretory tree


**Run the pipeline**
1. Make your own input folder and move to your raw files into this folder
2. Change the path of your ref fasta files
3. Modify any parts that need to be modified, such as bwa's options.
4. Run the command line using **bash freyja_COVID19.sh**


Please cite this program when needed.
