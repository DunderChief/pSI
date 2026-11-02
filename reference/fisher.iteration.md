# Fisher's Exact Test Across All Cell Types and pSI Thresholds

`fisher.iteration` tests a candidate gene list for over-representation
among the genes specific to each cell type/sample, at each of the four
standard pSI thresholds (0.05, 0.01, 0.001 and 0.0001), using a
one-sided Fisher's exact test.

## Usage

``` r
fisher.iteration(
  pSIs,
  candidate.genes,
  background = "data.set",
  p.adjust = TRUE
)
```

## Arguments

- pSIs:

  data frame output from
  [`specificity.index`](https://dunderchief.github.io/pSI/reference/specificity.index.md),
  with one column per cell type/sample and genes as rows.

- candidate.genes:

  character vector of official gene symbols to test for
  over-representation.

- background:

  character string naming the background gene list for the test. The
  default `"data.set"` uses all genes in `pSIs`; use it when the
  candidate genes and the pSI data set come from the same species.
  `"human.mouse"` restricts the background to the genes in `pSIs`
  (human) that have a clear mouse homolog, for testing a mouse candidate
  list against a human pSI data set; `"mouse.human"` is the converse.
  These two options download the UCSC kgXref table for mm10 or hg19 (a
  file of several megabytes) from <https://hgdownload.soe.ucsc.edu/> and
  stop with an informative error if the download fails.

- p.adjust:

  logical. If `TRUE` (the default) p-values are adjusted for multiple
  testing across cell types with the Benjamini-Hochberg method
  ([`p.adjust`](https://rdrr.io/r/stats/p.adjust.html), method `"BH"`),
  separately for each threshold; if `FALSE`, nominal p-values are
  returned.

## Value

A data frame with one row per cell type/sample and four columns, one per
pSI threshold (0.05, 0.01, 0.001, 0.0001). Column names end in
`"adjusted"` or `"nominal"` depending on `p.adjust`.

## Details

For every cell type/threshold combination the function asks: what is the
probability that this many candidate genes would be specific to this
cell type by chance? Each gene in the background is classified by two
binary variables, specific to the cell type at this threshold or not,
and in the candidate list or not, and the resulting 2 x 2 table is
tested with [`fisher.test`](https://rdrr.io/r/stats/fisher.test.html)
(alternative `"greater"`). Gene symbols are compared in upper case, and
duplicated candidate genes are counted once.

## See also

[`candidate.overlap`](https://dunderchief.github.io/pSI/reference/candidate.overlap.md)
for the overlapping genes themselves.

## Author

Xiaoxiao Xu, Alan B. Wells, David R. O'Brien, Arye Nehorai, Joseph D.
Dougherty

## Examples

``` r
##load sample pSI output
data(sample.data)
##load sample candidate gene lists
data(candidate.genes)
##run Fisher's exact test for overrepresentation on pSI.out for the AutDB
##candidate gene list across all cell types/sample types & pSI thresholds
fisher.out.AutDB <- fisher.iteration(pSIs=sample.data$pSI.output,
                                     candidate.genes=candidate.genes$AutDB)
fisher.out.AutDB
#>                             0.05 - adjusted 0.01 - adjusted 0.001 - adjusted
#> Amygdala.Young.Adulthood          1.0000000       1.0000000        1.0000000
#> Cerebellum.Young.Adulthood        0.1782927       0.5452343        0.1298184
#> Cortex.Young.Adulthood            0.2663041       0.5452343        1.0000000
#> Hippocampus.Young.Adulthood       0.6336715       0.5452343        0.2348364
#> Striatum.Young.Adulthood          0.7711528       0.5452343        0.2348364
#> Thalamus.Young.Adulthood          0.4268605       0.5452343        0.2348364
#>                             1e-04 - adjusted
#> Amygdala.Young.Adulthood                   1
#> Cerebellum.Young.Adulthood                 1
#> Cortex.Young.Adulthood                     1
#> Hippocampus.Young.Adulthood                1
#> Striatum.Young.Adulthood                   1
#> Thalamus.Young.Adulthood                   1
```
