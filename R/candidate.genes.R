#' Candidate Gene Lists
#'
#' Five candidate gene lists, provided as examples for use with
#' \code{\link{fisher.iteration}} and \code{\link{candidate.overlap}}.
#'
#' @format A list of five character vectors of official gene symbols:
#' \describe{
#'   \item{\code{AutDB}}{Hand-curated list of Autism Spectrum Disorder (ASD)
#'     candidate genes derived from human genetics studies, downloaded from
#'     AutDB (N = 328).}
#'   \item{\code{protein.disrupting.rdnv}}{Genes affected by protein-disrupting
#'     rare de novo variants in ASD probands, collected from four exome studies
#'     published in 2012 (N = 122).}
#'   \item{\code{silent.rdnv}}{Negative control: genes affected by silent rare
#'     de novo variants in unaffected siblings, from the same four studies
#'     (N = 122).}
#'   \item{\code{hcrt.genes}}{Genes differentially regulated in narcoleptic
#'     mice with hypocretin (Hcrt) neuron ablation versus controls (N = 63).}
#'   \item{\code{retinopathy.genes}}{Genes implicated in human congenital
#'     retinopathies, from the curated RetNet database (N = 120).}
#' }
#' @source
#' \code{AutDB}: Basu SN, Kollu R, Banerjee-Basu S (2009). AutDB: a gene
#' reference resource for autism research. \emph{Nucleic Acids Research}
#' 37:D832-D836. \doi{10.1093/nar/gkn835}
#'
#' \code{protein.disrupting.rdnv} and \code{silent.rdnv}:
#' Iossifov I, Ronemus M, Levy D, et al. (2012). De novo gene disruptions in
#' children on the autistic spectrum. \emph{Neuron} 74:285-299.
#' \doi{10.1016/j.neuron.2012.04.009}.
#' Neale BM, Kou Y, Liu L, et al. (2012). Patterns and rates of exonic de novo
#' mutations in autism spectrum disorders. \emph{Nature} 485:242-245.
#' \doi{10.1038/nature11011}.
#' Sanders SJ, Murtha MT, Gupta AR, et al. (2012). De novo mutations revealed
#' by whole-exome sequencing are strongly associated with autism.
#' \emph{Nature} 485:237-241. \doi{10.1038/nature10945}.
#' O'Roak BJ, Vives L, Girirajan S, et al. (2012). Sporadic autism exomes
#' reveal a highly interconnected protein network of de novo mutations.
#' \emph{Nature} 485:246-250. \doi{10.1038/nature10989}.
#'
#' \code{hcrt.genes}: Honda M, Eriksson KS, Zhang S, et al. (2009). IGFBP3
#' colocalizes with and regulates hypocretin (orexin). \emph{PLoS ONE}
#' 4:e4254. \doi{10.1371/journal.pone.0004254}
#'
#' \code{retinopathy.genes}: Daiger SP. RetNet, the Retinal Information
#' Network. \url{https://web.sph.uth.edu/RetNet/}
#' @examples
#' data(candidate.genes)
#' names(candidate.genes)
#' lengths(candidate.genes)
#' head(candidate.genes$AutDB)
"candidate.genes"
