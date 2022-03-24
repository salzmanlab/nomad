
process BOWTIE2_ANNOTATION {

    tag "${index_name}"
    label 'process_low'

    input:
    path anchor_fasta
    path target_fasta
    val index

    output:
    path "anchor_hits*tsv"  , emit: anchor_hits
    path "target_hits*tsv"  , emit: target_hits

    script:
    index_name              = file(index).baseName
    anchor_hits             = "anchor_hits_${index_name}.tsv"
    target_hits             = "target_hits_${index_name}.tsv"
    """
    rm -rf ${anchor_hits}
    echo -e "anchor\tanchor_hits_${index_name}\tanchor_hits_pos_${index_name}" >> ${anchor_hits}

    bowtie2 -f -x ${index} -U ${anchor_fasta} --quiet \\
        | sed '/^@/d' \\
        | cut -f1,3,4 \\
        | sort \\
        | uniq \\
        >> ${anchor_hits}

    rm -rf ${target_hits}
    echo -e "target\ttarget_hits_${index_name}\ttarget_hits_pos_${index_name}" >> ${target_hits}

    bowtie2 -f -x ${index} -U ${target_fasta} --quiet \\
        | sed '/^@/d' \\
        | cut -f1,3,4 \\
        | sort \\
        | uniq \\
        >> ${target_hits}
    """
}
