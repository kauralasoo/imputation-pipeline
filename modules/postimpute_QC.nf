process filter_vcf{
    container = 'quay.io/eqtlcatalogue/genimpute:v20.06.1'

    input:
    tuple val(chromosome), file(vcf)

    output:
    tuple val(chromosome), file("${vcf.simpleName}_filtered.vcf.gz")

    script:
    """
    bcftools filter -i 'INFO/DR2 > ${params.r2_thresh}' ${vcf} | \
      bcftools filter -i 'MAF[0] > 0.01' -Oz -o ${vcf.simpleName}_filtered.vcf.gz
    """
}

process index_vcf{
    container = 'quay.io/eqtlcatalogue/genimpute:v20.06.1'

    input:
    tuple val(chromosome), file(vcf)

    output:
      file(vcf)
      file("${vcf}.csi")

    script:
    """
    bcftools index ${vcf}
    """
}

process merge_vcf{
    publishDir "${params.outdir}/beagle_out/", mode: 'copy', pattern: "*.vcf.gz"
    container = 'quay.io/eqtlcatalogue/genimpute:v20.06.1'

    input:
    file input_files
    file indices

    output:
    file "${params.output_name}.MAF001.vcf.gz"

    script:
    """
    bcftools concat ${input_files.join(' ')} | bcftools sort -Oz -o ${params.output_name}.MAF001.vcf.gz
    """
}

process merge_unfiltered_vcf{
    publishDir "${params.outdir}/beagle_out/", mode: 'copy', pattern: "*.vcf.gz"
    container = 'quay.io/eqtlcatalogue/genimpute:v20.06.1'

    input:
    file input_files
    file indices

    output:
    file "${params.output_name}.all_variants.vcf.gz"

    script:
    """
    bcftools concat ${input_files.join(' ')} | bcftools sort -Oz -o ${params.output_name}.all_variants.vcf.gz
    """
}