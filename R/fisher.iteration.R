#' Fisher's Exact Test Across All Cell Types and pSI Thresholds
#'
#' \code{fisher.iteration} tests a candidate gene list for over-representation
#' among the genes specific to each cell type/sample, at each of the four
#' standard pSI thresholds (0.05, 0.01, 0.001 and 0.0001), using a one-sided
#' Fisher's exact test.
#'
#' @details
#' For every cell type/threshold combination the function asks: what is the
#' probability that this many candidate genes would be specific to this cell
#' type by chance? Each gene in the background is classified by two binary
#' variables, specific to the cell type at this threshold or not, and in the
#' candidate list or not, and the resulting 2 x 2 table is tested with
#' \code{\link[stats]{fisher.test}} (alternative \code{"greater"}). Gene
#' symbols are compared in upper case, and duplicated candidate genes are
#' counted once.
#'
#' @param pSIs data frame output from \code{\link{specificity.index}}, with one
#'   column per cell type/sample and genes as rows.
#' @param candidate.genes character vector of official gene symbols to test for
#'   over-representation.
#' @param background character string naming the background gene list for the
#'   test. The default \code{"data.set"} uses all genes in \code{pSIs}; use it
#'   when the candidate genes and the pSI data set come from the same species.
#'   \code{"human.mouse"} restricts the background to the genes in \code{pSIs}
#'   (human) that have a clear mouse homolog, for testing a mouse candidate list
#'   against a human pSI data set; \code{"mouse.human"} is the converse. These
#'   two options download the UCSC kgXref table for mm10 or hg19 (a file of
#'   several megabytes) from \url{https://hgdownload.soe.ucsc.edu/} and stop
#'   with an informative error if the download fails.
#' @param p.adjust logical. If \code{TRUE} (the default) p-values are adjusted
#'   for multiple testing across cell types with the Benjamini-Hochberg method
#'   (\code{\link[stats]{p.adjust}}, method \code{"BH"}), separately for each
#'   threshold; if \code{FALSE}, nominal p-values are returned.
#'
#' @return A data frame with one row per cell type/sample and four columns, one
#'   per pSI threshold (0.05, 0.01, 0.001, 0.0001). Column names end in
#'   \code{"adjusted"} or \code{"nominal"} depending on \code{p.adjust}.
#'
#' @export
#' @importFrom stats fisher.test p.adjust
#' @importFrom utils download.file read.table
#' @author Xiaoxiao Xu, Alan B. Wells, David R. O'Brien, Arye Nehorai, Joseph D. Dougherty
#' @seealso \code{\link{candidate.overlap}} for the overlapping genes themselves.
#' @examples
#' ##load sample pSI output
#' data(sample.data)
#' ##load sample candidate gene lists
#' data(candidate.genes)
#' ##run Fisher's exact test for overrepresentation on pSI.out for the AutDB
#' ##candidate gene list across all cell types/sample types & pSI thresholds
#' fisher.out.AutDB <- fisher.iteration(pSIs=sample.data$pSI.output,
#'                                      candidate.genes=candidate.genes$AutDB)
#' fisher.out.AutDB

fisher.iteration<-function(pSIs, candidate.genes, background="data.set", p.adjust=TRUE){  
  
  if(background=="data.set"){
    
    total <- length(pSIs[,1])
    
  }else if(background=="human.mouse"){
    
    kgxref.mouse <- kgxref_symbols("mm10")
    total <- sum(!is.na(match(toupper(rownames(pSIs)), toupper(kgxref.mouse))))
    
  }else if(background=="mouse.human"){
    
    kgxref.human <- kgxref_symbols("hg19")
    #total <- 13421
    total <- sum(!is.na(match(toupper(rownames(pSIs)), toupper(kgxref.human))))
    
  }else{
    stop("Background gene list for Fisher's exact test incorrectly assigned")
  }
  
  #Assigning variables used in loop
  pSIs<-cbind(c(1:length(pSIs[,1])),pSIs)
  index <- cbind(as.numeric(c(1:length(pSIs[,1]))),toupper(rownames(pSIs)))
  
  #create 3 column dataset which is comprised of gene index, boolean if gene is found in candidate list, and gene symbol in the third column
  candidate.genes <- cbind(index[,1], match(index[,2], toupper(unique(candidate.genes))), index[,2])
  
  #Create temporary variable, cnv_temp and assign value of zero to genes with no match and value of 1 to genes with a match
  cnv_temp <- candidate.genes
  cnv_temp[which(is.na(candidate.genes[,2])),2] <- 0
  cnv_temp[which(!is.na(candidate.genes[,2])),2] <- 1
  
  #remove index of genes from pSI dataset and assign rownames to index(NULL)
  pSIs <- pSIs[,-1]
  row.names(pSIs) <- NULL
  
  #reassign cnv_temp variable as candidate.genes while dropping the third column and drop temporary variable
  candidate.genes <- cnv_temp[,-3]
  rm(cnv_temp)
  
  #range of pSI thresholds to loop through
  rang<- c(.05,.01,.001,.0001)
  
  #matrix created hold output from loop
  outs_CTp<-data.frame(matrix(NA, nrow=length(colnames(pSIs)), ncol=length(rang)))
  rownames(outs_CTp) <- colnames(pSIs)
  colnames(outs_CTp) <- rang
  
  #Loops through the various samples/pSI threshold combinations and test for overrepresentation using a Fisher's Exact test
  j<-0
  for (Th in rang){
    j<-j+1
    for(i in 1:length(colnames(pSIs))){
      outs_CTp[i,j]<-as.numeric(fisher(pSIs, candidate.genes, Th, i, total))
    }
  }
  if(p.adjust==TRUE){
  
  #Create new dataframe "holder" which has twice as many columns as number of samples/cell types.
  colnames(outs_CTp) <- paste(colnames(outs_CTp),"adjusted",sep=" - ")
  
  #Calculte BH adjusted p-values and add to "holder" dataframe
  for(k in 1:ncol(outs_CTp)){
    outs_CTp[,k] <- p.adjust(outs_CTp[,k], method="BH", n=nrow(outs_CTp))
  }

  }else{
    colnames(outs_CTp) <- paste(colnames(outs_CTp),"nominal",sep=" - ")
  }
  
  return(outs_CTp)
}

# Download the UCSC kgXref table for an assembly ("mm10" or "hg19") and return
# its gene-symbol column. Used for the cross-species backgrounds above. Fails
# with an informative error rather than a cryptic one when offline, as CRAN
# policy requires of packages that use internet resources. mode = "wb" keeps
# the gzip file intact on Windows (the text-mode download in pSI <= 1.1 did not).
kgxref_symbols <- function(assembly) {
  url <- paste0("https://hgdownload.soe.ucsc.edu/goldenPath/", assembly,
                "/database/kgXref.txt.gz")
  temp <- tempfile(fileext = ".txt.gz")
  on.exit(unlink(temp))
  status <- tryCatch(
    suppressWarnings(download.file(url, temp, quiet = TRUE, mode = "wb")),
    error = function(e) -1L)
  if (!identical(as.integer(status), 0L) || !file.exists(temp) || file.size(temp) == 0) {
    stop("Could not download the UCSC kgXref table from ", url,
         ". Check your internet connection, or use background = \"data.set\".",
         call. = FALSE)
  }
  kgxref <- read.table(gzfile(temp), sep = "\t", row.names = NULL, header = FALSE,
                       stringsAsFactors = FALSE, quote = "")
  kgxref[, 5]
}
