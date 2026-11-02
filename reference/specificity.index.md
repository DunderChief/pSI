# Specificity Index Statistic

`specificity.index` calculates the specificity index statistic (pSI) for
every gene in every cell type/sample of an expression matrix. The pSI
identifies genes enriched in specific cell populations across a large
number of profiles, and correctly predicts in situ hybridization
patterns for many cell types (Dougherty et al. 2010).

## Usage

``` r
specificity.index(
  pSI.in,
  pSI.in.filter,
  bts = 50,
  p_max = 0.1,
  e_min = 0.3,
  hist = FALSE,
  SI = FALSE,
  hist_file = NULL
)
```

## Arguments

- pSI.in:

  data frame with expression values for genes in rows and samples or
  cell types in columns (replicate arrays already averaged, so one
  column per cell type).

- pSI.in.filter:

  optional matched data frame (same genes and samples) with `NA` for any
  gene that should be excluded for a particular cell type.

- bts:

  numeric. Number of resampled distributions to average for the
  permutation test.

- p_max:

  numeric. Maximum p-value to calculate; genes with larger p-values are
  returned as `NA`.

- e_min:

  numeric. Minimum expression value for a gene to be included. A value
  of 50 has been used for microarray studies and 0.3 for RNA-seq
  studies.

- hist:

  logical. If `TRUE`, draw histograms of the sampled (null) and actual
  distributions of mean gene rank for each cell type on the current
  graphics device, one page per cell type. (Before pSI 1.2.0 these were
  written as PNG files into the working directory.)

- SI:

  logical. If `TRUE`, return the specificity index (mean rank) itself
  instead of the pSI p-value.

- hist_file:

  optional path to a PDF file. If supplied, the histograms are written
  there (one page per cell type) instead of to the current device, and
  `hist` is treated as `TRUE`.

## Value

A data frame with the same row and column names as `pSI.in`. Each cell
holds the pSI value (a p-value) of that gene for that cell type/sample,
or `NA` if the gene was excluded (expression below `e_min`, filtered by
`pSI.in.filter`, or p-value above `p_max`). With `SI = TRUE` the
specificity index is returned instead of the p-value.

## Details

For cell type 1 and gene \\n\\, the specificity index is the mean, over
the other \\m-1\\ cell types \\k\\, of the rank (among all genes) of the
expression ratio of that gene between cell type 1 and cell type \\k\\:
\$\$SI\_{n,1}= \frac{ \sum\_{k=2}^m rank( \frac{ IP\_{1,n} }{ IP\_{k,n}
}) }{m-1}\$\$ A low SI means the gene is highly enriched in cell type 1
relative to the others. The pSI is a p-value for the observed SI,
obtained by comparing it with a null distribution of SI values computed
from `bts` expression matrices resampled with replacement. To save time
it is only calculated for genes whose p-value is below `p_max`; all
other genes, and genes with expression below `e_min` or set to `NA` in
`pSI.in.filter`, are returned as `NA`.

Because the null distribution is resampled, results vary slightly from
run to run; call [`set.seed`](https://rdrr.io/r/base/Random.html) first
for a reproducible result.

## References

Dougherty JD, Schmidt EF, Nakajima M, Heintz N (2010). Analytical
approaches to RNA profiling data for the identification of genes
enriched in specific cells. *Nucleic Acids Research* 38(13):4218-4230.
[doi:10.1093/nar/gkq130](https://doi.org/10.1093/nar/gkq130)

## See also

[`pSI.list`](https://dunderchief.github.io/pSI/reference/pSI.list.md),
[`pSI.count`](https://dunderchief.github.io/pSI/reference/pSI.count.md),
[`candidate.overlap`](https://dunderchief.github.io/pSI/reference/candidate.overlap.md),
[`fisher.iteration`](https://dunderchief.github.io/pSI/reference/fisher.iteration.md)

## Author

Xiaoxiao Xu, Alan B. Wells, David R. O'Brien, Arye Nehorai, Joseph D.
Dougherty

## Examples

``` r
##load sample expression matrix
data(sample.data)
##calculate specificity index on expression matrix
##(Normally for RNAseq data, and e_min of 0.3, microarrays: e_min= 50)
set.seed(1)
pSI.output <- specificity.index(pSI.in=sample.data$pSI.input, e_min=20)
head(pSI.output[rowSums(!is.na(pSI.output)) > 0, ])
#>         Amygdala.Young.Adulthood Cerebellum.Young.Adulthood
#> HS3ST1                        NA                 0.02097571
#> CYP26B1                       NA                 0.00108459
#> DBNDD1                        NA                         NA
#> FKBP4                         NA                 0.07943886
#> CAMKK1                        NA                         NA
#> PRKAR2B                       NA                         NA
#>         Cortex.Young.Adulthood Hippocampus.Young.Adulthood
#> HS3ST1                      NA                          NA
#> CYP26B1                     NA                          NA
#> DBNDD1                      NA                          NA
#> FKBP4                       NA                          NA
#> CAMKK1              0.02654505                          NA
#> PRKAR2B             0.06262613                          NA
#>         Striatum.Young.Adulthood Thalamus.Young.Adulthood
#> HS3ST1                        NA                       NA
#> CYP26B1                       NA                       NA
#> DBNDD1                        NA              0.007593712
#> FKBP4                         NA                       NA
#> CAMKK1                        NA                       NA
#> PRKAR2B                       NA                       NA

##histograms of the sampled and actual rank distributions, to a temporary PDF
pdf_file <- tempfile(fileext = ".pdf")
pSI.output <- specificity.index(pSI.in=sample.data$pSI.input, e_min=20,
                                hist_file=pdf_file)
unlink(pdf_file)
```
