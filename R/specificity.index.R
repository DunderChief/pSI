#' Specificity Index Statistic
#'
#' \code{specificity.index} calculates the specificity index statistic (pSI)
#' for every gene in every cell type/sample of an expression matrix. The pSI
#' identifies genes enriched in specific cell populations across a large
#' number of profiles, and correctly predicts in situ hybridization patterns
#' for many cell types (Dougherty et al. 2010).
#'
#' @details
#' For cell type 1 and gene \eqn{n}, the specificity index is the mean, over the
#' other \eqn{m-1} cell types \eqn{k}, of the rank (among all genes) of the
#' expression ratio of that gene between cell type 1 and cell type \eqn{k}:
#' \deqn{SI_{n,1}=  \frac{ \sum_{k=2}^m rank( \frac{ IP_{1,n} }{ IP_{k,n} })  }{m-1}}
#' A low SI means the gene is highly enriched in cell type 1 relative to the
#' others. The pSI is a p-value for the observed SI, obtained by comparing it
#' with a null distribution of SI values computed from \code{bts} expression
#' matrices resampled with replacement. To save time it is only calculated for
#' genes whose p-value is below \code{p_max}; all other genes, and genes with
#' expression below \code{e_min} or set to \code{NA} in \code{pSI.in.filter},
#' are returned as \code{NA}.
#'
#' Because the null distribution is resampled, results vary slightly from run
#' to run; call \code{\link{set.seed}} first for a reproducible result.
#'
#' @param pSI.in data frame with expression values for genes in rows and samples
#'   or cell types in columns (replicate arrays already averaged, so one column
#'   per cell type).
#' @param pSI.in.filter optional matched data frame (same genes and samples)
#'   with \code{NA} for any gene that should be excluded for a particular cell
#'   type.
#' @param bts numeric. Number of resampled distributions to average for the
#'   permutation test.
#' @param p_max numeric. Maximum p-value to calculate; genes with larger
#'   p-values are returned as \code{NA}.
#' @param e_min numeric. Minimum expression value for a gene to be included. A
#'   value of 50 has been used for microarray studies and 0.3 for RNA-seq
#'   studies.
#' @param hist logical. If \code{TRUE}, draw histograms of the sampled (null)
#'   and actual distributions of mean gene rank for each cell type on the
#'   current graphics device, one page per cell type. (Before pSI 1.2.0 these
#'   were written as PNG files into the working directory.)
#' @param SI logical. If \code{TRUE}, return the specificity index (mean rank)
#'   itself instead of the pSI p-value.
#' @param hist_file optional path to a PDF file. If supplied, the histograms
#'   are written there (one page per cell type) instead of to the current
#'   device, and \code{hist} is treated as \code{TRUE}.
#'
#' @return A data frame with the same row and column names as \code{pSI.in}.
#'   Each cell holds the pSI value (a p-value) of that gene for that cell
#'   type/sample, or \code{NA} if the gene was excluded (expression below
#'   \code{e_min}, filtered by \code{pSI.in.filter}, or p-value above
#'   \code{p_max}). With \code{SI = TRUE} the specificity index is returned
#'   instead of the p-value.
#'
#' @export
#' @author Xiaoxiao Xu, Alan B. Wells, David R. O'Brien, Arye Nehorai, Joseph D. Dougherty
#' @references
#' Dougherty JD, Schmidt EF, Nakajima M, Heintz N (2010). Analytical approaches
#' to RNA profiling data for the identification of genes enriched in specific
#' cells. \emph{Nucleic Acids Research} 38(13):4218-4230.
#' \doi{10.1093/nar/gkq130}
#' @seealso \code{\link{pSI.list}}, \code{\link{pSI.count}},
#'   \code{\link{candidate.overlap}}, \code{\link{fisher.iteration}}
#' @examples
#' ##load sample expression matrix
#' data(sample.data)
#' ##calculate specificity index on expression matrix
#' ##(Normally for RNAseq data, and e_min of 0.3, microarrays: e_min= 50)
#' set.seed(1)
#' pSI.output <- specificity.index(pSI.in=sample.data$pSI.input, e_min=20)
#' head(pSI.output[rowSums(!is.na(pSI.output)) > 0, ])
#'
#' ##histograms of the sampled and actual rank distributions, to a temporary PDF
#' pdf_file <- tempfile(fileext = ".pdf")
#' pSI.output <- specificity.index(pSI.in=sample.data$pSI.input, e_min=20,
#'                                 hist_file=pdf_file)
#' unlink(pdf_file)

specificity.index<-function(pSI.in, pSI.in.filter, bts=50, p_max=0.1, e_min=0.3, hist=FALSE, SI=FALSE, hist_file=NULL){

  #histograms go to a multi-page PDF if hist_file is given, otherwise to the current device.
  #Both the device and the graphical parameters are restored when the function exits.
  if(!is.null(hist_file)){
    hist <- TRUE
    grDevices::pdf(file=hist_file, width=10, height=5)
    on.exit(grDevices::dev.off(), add=TRUE)
  }
  if(isTRUE(hist)){
    oldpar <- graphics::par(mfrow=c(1,2))
    on.exit(graphics::par(oldpar), add=TRUE, after=FALSE)
  }

  #make a clean version of pSI.in...
  dat_clean<-pSI.in
  #...for each sample, remove values with less than
  # 50 absolute expression...
  dat_clean[pSI.in<e_min]<-NA
  # for each sample remove those values that are designated to be filtered.
  if(!missing(pSI.in.filter)){
    dat_clean[is.na(pSI.in.filter)]<-NA
    #remove extra variable
    rm(pSI.in.filter)
  }
  
  #make variables to catch the output of this program
  lng <- length(pSI.in[1,])
  datComb<-array(NA,c(length(pSI.in[,1]),2*lng)) #will be 2x the length of input - one column for rank, one for pvalue
  colnames(datComb)<-c(rep(colnames(pSI.in), each=2))#copying over column names, repeating each name twice as noted above
  psi_columns <- c(seq(from=2, to=ncol(datComb), by=2))
  si_columns <- c(seq(from=1, to=ncol(datComb), by=2))
  #colnames(datComb)[psi_columns]<- paste(colnames(datComb)[psi_columns], "pvalue", sep="_")#rename second column
  rownames(datComb) <- rownames(pSI.in)
  
  #for each sample(cell type
  for(j in 1:lng) {
    
    #.. determine which samples are not you
    notme =c(1:(j-1),(j+1):lng)
    
    if(j==1){
      notme=c(2:lng)}
    
    if(j==lng){
      notme=c(1:(lng-1))}
    
    #make a matrix of those genes that are rankable for this cell type.
    TmpMat<-pSI.in[!is.na(dat_clean[,j]),]     # in other words, those that are NOT NA in the clean data for cell type j
    smps<-length(TmpMat[,1])   #  a variable for how many genes this is
    
    #for each other cell type sample with replacement from the values that are
    #not NA for this particular cell type.
    
    avg_ip_pre<-array(NA,c(smps,bts))  #blank a variable to hold the simulated distributions
    
    for(k in 1:bts){     #for 1 to the number of sampled distributions to create
      TmpMatSmp<-array(NA, c(smps, lng))    #blank a variable, number of (unflltered) genes by number of cell types
      for(i in 1:lng)  {  #for each cell type, sample with replacement from gene expression values
        TmpMatSmp[,i]<-sample(TmpMat[,i],smps, replace=TRUE)
      }
      #calcuate the log base 2 fold change for the current cell type (j) vs all others
      z<-log2(TmpMatSmp[,j]/TmpMatSmp[,notme])
      #blank variable
      rankz<-array(0,dim(z))
      z<-z*-1   #to invert the data, so low ranks end up being 'good', and NAs will go to the bottom
      #Calculate the rank of each gene within a each cell/cell comparison
      for(i in 1:(lng-1)) {rankz[,i]=rank(z[,i], na.last="keep")}
      #find the average rank for each gene across all samples
      avg_ip<-c()    #blank a variable
      # A distribution of the averages  each "gene"  rank
      avg_ip <- .rowMeans(rankz, m=smps, n=ncol(rankz))
      avg_ip_pre[,k]<-avg_ip
    }      #end for k
    
    avg_ip_dist<-sort(avg_ip_pre)
    
    #now make the actual distribution of average rank IPs
    # blank a variable Z original (zO) to catch it
    
    zO<-array(NA,c(length(dat_clean[,1]), lng-1))
    
    #... then calculate fold change for this cell type versus all those others
    #(log base two of ratio )
    # Notice that because we are using cleaned data, we will only
    # calculate this when the numerator is not NA, but the demoninator
    # is not filtered.
    zO<-log2(dat_clean[,j]/pSI.in[,notme])
    #blank an array to convert into from the data frame.
    rankzO<-array(0,dim(zO))
    zO<-zO*-1
    #Calculate the rank of each gene within a sample
    for(i in 1:(lng-1)) {rankzO[,i]=rank(zO[,i], na.last="keep")}
    # Move the values from the data frame to the array, so I can take a mean
    #blank a variable to catch the means
    avg_ipO<-c()
    #average the IPs for the actual values.
    avg_ipO <- .rowMeans(rankzO, m=nrow(rankzO), n=ncol(rankzO))
    if(isTRUE(hist)){
      # Make a picture of the situation: sampled (null) and actual distributions, one page per cell type.
      graphics::hist(avg_ip_dist, freq=FALSE , xlim=c(0,smps), main=paste("Sampled distribution:", colnames(pSI.in)[j]))
      graphics::hist(avg_ipO, freq=FALSE, xlim=c(0,smps), main=paste("Actual distribution:", colnames(pSI.in)[j]))
    }
    # make a variable to catch the Pvals
    pvals<-c()
    lng2<-length(avg_ipO)
    #for rankable genes, see where they would fall in the bootstraped distribution
    #use that to calculate a P value.
    # only calculate for p<p_max, to save time (usually p<.1)
    #so find cutoff p< p_max
    ctoff<-avg_ip_dist[(smps*bts)*p_max]
    avg_ip_dist_filt <- avg_ip_dist[which(avg_ip_dist<ctoff)]
    #avg_ip_dist<-rank(avg_ip_dist, na.last="keep")[where.is(avg_ip_dist<ctoff)]
    for (i in 1:lng2)
    {
      avg_ipO.i <- avg_ipO[i]
      if ((!is.na(avg_ipO.i))&(avg_ipO.i<ctoff))
      {
        avg_ip_dist_filt[1]<-avg_ipO.i
        pvals[i]<-((rank(avg_ip_dist_filt, na.last="keep")[1])/(smps*bts))
      }else{
        pvals[i]<-NA
      }
    }
    datComb[,((j*2)-1)]<-avg_ipO
    datComb[,(j*2)]<-pvals
    
  } # toend J loop (each sample)
  if(SI==TRUE){
    datComb <- datComb[,si_columns]
  }else{datComb <- datComb[,psi_columns]}
  
  return(data.frame(datComb)) #return this
  
}#end function
