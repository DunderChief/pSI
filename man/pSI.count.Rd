\name{pSI.count}
\alias{pSI.count}
\title{Convert pSI output to gene count list}
\usage{
pSI.count(pSIs, write.csv = FALSE)
}
\arguments{
  \item{pSIs}{data frame output from
  \code{specificity.index} function with the number of
  columns equal to the number of samples and genes as
  rows.}

  \item{write.csv}{logical variable indicating if csv files
  will be written to the current working directory (default
  value is FALSE)}
}
\description{
\code{pSI.count} This functions counts number of genes
specific to each sample type
}
\details{
Returns data frame consisting of 6 rows, one for each pSI
threshold, and as many columns as cell types/samples were
included in the analysis. Each cell type/sample will have a
count of many genes whose pSI values fall below each
respective threshold for each cell type/sample.
NOTE:Supplementary data (human & mouse expression sets,
calculated pSI datasets, etc.) can be found in
\code{pSI.data} package located at the following URL:
\url{http://genetics.wustl.edu/jdlab/psi_package/}
}
\examples{
##load sample pSI output
data(sample.data)
##Count the number of genes specific to each cell type/sample type across all pSI thresholds
pSI.out.count <- pSI.count(pSIs=sample.data$pSI.output, write.csv=TRUE)
}
\author{
Xiaoxiao Xu, Alan B. Wells, David OBrien, Arye Nehorai,
Joseph D. Dougherty
}

