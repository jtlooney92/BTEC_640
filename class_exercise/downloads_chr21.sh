
#1 Move and make working directories
cd btec_640/class_exercises/ # move directory
mkdir -p september_14
mkdir -p september_14/analysis
mkdir -p september_14/input_data
cd september_14/input_data

#download the chr21 data
curl -o hg38.ncbiRefSeq.gtf.gz "https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ncbiRefSeq.gtf.gz"

#3 unzipping the data
gunzip hg38.ncbiRefSeq.gtf.gz

#link the data to analysis folder
ln -s ../input_data/hg38.ncbiRefSeq.gtf

#filter data into meaningful categories
grep "chr21" hg38.ncbiRefSeq.gtf > chr21.gtf

grep "NM_" chr21.gtf > refseq_chr21.gtf

#remove unecesary information
awk -F '\t' '{print $9}' refseq_chr21.gtf  | awk -F'"' '!seen[$2]++ {print $2, $4}' refseq_chr21.gtf > gene_accession.txt

#download the new filtered sequence data
head -n 10 gene_accession.txt > 10_genes.txt
cat 10_genes.txt

while read -r gene accession
do
    curl -o "${gene}.fasta" "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${accession}&rettype=fasta&retmode=text"

done < 10_genes.txt


























