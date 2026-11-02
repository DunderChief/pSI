# Candidate Gene Overlap

`candidate.overlap` extracts the genes specific to each cell type/sample
(as listed by
[`pSI.list`](https://dunderchief.github.io/pSI/reference/pSI.list.md))
that are also present in a candidate gene list, at each of the four
standard pSI thresholds (0.05, 0.01, 0.001 and 0.0001).

## Usage

``` r
candidate.overlap(pSIs, candidate.genes, write.csv = FALSE)
```

## Arguments

- pSIs:

  data frame output from
  [`specificity.index`](https://dunderchief.github.io/pSI/reference/specificity.index.md),
  with one column per cell type/sample and genes as rows.

- candidate.genes:

  character vector of official gene symbols to test for overlap with the
  cell type-specific genes.

- write.csv:

  logical. If `TRUE`, one CSV file per threshold (`pSi_0.0001.csv`,
  `pSi_0.001.csv`, `pSi_0.01.csv`, `pSi_0.05.csv`) is written to the
  current working directory. Default `FALSE`.

## Value

A named list of four data frames (`pSi_0.0001`, `pSi_0.001`, `pSi_0.01`,
`pSi_0.05`), one per pSI threshold, with one column per cell type/sample
listing the candidate genes that are specific to it at that threshold,
padded with `NA`.

## Details

Gene symbols are compared in upper case, so mouse and human symbols can
be matched against each other. (Before pSI 1.2.0 only the `pSIs` row
names were upper-cased, so lower-case candidate symbols silently never
matched.)

## See also

[`fisher.iteration`](https://dunderchief.github.io/pSI/reference/fisher.iteration.md)
to test whether each overlap is larger than expected by chance.

## Author

Xiaoxiao Xu, Alan B. Wells, David R. O'Brien, Arye Nehorai, Joseph D.
Dougherty

## Examples

``` r
##load sample pSI output
data(sample.data)
##load sample candidate gene lists
data(candidate.genes)
##Generates lists of overlapping genes
candidate.gene.overlap.AutDB <- candidate.overlap(pSIs=sample.data$pSI.output,
                                                  candidate.genes=candidate.genes$AutDB)
candidate.gene.overlap.AutDB$pSi_0.01
#>   Amygdala.Young.Adulthood_0.01 Cerebellum.Young.Adulthood_0.01
#> 1                            NA                          CADPS2
#> 2                            NA                             EN2
#> 3                            NA                            RELN
#>   Cortex.Young.Adulthood_0.01 Hippocampus.Young.Adulthood_0.01
#> 1                       MEF2C                            FEZF2
#> 2                        <NA>                             <NA>
#> 3                        <NA>                             <NA>
#>   Striatum.Young.Adulthood_0.01 Thalamus.Young.Adulthood_0.01
#> 1                       ADORA2A                         NTNG1
#> 2                          <NA>                          <NA>
#> 3                          <NA>                          <NA>
```
