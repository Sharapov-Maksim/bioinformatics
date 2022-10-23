.SILENT:
FASTQC_EXE := $(CURDIR)/../bin/FastQC/fastqc
BWA := $(CURDIR)/../bin/bwa/bwa
SAMTOOLS := $(CURDIR)/../bin/samtools-1.16.1/samtools
NAME := SRR20043619.fastq.gz

all: FastQC IndexReference Align SamtoolsView SamtoolsFlagstat ParseMapped

clean:
	rm *.html
	rm *.zip
	rm -rf logs/*

FastQC: ${FASTQC_EXE} ${NAME}
	echo "Generating FastQC report..."
	touch logs/log_FastQC.txt
	${FASTQC_EXE} ${NAME} > logs/log_FastQC.txt 2>&1

IndexReference: ${BWA} ref/ref.fna
	echo "Doing indexing using BWA..."
	touch logs/log_IndexReference.txt
	${BWA} index ref/ref.fna > logs/log_IndexReference.txt 2>&1
	echo "	indexed"

Align: IndexReference ${BWA} ref/ref.fna ${NAME}
	echo "Doing alignment using BWA..."
	touch logs/log_Align.txt
	${BWA} mem ref/ref.fna ${NAME} 2> logs/log_Align.txt | gzip -3 > aln-se.sam.gz
	echo "	Aligned"

SamtoolsView: Align ${SAMTOOLS} aln-se.sam.gz
	echo "Converting SAM -> BAM..."
	touch logs/log_SamtoolsView.txt
	${SAMTOOLS} view -S -b -o align.bam aln-se.sam.gz
	echo "	Converted"

SamtoolsFlagstat: SamtoolsView ${SAMTOOLS} align.bam
	echo "Doing samtools flagstat..."
	${SAMTOOLS} flagstat align.bam > flagstat.txt
	echo "	flagstat.txt generated"

ParseMapped: SamtoolsFlagstat mapped.py flagstat.txt
	echo "Analyzing results"
	python3 mapped.py flagstat.txt