nextflow run main.nf -entry no_filter -profile eqtl_catalogue,tartu_hpc -resume\
  --bfile /gpfs/hpc/projects/GENCORD/genotypes/raw_genotyped/plink/GENCORD_GRCh37\
  --harmonise_genotypes true\
  --output_name GENCORD_genotyped\
  --outdir /gpfs/space/home/kerimov/imputed_ones/GENCORD_impute