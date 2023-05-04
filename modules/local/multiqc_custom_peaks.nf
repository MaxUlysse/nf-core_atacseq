process MULTIQC_CUSTOM_PEAKS {
    tag "$meta.id"
    conda (params.enable_conda ? "conda-forge::sed=4.7" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ubuntu:20.04' :
        'docker.io/ubuntu:20.04' }"

    input:
    tuple val(meta), path(peak), path(frip)
    path peak_count_header
    path frip_score_header

    output:
    tuple val(meta), path("*.count_mqc.tsv"), emit: count
    tuple val(meta), path("*.FRiP_mqc.tsv")      , emit: frip
    path "versions.yml"                          , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    cat $peak | wc -l | awk -v OFS='\t' '{ print "${prefix}", \$1 }' | cat $peak_count_header - > ${prefix}.count_mqc.tsv
    cat $frip_score_header $frip > ${prefix}.FRiP_mqc.tsv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sed: \$(echo \$(sed --version 2>&1) | sed 's/^.*GNU sed) //; s/ .*\$//')
    END_VERSIONS
    """
}
