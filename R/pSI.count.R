#' Convert pSI output to gene counts
#'
#' \code{pSI.count} counts the number of genes specific to each cell
#' type/sample at each of the four standard pSI thresholds (0.05, 0.01, 0.001
#' and 0.0001).
#'
#' @param pSIs data frame output from \code{\link{specificity.index}}, with one
#'   column per cell type/sample and genes as rows.
#' @param write.csv logical. If \code{TRUE}, the table is also written to
#'   \code{gene_count_1.csv} in the current working directory. Default
#'   \code{FALSE}.
#'
#' @return A data frame with four rows, one per pSI threshold (\code{"0.0001"},
#'   \code{"0.001"}, \code{"0.01"}, \code{"0.05"}), and one column per cell
#'   type/sample, giving the number of genes whose pSI value falls below each
#'   threshold.
#'
#' @export
#' @importFrom utils write.csv
#' @author Xiaoxiao Xu, Alan B. Wells, David R. O'Brien, Arye Nehorai, Joseph D. Dougherty
#' @seealso \code{\link{pSI.list}} for the gene lists themselves.
#' @examples
#' ##load sample pSI output
#' data(sample.data)
#' ##Count the number of genes specific to each cell type/sample type across all pSI thresholds
#' pSI.out.count <- pSI.count(pSIs=sample.data$pSI.output)
#' pSI.out.count

pSI.count <- function(pSIs, write.csv=FALSE){
  
  
  #Assigning variables used in loop, ie number of genes, number of samples etc.
  gene_l <- length(pSIs[,1])
  samples <- pSIs[1,]
  n_samples <- length(pSIs[1,])
  #name_columns <- c(seq(from=1, to=ncol(pSIs), by=2))
  names <- data.frame(array(NA, dim=c(1,n_samples)))
  names<- colnames(pSIs)
  
  
  for(b in c(0.05, 0.01, 0.001, 0.0001)){
    #create data frame to hold gene counts
    gene_count <- data.frame(array(NA, dim=c(1,1)))
    
    for(i in 1:n_samples){
      #filter out all NA values, then count how many fall below the current threshold for a given cell type 
      sig_tmp <- pSIs[!is.na(pSIs[,i]),]
      sig_tmp <- sig_tmp[sig_tmp[,i] < b,]
      gene_count <- cbind(gene_count, length(sig_tmp[,i]))
      
    }
    #during the first iteration of the previous loop the gene_count data set is column bound onto itself and must be removed
    gene_count <- gene_count[-1]
    #Assigns descriptive name to temporary loop variable
    assign(paste("gene_count", b, sep="_"),gene_count)
    
  }
  
  #row bind all the different and assign row & column names
  gene_count_1 <- rbind(get("gene_count_1e-04"), get("gene_count_0.001"), get("gene_count_0.01"), get("gene_count_0.05"))
  rownames(gene_count_1) <- c("0.0001", "0.001", "0.01", "0.05")
  colnames(gene_count_1) <- colnames(pSIs)
  
  #if boolean for writing CSV is TRUE then file will be written in current working directory
  if(write.csv==TRUE){
    write.csv(gene_count_1,"gene_count_1.csv")
    
  }
  return(gene_count_1)
  
  }
