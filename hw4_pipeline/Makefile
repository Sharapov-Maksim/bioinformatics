.SILENT:
FASTQC_EXE := $(CURDIR)/../bin/FastQC/fastqc
BWA := $(CURDIR)/../bin/bwa/bwa
SAMTOOLS := $(CURDIR)/../bin/samtools-1.16.1/samtools
FREEBAYES := $(CURDIR)/../bin/freebayes-1.3.6-linux-amd64-static
NAME := SRR20043619.fastq.gz
GDIR := $(CURDIR)/../bin/makefile2graph

all: FastQC IndexReference aln-se.sam.gz align.bam flagstat.txt parse_results.txt align.sorted.bam var.vcf

clean:
	rm -f *.html
	rm -f *.zip
	rm -rf logs/*
	rm -f ref/*.amb ref/*.ann ref/*.bwt ref/*.pac ref/*.sa ref/*.fai
	rm -f aln-se.sam.gz
	rm -f *.bam
	rm -f flagstat.txt
	rm -f var.vcf

FastQC: ${NAME}
	echo "Generating FastQC report..."
	touch logs/log_FastQC.txt
	${FASTQC_EXE} ${NAME} > logs/log_FastQC.txt 2>&1

IndexReference: ref/ref.fna
	echo "Doing indexing using BWA..."
	touch logs/log_IndexReference.txt
	${BWA} index ref/ref.fna > logs/log_IndexReference.txt 2>&1
	echo "	indexed"

# Align
aln-se.sam.gz: IndexReference ref/ref.fna ${NAME}
	echo "Doing alignment using BWA..."
	touch logs/log_Align.txt
	${BWA} mem ref/ref.fna ${NAME} 2> logs/log_Align.txt | gzip -3 > aln-se.sam.gz
	echo "	Aligned"

# Convert SAM -> BAM
align.bam: aln-se.sam.gz
	echo "Converting SAM -> BAM..."
	touch logs/log_SamtoolsView.txt
	${SAMTOOLS} view -S -b -o align.bam aln-se.sam.gz 2> logs/log_SamtoolsView.txt
	echo "	Converted"

# samtools flagstat
flagstat.txt: align.bam
	echo "Doing samtools flagstat..."
	${SAMTOOLS} flagstat align.bam > flagstat.txt
	echo "	flagstat.txt generated"

# check results -> "OK" / "not OK"
parse_results.txt: mapped.py flagstat.txt
	echo "Analyzing results"
	python3 mapped.py flagstat.txt | tee parse_results.txt

# if OK do samtools sort
align.sorted.bam: align.bam parse_results.txt
	if grep -q -Fx "OK" "parse_results.txt" ; then \
  		echo "Sorting with samtools..." ; \
		touch logs/log_sort.txt; \
		${SAMTOOLS} sort align.bam > align.sorted.bam 2> logs/log_sort.txt; \
		echo "	Finished" ; \
	fi

# after sort run freebayes and find variants
var.vcf: align.sorted.bam parse_results.txt
	if grep -q -Fx "OK" "parse_results.txt" ; then \
		echo "Finding variants using freebayes..." ; \
		touch logs/log_freebayes.txt; \
  		${FREEBAYES} -f ref/ref.fna align.sorted.bam >var.vcf 2> logs/log_freebayes.txt; \
		if [ -s var.vcf ]; then \
			echo "	Variants found, see var.vcf" ; \
		else \
			echo "	Error occures, see logs/log_freebayes.txt" ; \
		fi \
	fi

visualize: 
	make -Bnd |  ${GDIR}/make2graph | dot -Tpng -o graph.png