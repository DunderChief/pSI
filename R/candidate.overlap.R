#' Candidate Gene Overlap
#'
#' \code{candidate.overlap} extracts the genes specific to each cell
#' type/sample (as listed by \code{\link{pSI.list}}) that are also present in a
#' candidate gene list, at each of the four standard pSI thresholds
#' (0.05, 0.01, 0.001 and 0.0001).
#'
#' @details
#' Gene symbols are compared in upper case, so mouse and human symbols can be
#' matched against each other. (Before pSI 1.2.0 only the \code{pSIs} row names
#' were upper-cased, so lower-case candidate symbols silently never matched.)
#'
#' @param pSIs data frame output from \code{\link{specificity.index}}, with one
#'   column per cell type/sample and genes as rows.
#' @param candidate.genes character vector of official gene symbols to test for
#'   overlap with the cell type-specific genes.
#' @param write.csv logical. If \code{TRUE}, one CSV file per threshold
#'   (\code{pSi_0.0001.csv}, \code{pSi_0.001.csv}, \code{pSi_0.01.csv},
#'   \code{pSi_0.05.csv}) is written to the current working directory. Default
#'   \code{FALSE}.
#'
#' @return A named list of four data frames (\code{pSi_0.0001},
#'   \code{pSi_0.001}, \code{pSi_0.01}, \code{pSi_0.05}), one per pSI
#'   threshold, with one column per cell type/sample listing the candidate
#'   genes that are specific to it at that threshold, padded with \code{NA}.
#'
#' @export
#' @importFrom utils write.table
#' @author Xiaoxiao Xu, Alan B. Wells, David R. O'Brien, Arye Nehorai, Joseph D. Dougherty
#' @seealso \code{\link{fisher.iteration}} to test whether each overlap is
#'   larger than expected by chance.
#' @examples
#' ##load sample pSI output
#' data(sample.data)
#' ##load sample candidate gene lists
#' data(candidate.genes)
#' ##Generates lists of overlapping genes
#' candidate.gene.overlap.AutDB <- candidate.overlap(pSIs=sample.data$pSI.output,
#'                                                   candidate.genes=candidate.genes$AutDB)
#' candidate.gene.overlap.AutDB$pSi_0.01

candidate.overlap <- function(pSIs, candidate.genes, write.csv=FALSE){
  
  #pSI.list() upper-cases the gene symbols in pSIs; do the same to the candidates so that they can match
  candidate.genes <- toupper(candidate.genes)
  
  #This function utilizes the output of the pSI.list function
  list_out <- pSI.list(pSIs, write.csv=FALSE)
  
  #Range of pSI thresholds that will be used to name datasets in final output list as well as name output CSV files in the option is specified
  pSI_rang <- c("pSi_0.0001", "pSi_0.001", "pSi_0.01", "pSi_0.05")
  
  for(z in 1:length(list_out)){
    #create temporary dataset with list of genes specific to each sample for a given pSI threshold
    list_out_tmp <- list_out[[z]]
    
    #create index with match() function to identify candidate genes found also to be specific to sample at a given pSI threshold
    mtch <-function(x, y) match(y, x)
    bob <- data.frame(lapply(list_out_tmp, mtch, y=candidate.genes))
    
    #Extract lists of candidate genes found also to be specific to samples at a given pSI threshold
    f1 <-function(x, y) y[!is.na(x)]
    sxs <- data.matrix(lapply(bob, f1, y=candidate.genes))
    
    #Converts list of character arrays data frame
    for(x in 1:length(sxs)){
      if(x>1){
        pSI_holder <- cbind_pad(pSI_holder,data.frame(sxs[[x]]))
      }else{
        pSI_holder <- data.frame(sxs[[x]])
      }
    }
    
    #Assign column names as well as assign descriptive name to temporary dataset used in loop
    colnames(pSI_holder) <- colnames(list_out_tmp)
    assign(paste(pSI_rang[z]),pSI_holder)
    
    #Boolean used to indicate if CSV files of the output should be writted to the current working directory
    if(write.csv==TRUE){
      write.table(t(pSI_holder), paste(pSI_rang[z], "csv", sep="."), col.names=FALSE, sep=",", na="")
    }
  }
  
  #create list of 4 dataframes, one for each pSI threshold
  pSi_list <- list(get("pSi_0.0001"), get("pSi_0.001"), get("pSi_0.01"), get("pSi_0.05")) 
  names(pSi_list)<- pSI_rang
  return(pSi_list)
  
}
