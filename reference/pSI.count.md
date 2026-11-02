# Convert pSI output to gene counts

`pSI.count` counts the number of genes specific to each cell type/sample
at each of the four standard pSI thresholds (0.05, 0.01, 0.001 and
0.0001).

## Usage

``` r
pSI.count(pSIs, write.csv = FALSE)
```

## Arguments

- pSIs:

  data frame output from
  [`specificity.index`](https://dunderchief.github.io/pSI/reference/specificity.index.md),
  with one column per cell type/sample and genes as rows.

- write.csv:

  logical. If `TRUE`, the table is also written to `gene_count_1.csv` in
  the current working directory. Default `FALSE`.

## Value

A data frame with four rows, one per pSI threshold (`"0.0001"`,
`"0.001"`, `"0.01"`, `"0.05"`), and one column per cell type/sample,
giving the number of genes whose pSI value falls below each threshold.

## See also

[`pSI.list`](https://dunderchief.github.io/pSI/reference/pSI.list.md)
for the gene lists themselves.

## Author

Xiaoxiao Xu, Alan B. Wells, David R. O'Brien, Arye Nehorai, Joseph D.
Dougherty

## Examples

``` r
##load sample pSI output
data(sample.data)
##Count the number of genes specific to each cell type/sample type across all pSI thresholds
pSI.out.count <- pSI.count(pSIs=sample.data$pSI.output)
pSI.out.count
#>        Amygdala.Young.Adulthood Cerebellum.Young.Adulthood
#> 0.0001                        0                         19
#> 0.001                         0                         32
#> 0.01                          0                         84
#> 0.05                         10                        230
#>        Cortex.Young.Adulthood Hippocampus.Young.Adulthood
#> 0.0001                      1                           1
#> 0.001                       3                           5
#> 0.01                       20                          15
#> 0.05                       90                          29
#>        Striatum.Young.Adulthood Thalamus.Young.Adulthood
#> 0.0001                        2                        5
#> 0.001                         8                        9
#> 0.01                         29                       32
#> 0.05                        116                       85
```
