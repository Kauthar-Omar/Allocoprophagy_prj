#reference downloaded to:
#/users/abaud/komar/P50/allocoprophagy/data/reference_genome/ncbi_dataset/data/GCF_015227675.2
#remeber to move and say how you moved it.


#code used to download reference
#Downloaded on 4th July 2023
curl -OJX GET "https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_015227675.2/download?include_annotation_type=GENOME_FASTA,SEQUENCE_REPORT&filename=GCF_015227675.2.zip" -H "Accept: application/zip"

