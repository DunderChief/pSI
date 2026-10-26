#' Sample Input and Output pSI Data Sets
#'
#' A sample expression matrix and the corresponding specificity index (pSI)
#' output, used to illustrate the \code{pSI} package functions.
#'
#' @details
#' \code{pSI.input} is the BrainSpan RNA-seq data for young adulthood,
#' condensed into six major regional divisions (one column per region).
#' \code{pSI.output} is the pSI table calculated from it with
#' \code{\link{specificity.index}}.
#'
#' @format A list of two data frames, each with 16866 rows (genes, as row
#'   names) and 6 columns (brain regions):
#' \describe{
#'   \item{\code{pSI.input}}{expression values}
#'   \item{\code{pSI.output}}{pSI values, \code{NA} where the gene is not
#'     specific to that region}
#' }
#' @source BrainSpan: Atlas of the Developing Human Brain,
#'   \url{https://www.brainspan.org}
#' @examples
#' data(sample.data)
#' str(sample.data, max.level = 1)
#' head(sample.data$pSI.input)
"sample.data"
