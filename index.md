# pSI: Specificity Index Statistic

pSI calculates the **Specificity Index (pSI)** statistic, which
identifies genes enriched in specific cell types or tissues from a
matrix of expression profiles, and performs **Cell type-Specific
Expression Analysis (CSEA)**: testing whether a candidate gene list, for
example genes associated with a disorder, is over-represented among the
genes specific to each cell type. The method comes from the [Dougherty
lab](https://sites.wustl.edu/doughertylab/) at Washington University in
St. Louis.

## Installation

From CRAN (once version 1.2.0 is accepted):

``` r

install.packages("pSI")
```

The development version, from GitHub:

``` r

# install.packages("pak")
pak::pak("DunderChief/pSI")
```

## Quick start

``` r

library(pSI)

# 1. Compute pSI values from an expression matrix: genes in rows, cell types
#    (or tissues, or brain regions) in columns. The bundled sample.data$pSI.input
#    is BrainSpan RNA-seq data for six adult brain regions.
set.seed(1)
psi <- specificity.index(pSI.in = sample.data$pSI.input, e_min = 20)

# 2. Which genes are specific to each region, and how many, at the four
#    standard pSI thresholds (0.05, 0.01, 0.001, 0.0001)?
specific_genes <- pSI.list(sample.data$pSI.output)
pSI.count(sample.data$pSI.output)

# 3. CSEA: is a candidate gene list enriched among the genes specific to any
#    region? Benjamini-Hochberg adjusted p-values from Fisher's exact test ...
fisher.iteration(sample.data$pSI.output, candidate.genes$AutDB)
# ... and the overlapping genes themselves
candidate.overlap(sample.data$pSI.output, candidate.genes$AutDB)
```

See
[`?specificity.index`](https://dunderchief.github.io/pSI/reference/specificity.index.md)
for the statistic and its parameters, and the [package
website](https://dunderchief.github.io/pSI/) for the full reference.

## Companion data (the former pSI.data package)

Precomputed pSI tables for 35 mouse cell types (bacTRAP, as of October
2013) and for human brain regions across development (BrainSpan), used
in the CSEA paper, were distributed as the companion package `pSI.data`.
At 10 MB they were never on CRAN. They now live as a [GitHub
release](https://github.com/DunderChief/pSI/releases/tag/pSI.data-1.0)
of this repository, unchanged from the 2014 originals, and the package
fetches them on demand:

``` r

mouse <- psi_data("mouse")   # asks once whether to keep a local copy
human <- psi_data("human")

# CSEA of a candidate list against the 35 mouse cell types
fisher.iteration(mouse$psi.out, candidate.genes$AutDB)
```

[`psi_data()`](https://dunderchief.github.io/pSI/reference/psi_data.md)
verifies each download against its checksum and returns `NULL` with a
message, rather than an error, if the files cannot be fetched. See
[`?psi_data`](https://dunderchief.github.io/pSI/reference/psi_data.md)
for what the two lists contain and how caching works.

## Citing pSI

Run `citation("pSI")`. The package and the CSEA method are described in:

- Xu X, Wells AB, O’Brien DR, Nehorai A, Dougherty JD (2014). Cell
  type-specific expression analysis to identify putative cellular
  mechanisms for neurogenetic disorders. *Journal of Neuroscience*
  34(4):1420-1431. <https://doi.org/10.1523/JNEUROSCI.4488-13.2014>

The specificity index statistic itself:

- Dougherty JD, Schmidt EF, Nakajima M, Heintz N (2010). Analytical
  approaches to RNA profiling data for the identification of genes
  enriched in specific cells. *Nucleic Acids Research* 38(13):4218-4230.
  <https://doi.org/10.1093/nar/gkq130>

Tissue-specific expression analysis (TSEA) with pSI:

- Wells A, Kopp N, Xu X, O’Brien DR, Yang W, Nehorai A, Adair-Kirk TL,
  Kopan R, Dougherty JD (2015). The anatomical distribution of genetic
  associations. *Nucleic Acids Research* 43(22):10804-10820.
  <https://doi.org/10.1093/nar/gkv1262>

## History

pSI 1.0 and 1.1 were released on CRAN in January 2014, maintained by
Alan B. Wells. The package was archived in September 2020 when the
maintainer’s email address stopped working. Version 1.2.0 brings it back
to CRAN with David R. O’Brien, a co-author since 1.0, as maintainer. The
five exported functions keep their names, arguments and results; see the
[changelog](https://dunderchief.github.io/pSI/news/index.html) for what
changed.

## License

GPL (\>= 2). Copyright the authors: Xiaoxiao Xu, Alan B. Wells, David R.
O’Brien, Arye Nehorai and Joseph D. Dougherty.
