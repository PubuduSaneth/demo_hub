## Run CBS using the input file
## Columns in the input file - somatic_CNVTrack.bed
### chrom, start, end: Genomic region (50kb binned hg19)
### logR: Log ratio between somtic_cnv_counts / DGV_cnv_count for each 50kb bin


library('DNAcopy')
binned = read.delim("datasets_0119/somatic_CNVTrack.bed", header=TRUE, sep="\t")
binned$length <- binned$end - binned$start


#https://www.rdocumentation.org/packages/DNAcopy/versions/1.46.0/topics/CNA
# CNV: Creates a `copy number array' data object used for DNA copy number analyses by programs such as circular binary segmentation (CBS).
cna = suppressWarnings(CNA(cbind(binned$logR), binned$chr, binned$start,
          data.type="logratio", presorted=T))
          
set.seed(0xA5EED)
# segments DNA copy number data into regions of estimated equal copy number using circular binary segmentation (CBS)
# https://www.rdocumentation.org/packages/DNAcopy/versions/1.46.0/topics/segment
# https://rdrr.io/bioc/DNAcopy/src/R/changepoints.R
fit = segment(cna, alpha=0.01)

for (i in 1:nrow(fit$output)) {
    if (!is.na(fit$segRows$startRow[i])) {
        start_bin = fit$segRows$startRow[i]
        end_bin = fit$segRows$endRow[i]
        fit$output$loc.start[i] = binned$start[start_bin]
        fit$output$loc.end[i] = binned$end[end_bin]
    }
}

write.table(fit$output[,c('chrom', 'loc.start', 'loc.end', 'num.mark', 'seg.mean')], 
            file='datasets_0119/somatic_CNVTrack.segments_CBS_out.bed', sep='\t', quote=FALSE, row.names=FALSE)