#Author: Jason Looney
#Date: 06 October, 2026
#BTEC 640
#Bioinformatics
#Purpose: create files, upload genetic data, explore data and file it into folders, analyze similarities and differences between species

#Exercise 1: Set up your project directories
bash-3.2$ pwd
>/users/jasonlooney/documents/btec_640
bash-3.2$ mkdir -p assignment_2
bash-3.2$ ls
>README			btec_640		genomics_projects
>assignment_2		class_exercises		transcriptomics_project
bash-3.2$ cd /users/jasonlooney/documents/btec_640/assignment_2
bash-3.2$ pwd
>/users/jasonlooney/documents/btec_640/assignment_2
bash-3.2$ mkdir -p input_data
bash-3.2$ mkdir -p final_output
bash-3.2$ mkdir -p analysis
bash-3.2$ mkdir -p src
bash-3.2$ cd /users/jasonlooney/documents/btec_640/assignment_2/analysis
bash-3.2$ pwd
>/users/jasonlooney/documents/btec_640/assignment_2/analysis
bash-3.2$ mkdir -p gene_survey proteins blast
bash-3.2$ ls
>blast    gene_survey	  proteins

#Exercise 2: Download the four annotation files
bash-3.2$ cd ../
bash-3.2$ pwd
>/users/jasonlooney/documents/btec_640/assignment_2
bash-3.2$ touch README
bash-3.2$ ls
>README		analysis	final_output	input_data	src
bash-3.2$ nano README
bash-3.2$ cd /users/jasonlooney/documents/btec_640/assignment_2/input_data
bash-3.2$ pwd
>/users/jasonlooney/documents/btec_640/assignment_2/input_data

#Download the four GTF files from NCBI with `curl`:

curl -o mouse.gtf.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/635/GCF_000001635.27_GRCm39/GCF_000001635.27_GRCm39_genomic.gtf.gz"

curl -o chicken.gtf.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/016/699/485/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b_genomic.gtf.gz"

curl -o frog.gtf.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/004/195/GCF_000004195.4_UCB_Xtro_10.0/GCF_000004195.4_UCB_Xtro_10.0_genomic.gtf.gz"

curl -o zebrafish.gtf.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/049/306/965/GCF_049306965.1_GRCz12tu/GCF_049306965.1_GRCz12tu_genomic.gtf.gz"

bash-3.2$ for f in *gz; do gunzip $f ; done

#Exercise 3: Explore the files
bash-3.2$ cd /users/jasonlooney/documents/btec_640/assignment_2/analysis/gene_survey
bash-3.2$ ln -s ../../input_data/*.gtf
>usage: ln [-s [-F] | -L | -P] [-f | -i] [-hnv] source_file [target_file]
>       ln [-s [-F] | -L | -P] [-f | -i] [-hnv] source_file ... target_dir
>       link source_file target_file
bash-3.2$ ls -l
>total 0

bash-3.2$ cd /users/jasonlooney/documents/btec_640/assignment_2/input_data
bash-3.2$ ls
>chicken.gtf	frog.gtf	mouse.gtf	zebrafish.gtf
bash-3.2$ head -n 10 mouse.gtf
#gtf-version 2.2
#!genome-build GRCm39

#Exercise 4: How many genes does each species have?
bash-3.2$ pwd
>/users/jasonlooney/documents/btec_640/assignment_2/input_data
bash-3.2$ awk -F'\t' '$3=="gene"' mouse.gtf | wc -l
>   50766
bash-3.2$ awk -F'\t' '$3=="gene"' chicken.gtf | wc -l
>   25638
bash-3.2$ awk -F'\t' '$3=="gene"' frog.gtf | wc -l
>   28938
bash-3.2$ awk -F'\t' '$3=="gene"' zebrafish.gtf | wc -l
>   49663

#Exercise 5: Dissect one gene by hand
grep -i 'gene_id "tlr9";' mouse.gtf > tlr9_mouse.gtf
bash-3.2$ wc -l tlr9_mouse.gtf
>      8 tlr9_mouse.gtf
bash-3.2$ awk -F'\t' '$3=="gene" {print "Sequence:", $1, "Start:", $4, "End:", $5}' tlr9_mouse.gtf
>Sequence: NC_000075.7 Start: 106099797 End: 106104075


#3. How long is the gene (in bp)? Show your calculation.

bash-3.2$ awk -F'\t' '$3=="gene" {print $5-$4+1}' tlr9_mouse.gtf
>4279

#4. How many exons does this gene has and which are the start and end position of each exon?

bash-3.2$ awk -F'\t' '$3=="exon" {print $4, $5}' tlr9_mouse.gtf
>106099797 106099905
>106100714 106104075

#Exercise 6: Repeat for all five genes
bash-3.2$ grep -i 'gene_id "tlr9";' mouse.gtf > tlr9_mouse.gtf
bash-3.2$ grep -i 'gene_id "tp53";' mouse.gtf > tp53_mouse.gtf
bash-3.2$ grep -i 'gene_id "aim2";' mouse.gtf > aim2_mouse.gtf
bash-3.2$ grep -i 'gene_id "tlr9";' mouse.gtf > tlr9_mouse.gtf
bash-3.2$ grep -i 'gene_id "tlr21";' mouse.gtf > tlr21_mouse.gtf
bash-3.2$ grep -i 'gene_id "gulo";' mouse.gtf > gulo_mouse.gtf
bash-3.2$ grep -i 'gene_id "tp53";' chicken.gtf > tp53_chicken.gtf
bash-3.2$ grep -i 'gene_id "aim2";' chicken.gtf > aim2_chicken.gtf
bash-3.2$ grep -i 'gene_id "tlr9";' chicken.gtf > tlr9_chicken.gtf
bash-3.2$ grep -i 'gene_id "tlr21";' chicken.gtf > tlr21_chicken.gtf
bash-3.2$ grep -i 'gene_id "gulo";' chicken.gtf > gulo_chicken.gtf

#Exercise 7: Survey everything with a loop
for SPECIES in mouse chicken frog zebrafish
do
    for GENE in tp53 aim2 tlr9 tlr21 gulo
    do
        grep -i "gene_id \"${GENE}\";" ${SPECIES}.gtf > ${GENE}_${SPECIES}.gtf

        if [-s ${GENE}_${SPECIES}.gtf ]
        then
            echo "${GENE} ${SPECIES} FOUND"
        else
            echo "${GENE} ${SPECIES} NOT_FOUND"
            rm ${GENE}_${SPECIES}.gtf
        fi
    done
done > gene_survey.txt

bash-3.2$ awk -F'\t' '$3=="gene" {print $1, $4, $5}' tp53_mouse.gtf
bash-3.2$ bash-3.2$ grep -i 'gene_id "tp53";' mouse.gtf > tp53_mouse.gtf
bash: bash-3.2$: command not found
bash-3.2$ grep -i 'gene_id "tp53";' mouse.gtf > tp53_mouse.gtf
bash-3.2$ awk -F'\t' '$3=="gene" {print $1, $4, $5}' tp53_mouse.gtf
bash-3.2$ awk -F'\t' '$3=="gene" {print $1, $4, $5}' aim2_mouse.gtf
>NC_000067.7 173177105 173293606
bash-3.2$ awk -F'\t' '$3=="gene" {print $1, $4, $5}' tlr9_mouse.gtf
>NC_000075.7 106099797 106104075
bash-3.2$ awk -F'\t' '$3=="gene" {print $1, $4, $5}' tlr21_mouse.gtf
bash-3.2$ awk -F'\t' '$3=="gene" {print $1, $4, $5}' gulo_mouse.gtf
>NC_000080.7 66224235 66246703
bash-3.2$ 
bash-3.2$ awk -F'\t' '$3=="gene" {print $1, $4, $5}' tp53_chicken.gtf
>NW_024096016.1 5925 24899
bash-3.2$ awk -F'\t' '$3=="gene" {print $1, $4, $5}' aim2_chicken.gtf
bash-3.2$ awk -F'\t' '$3=="gene" {print $1, $4, $5}' tlr9_chicken.gtf
bash-3.2$ awk -F'\t' '$3=="gene" {print $1, $4, $5}' tlr21_chicken.gtf
>NC_052542.1 308996 335580
bash-3.2$ awk -F'\t' '$3=="gene" {print $1, $4, $5}' gulo_chicken.gtf

#Exercise 8: Download the protein sequences
bash-3.2$ grep -o 'protein_id "NP_[^"]*"' aim2_mouse.gtf | sort -u
>protein_id "NP_001013801.2"
bash-3.2$ grep -o 'protein_id "NP_[^"]*"' tlr9_mouse.gtf | sort -u
>protein_id "NP_112455.2"
bash-3.2$ grep -o 'protein_id "XP_[^"]*"' FILE.gtf | sort -u
bash-3.2$ grep -o 'protein_id "NP_[^"]*"' gulo_mouse.gtf | sort -u
>protein_id "NP_848862.1"
bash-3.2$ grep -o 'protein_id "NP_[^"]*"' tp53_chicken.gtf | sort -u
>protein_id "NP_990595.1"
bash-3.2$ grep -o 'protein_id "NP[^"]*"' tlr21_chicken.gtf | sort -u
>protein_id "NP_001025729.3"
bash-3.2$ grep -o 'protein_id "NP[^"]*"' tp53_frog.gtf | sort -u
>protein_id "NP_001001903.1"
bash-3.2$ grep -o 'protein_id "XP[^"]*"' tlr9_frog.gtf | sort -u
>protein_id "XP_017948709.2"
bash-3.2$ grep -o 'protein_id "XP[^"]*"' tlr21_frog.gtf | sort -u
>protein_id "XP_002936443.3"
bash-3.2$ grep -o 'protein_id "XP[^"]*"' tp53_zebrafish.gtf | sort -u
>protein_id "XP_005165158.1"
>protein_id "XP_073805887.1"
>protein_id "XP_073805888.1"
>protein_id "XP_073805889.1"
>protein_id "XP_073805890.1"
>protein_id "XP_073805892.1"
>protein_id "XP_073805893.1"
>protein_id "XP_073805894.1"
bash-3.2$ grep -o 'protein_id "NP[^"]*"' tp53_zebrafish.gtf | sort -u
>protein_id "NP_001258749.1"
>protein_id "NP_001315516.1"
>protein_id "NP_001315517.1"
>protein_id "NP_571402.1"
bash-3.2$ grep -o 'protein_id "NP[^"]*"' tlr9_zebrafish.gtf | sort -u
>protein_id "NP_001124066.1"
bash-3.2$ grep -o 'protein_id "NP[^"]*"' tlr21_zebrafish.gtf | sort -u
>protein_id "NP_001186264.1"


```

#Move to `analysis/proteins/` and download all the protein sequences **in a single `while read` loop**, like the chromosome 21 exercise.

while read -r gene species accession
do
    curl -o "${gene}_${species}.faa" "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=protein&id=${accession}&rettype=fasta&retmode=text"
    sleep 1
done < ../gene_survey/protein_list.txt
```
> Why `sleep 1`? NCBI blocks users who send too many requests per second. Being polite to a public server is part of best practices.

```bash
#Paste your command loop here:

while read -r gene species accession
do
    curl -o "${gene}_${species}.faa" "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=protein&id=${accession}&rettype=fasta&retmode=text"
    sleep 1
done < ../gene_survey/protein_list.txt


```

#Check that every `.faa` file has one header and a sequence (`grep -c ">" *.faa`). Then combine all species for each gene into **one multi-FASTA file** per gene (e.g. `tlr9_all.faa`).

bash-3.2$ ls -lh *.faa
>-rw-r--r--  1 jasonlooney  staff   426B Oct  6 20:41 aim2_mouse.faa
>-rw-r--r--  1 jasonlooney  staff   500B Oct  6 20:41 gulo_mouse.faa
>-rw-r--r--  1 jasonlooney  staff   1.0K Oct  6 20:41 tlr21_chicken.faa
>-rw-r--r--  1 jasonlooney  staff   1.0K Oct  6 20:41 tlr21_frog.faa
>-rw-r--r--  1 jasonlooney  staff   1.0K Oct  6 20:41 tlr21_zebrafish.faa
>-rw-r--r--  1 jasonlooney  staff   1.1K Oct  6 20:41 tlr9_frog.faa
>-rw-r--r--  1 jasonlooney  staff   1.1K Oct  6 20:41 tlr9_mouse.faa
>-rw-r--r--  1 jasonlooney  staff   1.1K Oct  6 20:41 tlr9_zebrafish.faa
>-rw-r--r--  1 jasonlooney  staff   430B Oct  6 20:41 tp53_chicken.faa
>-rw-r--r--  1 jasonlooney  staff   433B Oct  6 20:41 tp53_frog.faa
>-rw-r--r--  1 jasonlooney  staff   444B Oct  6 20:41 tp53_zebrafish.faa
bash-3.2$ 
bash-3.2$ grep -c ">" *.faa
>aim2_mouse.faa:1
>gulo_mouse.faa:1
>tlr21_chicken.faa:1
>tlr21_frog.faa:1
>tlr21_zebrafish.faa:1
>tlr9_frog.faa:1
>tlr9_mouse.faa:1
>tlr9_zebrafish.faa:1
>tp53_chicken.faa:1
>tp53_frog.faa:1
>tp53_zebrafish.faa:1

#Exercise 9: Confirm with BLAST
cat tp53_chicken.faa
cat aim2_mouse.faa
cat tlr9_mouse.faa
cat tlr21_chicken.faa
cat gulo_mouse.faa