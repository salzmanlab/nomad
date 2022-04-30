
process GET_ANCHORS_AND_SCORES {

    label 'process_high'

    input:
    path counts
    path samplesheet
    val distance_type
    val max_targets
    val max_dist
    val bonfer
    val pval_threshold

    output:
    path outfile_scores , emit: scores
    path outfile_anchors, emit: anchors

    script:
    slice_name          = counts.simpleName.toString().replace("stratified_", "")

    outfile_scores      = "scores_${slice_name}.tsv"
    outfile_anchors     = "anchors_${slice_name}.tsv"
    """
    get_anchors.R \\
        ${counts} \\
        ${samplesheet} \\
        ${distance_type} \\
        ${max_targets} \\
        ${max_dist} \\
        ${bonfer} \\
        ${pval_threshold} \\
        ${outfile_scores} \\
        ${outfile_anchors}
    """
}
