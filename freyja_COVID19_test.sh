#!/bin/bash
freyja update #Must be connected to Internet

input_dir="./fastq_files_test" #place of your fastq files
output_dir="./output_test"
demix_files="./demix_files_test"
variants_files="./variants_files_test"
depth_files="./depth_files_test"

REF=/home/Freyja/freyja/data/ref/NC_045512_Hu-1.fasta #place of your ref fasta
mkdir -p "$output_dir" "$demix_files" "$variants_files" "$depth_files"
bwa index $REF


#Read fastq file
for filename1 in "$input_dir"/*R1*.fastq.gz; do

    if [[ ! -f "$filename1" ]]; then
    echo "Error: Forward read file ($filename1) not found."
    continue
    fi

    filename2="${filename1/_R1.fastq/_R2.fastq}"

    if [[ ! -f "$filename2" ]]; then
    echo "Warning: Reverse read file ($filename2) not found for $filename1. Skipping this pair."
    continue
    fi

    
    sample_name=$(basename "$filename1" _R1.fastq.gz)
#pre-processing
    echo "*************************************************************Running pre-processing*************************************************************"
    bwa mem $REF "$filename1" "$filename2" -U 17 -M -t 16 > "$output_dir/$sample_name.sam"
    samtools sort "$output_dir/$sample_name.sam" > "$output_dir/$sample_name.sorted.sam"
    rm "$output_dir/$sample_name.sam" #insufficient memory
    samtools view -Sb "$output_dir/$sample_name.sorted.sam" > "$output_dir/$sample_name.bam"
    rm "$output_dir/$sample_name.sorted.sam" #insufficient memory

    echo "*****************************************************************Running Freyja*****************************************************************"
#freya
    freyja variants "$output_dir/$sample_name.bam" --variants "$variants_files/$sample_name.tsv" --depths "$depth_files/$sample_name.depth" --ref $REF
    freyja demix "$variants_files/$sample_name.tsv" "$depth_files/$sample_name.depth" --output "$demix_files/$sample_name.output" --confirmedonly

done

    freyja aggregate "$demix_files"/ --output "bunch_of_files_test.tsv"
    freyja aggregate "$demix_files"/ --output "bunch_of_files_test.tsv"
    freyja plot "bunch_of_files_test.tsv" --mincov 0 --output minicov0_sample.png
    freyja plot "bunch_of_files_test.tsv" --mincov 0  --output mincov0_day.png --times times_metadata.csv --interval D
    freyja plot "bunch_of_files_test.tsv" --mincov 0  --output mincov0_month.png --times times_metadata.csv --interval MS

    echo "***********************************************************All processing are complete***********************************************************"