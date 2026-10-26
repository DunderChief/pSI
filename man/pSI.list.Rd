\name{pSI.list}
\alias{pSI.list}
\title{Convert pSI output to gene list}
\usage{
pSI.list(pSIs, write.csv = TRUE)
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
\code{pSI.list} returns list consisting of 6 data frames,
one for each pSI threshold.
}
\details{
Each data frame contains genes whose pSI values fall below
each respective threshold for each cell type/sample
included in the analysis. NOTE:Supplementary data (human &
mouse expression sets, calculated pSI datasets, etc.) can
be found in \code{pSI.data} package located at the
following URL:
\url{http://genetics.wustl.edu/jdlab/psi_package/}
}
\examples{
##load sample pSI output
data(sample.data)
##List the genes specific to each cell type/sample type across all pSI thresholds
pSI.out.list <- pSI.list(pSIs=sample.data$pSI.output, write.csv=FALSE)
}
\author{
Xiaoxiao Xu, Alan B. Wells, David OBrien, Arye Nehorai,
Joseph D. Dougherty
}

