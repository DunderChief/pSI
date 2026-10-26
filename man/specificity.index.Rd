\name{specificity.index}
\alias{specificity.index}
\title{Specificity Index Statistic}
\usage{
specificity.index(pSI.in, pSI.in.filter, bts = 50, p_max = 0.1,
  e_min = 0.3, hist = FALSE, SI = FALSE)
}
\arguments{
  \item{pSI.in}{data frame with expresion values for genes
  in rows, and samples or cell types in columns (at this
  point replicate arrays have been averaged, so one column
  per cell type)}

  \item{pSI.in.filter}{matched array (same genes and
  samples) but with NA's for any genes that should be
  excluded for a particular cell type.}

  \item{bts}{numeric. number of distributions to average
  for permutation testing}

  \item{p_max}{numeric. maximum pvalue to be calculated}

  \item{e_min}{numeric. minimum expression value for a gene
  to be included. For microarray studies, a value of 50 has
  been the default value and for RNAseq studies, a value of
  0.3 has been used as the default.}

  \item{hist}{logical. option for producing histograms of
  actual & permuted distributions of gene rank}

  \item{SI}{logical. option to output SI value instead of
  default pSI value}
}
\description{
\code{specificity.index} Calculates specificity index
statistic (pSI) values of input expression matrix which can
be used for comparative quantitative analysis to identify
genes enriched in specific cell populations across a large
number of profiles. This measure correctly predicts in situ
hybridization patterns for many cell types.
\code{specificity.index} returns a data frame of equal size
as input data frame, with pSI values replacing the
expression values. NOTE:Supplementary data (human & mouse
expression sets, calculated pSI datasets, etc.) can be
found in \code{pSI.data} package located at the following
URL: \url{http://genetics.wustl.edu/jdlab/psi_package/}
}
\details{
\eqn{SI_{n,1}= \frac{ \sum_{k=2}^m rank( \frac{ IP_{1,n} }{
IP_{k,n} }) }{m-1}}
}
\examples{
##load sample expression matrix
data(sample.data)
##calculate specificity index on expression matrix
##(Normally for RNAseq data, and e_min of 0.3, microarrays: e_min= 50)
pSI.output <- specificity.index(pSI.in=sample.data$pSI.input, e_min=20)
}
\author{
Xiaoxiao Xu, Alan B. Wells, David OBrien, Arye Nehorai,
Joseph D. Dougherty
}
\references{
Joseph D. Dougherty, Eric F. Schmidt, Miho Nakajima, and
Nathaniel Heintz Analytical approaches to RNA profiling
data for the identification of genes enriched in specific
cells Nucl. Acids Res. (2010)
}

