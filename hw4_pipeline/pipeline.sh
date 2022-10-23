export FASTQC="../bin/FastQC/fastqc"
export BWA="../bin/bwa/bwa"
export SAMTOOLS="../bin/samtools-1.16.1/samtools"
export NAME="SRR20043619"

$FASTQC $NAME.fastq.gz

cd ref && ../$BWA index ref.fna && ../$BWA mem ref.fna ../$NAME.fastq.gz | gzip -3 > ../aln-se.sam.gz && cd ..

$SAMTOOLS view -S -b -o align.bam aln-se.sam.gz
$SAMTOOLS flagstat align.bam > flagstat.txt

python3 mapped.py flagstat.txt