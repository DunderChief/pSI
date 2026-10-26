#' Convert pSI output to gene lists
#'
#' \code{pSI.list} extracts, for each cell type/sample and each of the four
#' standard pSI thresholds (0.05, 0.01, 0.001 and 0.0001), the genes whose pSI
#' values fall below the threshold, i.e. the genes specific to that cell type.
#'
#' @details
#' Gene symbols are converted to upper case for consistency in downstream
#' analysis. Within each data frame the columns hold different numbers of genes
#' and are padded with \code{NA} to equal length.
#'
#' @param pSIs data frame output from \code{\link{specificity.index}}, with one
#'   column per cell type/sample and genes as rows.
#' @param write.csv logical. If \code{TRUE}, one CSV file per threshold
#'   (\code{pSi_0.05.csv}, \code{pSi_0.01.csv}, \code{pSi_0.001.csv},
#'   \code{pSi_1e-04.csv}) is written to the current working directory. The
#'   default is \code{FALSE}: since pSI 1.2.0 nothing is written unless you ask
#'   for it.
#'
#' @return A named list of four data frames (\code{pSi_0.0001},
#'   \code{pSi_0.001}, \code{pSi_0.01}, \code{pSi_0.05}), one per pSI
#'   threshold. Each has one column per cell type/sample, named
#'   \code{<sample>_<threshold>}, containing the symbols of the genes with pSI
#'   below that threshold, padded with \code{NA}.
#'
#' @export
#' @importFrom utils write.table
#' @author Xiaoxiao Xu, Alan B. Wells, David R. O'Brien, Arye Nehorai, Joseph D. Dougherty
#' @seealso \code{\link{pSI.count}} for the counts alone,
#'   \code{\link{candidate.overlap}} to intersect these lists with a candidate
#'   gene list.
#' @examples
#' ##load sample pSI output
#' data(sample.data)
#' ##List the genes specific to each cell type/sample type across all pSI thresholds
#' pSI.out.list <- pSI.list(pSIs=sample.data$pSI.output)
#' names(pSI.out.list)
#' head(pSI.out.list$pSi_0.01)

pSI.list <- function(pSIs,write.csv=FALSE){
  
  #Reassign gene names as uppercase for continuity in downstream analysis
  rownames(pSIs) <- toupper(rownames(pSIs))
  
  #Assigning variables used in loop, ie number of genes, number of samples etc.
  gene_l <- length(pSIs[,2])
  n_samples <- length(pSIs[1,])
  
  
  for(b in c(0.05, 0.01, 0.001, 0.0001)){
    
    for(i in 1:n_samples){
      #Remove genes with pSI values of NA, ie ignore genes whose SI values did not fall within the top 10% of all genes
      sig_tmp <- pSIs[!is.na(pSIs[,i]),]
      #Keep genes with pSI values below threshold, ie ignore genes whose pSI values were above set pSI threshold value
      sig_tmp <- sig_tmp[sig_tmp[,i] < b,]
      sig_tmp <- data.frame(rownames(sig_tmp), stringsAsFactors=FALSE)
      
      #Binds together the lists of genes specific to each sample type for a given threshold
      if(!i==1){
        gene_bind <- cbind_pad(gene_bind, sig_tmp)
        
      }     
      else{
        gene_bind <- sig_tmp
      }  
    }
    #Assigns columns names to temporary loop data frame as well assign temporary loop data frame a descriptive name
    #colnames(gene_bind) <- paste(colnames(pSIs), b, sep="_")
    if(b<0.001){
      colnames(gene_bind) <- paste(colnames(pSIs), "0.0001", sep="_")
    }else{
      colnames(gene_bind) <- paste(colnames(pSIs), b, sep="_")
    }
    if(b<0.001){
      assign(paste("pSi", "0.0001", sep="_"),gene_bind)
    }else{
      assign(paste("pSi", b, sep="_"),gene_bind)
    }
    #assign(paste("pSi", b, sep="_"),gene_bind)
    
    #Boolean used to indicate if CSV files of the output should be writted to the current working directory
    if(write.csv==TRUE){
      write.table(t(gene_bind), paste("pSi", paste(b,".csv",sep=""), sep="_"), col.names=FALSE, sep=",", na="")
    }
    
    if(b<0.05){
      out <- c(out,gene_bind) 
    }else{
      out <-gene_bind
    }  
    
  }
  
  #create list of 4 dataframes, one for each pSI threshold
  pSi_list <- list(get("pSi_0.0001"), get("pSi_0.001"), get("pSi_0.01"), get("pSi_0.05"))
  pSI_rang <- c("pSi_0.0001", "pSi_0.001", "pSi_0.01", "pSi_0.05")
  names(pSi_list)<- pSI_rang
  
  return(pSi_list)

}
