# Convert pSI output to gene lists

`pSI.list` extracts, for each cell type/sample and each of the four
standard pSI thresholds (0.05, 0.01, 0.001 and 0.0001), the genes whose
pSI values fall below the threshold, i.e. the genes specific to that
cell type.

## Usage

``` r
pSI.list(pSIs, write.csv = FALSE)
```

## Arguments

- pSIs:

  data frame output from
  [`specificity.index`](https://dunderchief.github.io/pSI/reference/specificity.index.md),
  with one column per cell type/sample and genes as rows.

- write.csv:

  logical. If `TRUE`, one CSV file per threshold (`pSi_0.05.csv`,
  `pSi_0.01.csv`, `pSi_0.001.csv`, `pSi_1e-04.csv`) is written to the
  current working directory. The default is `FALSE`: since pSI 1.2.0
  nothing is written unless you ask for it.

## Value

A named list of four data frames (`pSi_0.0001`, `pSi_0.001`, `pSi_0.01`,
`pSi_0.05`), one per pSI threshold. Each has one column per cell
type/sample, named `<sample>_<threshold>`, containing the symbols of the
genes with pSI below that threshold, padded with `NA`.

## Details

Gene symbols are converted to upper case for consistency in downstream
analysis. Within each data frame the columns hold different numbers of
genes and are padded with `NA` to equal length.

## See also

[`pSI.count`](https://dunderchief.github.io/pSI/reference/pSI.count.md)
for the counts alone,
[`candidate.overlap`](https://dunderchief.github.io/pSI/reference/candidate.overlap.md)
to intersect these lists with a candidate gene list.

## Author

Xiaoxiao Xu, Alan B. Wells, David R. O'Brien, Arye Nehorai, Joseph D.
Dougherty

## Examples

``` r
##load sample pSI output
data(sample.data)
##List the genes specific to each cell type/sample type across all pSI thresholds
pSI.out.list <- pSI.list(pSIs=sample.data$pSI.output)
names(pSI.out.list)
#> [1] "pSi_0.0001" "pSi_0.001"  "pSi_0.01"   "pSi_0.05"  
head(pSI.out.list$pSi_0.01)
#>   Amygdala.Young.Adulthood_0.01 Cerebellum.Young.Adulthood_0.01
#> 1                            NA                         CYP26B1
#> 2                            NA                            ETV1
#> 3                            NA                            PAX6
#> 4                            NA                          TSPAN9
#> 5                            NA                         TMEM159
#> 6                            NA                            ZIC2
#>   Cortex.Young.Adulthood_0.01 Hippocampus.Young.Adulthood_0.01
#> 1                       NUAK1                            FBLN1
#> 2                       MEF2C                            CABP7
#> 3                         NLK                            ICAM5
#> 4                        CHGA                             SOD3
#> 5                       NCALD                            FOLR1
#> 6                       STX1A                              TTR
#>   Striatum.Young.Adulthood_0.01 Thalamus.Young.Adulthood_0.01
#> 1                          TAC1                        DBNDD1
#> 2                         ACTN2                          OPN3
#> 3                          TESC                         PTPN3
#> 4                         RASD2                       SLC17A6
#> 5                          COCH                          NEFH
#> 6                      C20ORF27                          HRH3
```
