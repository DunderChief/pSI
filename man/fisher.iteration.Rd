\name{fisher.iteration}
\alias{fisher.iteration}
\title{Fisher's Exact Test Across All Cell Types & pSI Thresholds}
\usage{
fisher.iteration(pSIs, candidate.genes, background = "data.set",
  p.adjust = TRUE)
}
\arguments{
  \item{pSIs}{data frame output from
  \code{specificity.index} function with the number of
  columns equal to the number of samples and genes as
  rows.}

  \item{candidate.genes}{candidate gene list tested for
  overrepresentation in cell types/samples. Comprised of
  official gene symbols.}

  \item{background}{character string used to indicate what
  background gene list should be used in Fisher's exact
  test for overrepresentation. The default value is
  \code{"data.set"} which indicates that the gene list of
  the input pSI data set will be used to represent the
  background gene list. This would be used in the case when
  the input pSI data set is comprised of genes derived from
  the same species as the genes found in the candidate gene
  list. \code{background} can take on two other values, the
  first of which is \code{"human.mouse"}.
  \code{"human.mouse"} indicates that the background gene
  list will be comprised of intersection of two lists: 1)
  all genes in the input pSI dataset (all are human genes),
  2) all genes with clear human-mouse homologs. This option
  would be used in the case when the input data set is
  comprised of human genes (i.e. genes from a human
  microarray) and the candidate gene list being tested is
  comprised of mouse genes. The last value
  \code{background} can take on is \code{"mouse.human"}.
  \code{"mouse.human"} indicates that the background gene
  list will be comprised of intersection of two lists: 1)
  all genes in the input pSI dataset (all are mouse genes),
  2) all genes with clear mouse-human homologs. This option
  would be used in the case when the input data set is
  comprised of mouse genes (i.e. genes from a mouse
  microarray) and the candidate gene list being tested is
  comprised of human genes.}

  \item{p.adjust}{logical. default output is bonferroni
  corrected p-value but if \code{p.adjust} is \code{FALSE},
  nominal p-values will be output.}
}
\description{
\code{fisher.iteration} will test a candidate gene list for
overrepresenation in the various cell type/pSI threshold
combinations produced by the specificty.index function.
NOTE:Supplementary data (human & mouse expression sets,
calculated pSI datasets, etc.) can be found in
\code{pSI.data} package located at the following URL:
\url{http://genetics.wustl.edu/jdlab/psi_package/}
}
\details{
This function is used to answer the question of what is the
probability that a certain number of genes specific to a
certain cell type/sample occured by chance (as usual with
low probabilities corresponding to high statistical
significance). This is accomplished with a binary variable
for each gene in the population with two mutual exclusive
values: 1) The gene is specific to the cell type/sample in
question or 2) The gene is not specific to the cell
type/sample in question
}
\examples{
##load sample pSI output
data(sample.data)
##load sample candidate gene lists
data(candidate.genes)
##run Fisher's exact test for overrperesentation on pSI.out for the AutDB
##candidate gene list across all cell types/sample types & pSI thresholds
fisher.out.AutDB <- fisher.iteration(pSIs=sample.data$pSI.output,
                                         candidate.genes=candidate.genes$AutDB)
}
\author{
Xiaoxiao Xu, Alan B. Wells, David OBrien, Arye Nehorai,
Joseph D. Dougherty
}

