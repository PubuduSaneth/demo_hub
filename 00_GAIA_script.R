# Run GAIA using input files passed as command-line arguments
##args <- c("CNV_Matrix.txt", "Markers_Matrix.txt", "CNV.hg19.bypos.111213.txt", "output file")
args <- commandArgs(TRUE)

library(gaia)

print(args)
cnvMatrix <- read.table(args[1], header = TRUE, stringsAsFactors=FALSE)
cnvMatrix[cnvMatrix$Chromosome == "X","Chromosome"] <- 23
cnvMatrix[cnvMatrix$Chromosome == "Y","Chromosome"] <- 24
cnvMatrix$Chromosome <- as.integer(cnvMatrix$Chromosome)
cnvMatrix$Start <- as.integer(cnvMatrix$Start)
cnvMatrix$End <- as.integer(cnvMatrix$End)
cnvMatrix$Aberration <- as.integer(cnvMatrix$Aberration)
typeof(cnvMatrix$Aberration)
mean(cnvMatrix$Aberration)
min(cnvMatrix$Aberration)
cnvMatrix$Aberration[!duplicated(cnvMatrix$Aberration)]
summary(cnvMatrix)
sapply(cnvMatrix, class)


markersMatrix <- read.table(args[2], stringsAsFactors=FALSE)
colnames(markersMatrix) <- c("Probe.Name", "Chromosome", "Start")

markersMatrix$Chromosome <- as.character(markersMatrix$Chromosome)
markersMatrix$Start <- as.integer(markersMatrix$Start)
markersMatrix[markersMatrix$Chromosome == "X","Chromosome"] <- 23
markersMatrix[markersMatrix$Chromosome == "Y","Chromosome"] <- 24
markersMatrix$Chromosome <- as.integer(markersMatrix$Chromosome)

markerID <- paste(markersMatrix$Chromosome,markersMatrix$Start, sep = ":")

# Removed duplicates
markersMatrix <- markersMatrix[!duplicated(markerID),]

# Filter markersMatrix for common CNV
markerID <- paste(markersMatrix$Chromosome,markersMatrix$Start, sep = ":")

cnv_common <- read.table(args[3], header = TRUE, stringsAsFactors=FALSE)
commonID <- paste(cnv_common$Chromosome, cnv_common$Start, sep = ":")
markersMatrix_fil <- markersMatrix[!markerID %in% commonID,]


markers_obj <- load_markers(as.data.frame(markersMatrix_fil))

nbsamples <- length(unique(cnvMatrix$Sample))
cnv_obj <- load_cnv(cnvMatrix, markers_obj, nbsamples)

suppressWarnings({
  results <- runGAIA(cnv_obj,
                     markers_obj,
                     output_file_name = paste0("GAIA_", args[4],"_out.txt"),
                     chromosomes = -1, # -1 to all chromosomes
                     aberrations = -1,
                     approximation = TRUE, # Set to TRUE to speed up the time requirements
                     num_iterations = 100, # Reduced to speed up the time requirements
                     threshold = 0.25)
})
