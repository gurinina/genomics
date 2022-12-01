# This script checks the qualitiy of our fastq files and performs an alignment to the dna reference with subread.
# To run this 'shell script' you will need to open your terminal and navigate to the directory where this script resides on your computer.
# This should be the same directory where you fastq files and reference fasta file are found.
# Change permissions on your computer so that you can run a shell script by typing: 'chmod 777 subreadMapping.sh' (without the quotes) at the terminal prompt 
# Then type './subreadMapping.sh' (without the quotes) at the prompt.  
# This will begin the process of running each line of code in the shell script.

## load subread module
source $HOME/miniconda3/bin/activate 
conda activate rnaseq
# first use fastqc to check the quality of our fastq files:
fastqc *.gz -t 4 -o ../FASTQC

# next, we want to build an index from our reference fasta file 
subread-buildindex -o r64/r64bread.index r64/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz

# now map reads to the indexed reference host transcriptome
# use as many 'threads' as your machine will allow in order to speed up the read mapping process.
# note that we're also including the '&>' at the end of each line
# this takes the information that would've been printed to our terminal, and outputs this in a log file that is saved in /data/course_data
 
# aligning
subread-align --sortReadsByCoordinates -a r64/Saccharomyces_cerevisiae.R64-1-1.96.gtf.gz -B 3 -T 16 -i r64/r64bread.index -t 0 -r ERR458493.fastq.gz -o ../BAM/ERR458493.bam &> ../BAM/R493.log
subread-align --sortReadsByCoordinates -a r64/Saccharomyces_cerevisiae.R64-1-1.96.gtf.gz -B 3 -T 16 -i r64/r64bread.index -t 0 -r ERR458494.fastq.gz -o ../BAM/ERR458494.bam &> ../BAM/R494.log
subread-align --sortReadsByCoordinates -a r64/Saccharomyces_cerevisiae.R64-1-1.96.gtf.gz -B 3 -T 16 -i r64/r64bread.index -t 0 -r ERR458495.fastq.gz -o ../BAM/ERR458495.bam &> ../BAM/R495.log
subread-align --sortReadsByCoordinates -a r64/Saccharomyces_cerevisiae.R64-1-1.96.gtf.gz -B 3 -T 16 -i r64/r64bread.index -t 0 -r ERR458500.fastq.gz -o ../BAM/ERR458500.bam &> ../BAM/R500.log
subread-align --sortReadsByCoordinates -a r64/Saccharomyces_cerevisiae.R64-1-1.96.gtf.gz -B 3 -T 16 -i r64/r64bread.index -t 0 -r ERR458501.fastq.gz -o ../BAM/ERR458501.bam &> ../BAM/R501.log
subread-align --sortReadsByCoordinates -a r64/Saccharomyces_cerevisiae.R64-1-1.96.gtf.gz -B 3 -T 16 -i r64/r64bread.index -t 0 -r ERR458502.fastq.gz -o ../BAM/ERR458502.bam &> ../BAM/R502.log
# then get the reads using featureCounts
#featureCounts -t 'exon' -g 'gene_id' -a r64/Saccharomyces_cerevisiae.R64-1-1.96.gtf.gz -o ../counts.txt ../BAM/*.bam
featureCounts -a r64/Saccharomyces_cerevisiae.R64-1-1.96.gtf.gz -M -o ../counts.txt ../BAM/*.bam
# Multi-mapping reads

  # -M Multi-mapping reads will also be counted. For a multi-
  #    mapping read, all its reported alignments will be 
  #    counted. The 'NH' tag in BAM/SAM input is used to detect 
  #    multi-mapping reads. If a gene annotations file is used during 
  #    the map/align stage, 
  #    and the splice junction is detected as an annotated junction, 
  #    then 20 is added to its motif value.
  #    
  # -O Assign reads to all their overlapping meta-features (or 
  #      features if -f is specified).
  # -f Perform read counting at feature level (eg. counting 
  #      reads for exons rather than genes).
  #      

  
  #    multi-mapping reads are not to be confused with
  #    NH:i—A standard SAM tag indicating the number of reported 
  #    alignments that contains the query in the current record. 
  #    This tag may be used for downstream tools such as featureCounts.

  #   -t 'exon' is unnecessary
  #   -t <string> Specify feature type(s) in a GTF annotation. 
  #    If multiple
  #    types are provided, they should be separated by ',' with
  #    no space in between. 'exon' by default. Rows in the
  #    annotation with a matched feature will be extracted and
  #    used for read mapping.
  # -g gene_id is unnecessary
  # -g <string> Specify attribute type in GTF annotation. 'gene_id' by 
                      # default. Meta-features used for read counting will be 
                      # extracted from annotation using the provided value.
  
# summarize fastqc and subread mapping results in a single summary html using MultiQC
multiqc -d . ../FASTQC

echo "Finished"

