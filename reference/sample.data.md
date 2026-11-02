# Sample Input and Output pSI Data Sets

A sample expression matrix and the corresponding specificity index (pSI)
output, used to illustrate the `pSI` package functions.

## Usage

``` r
sample.data
```

## Format

A list of two data frames, each with 16866 rows (genes, as row names)
and 6 columns (brain regions):

- `pSI.input`:

  expression values

- `pSI.output`:

  pSI values, `NA` where the gene is not specific to that region

## Source

BrainSpan: Atlas of the Developing Human Brain,
<https://www.brainspan.org>

## Details

`pSI.input` is the BrainSpan RNA-seq data for young adulthood, condensed
into six major regional divisions (one column per region). `pSI.output`
is the pSI table calculated from it with
[`specificity.index`](https://dunderchief.github.io/pSI/reference/specificity.index.md).

## Examples

``` r
data(sample.data)
str(sample.data, max.level = 1)
#> List of 2
#>  $ pSI.input :'data.frame':  16866 obs. of  6 variables:
#>  $ pSI.output:'data.frame':  16866 obs. of  6 variables:
head(sample.data$pSI.input)
#>          Amygdala.Young.Adulthood Cerebellum.Young.Adulthood
#> TSPAN6                 3.31592214                1.457258429
#> TNMD                   0.09627143                0.008145143
#> DPM1                   6.17825386                7.721849571
#> SCYL3                  1.33179186                2.281492000
#> C1orf112               0.40113643                0.559218857
#> FGR                    1.23435471                1.399970857
#>          Cortex.Young.Adulthood Hippocampus.Young.Adulthood
#> TSPAN6               2.18115967                   4.9795981
#> TNMD                 0.09390204                   0.2103479
#> DPM1                 7.45179644                   6.3646074
#> SCYL3                1.56291826                   1.2444017
#> C1orf112             0.36801960                   0.2937240
#> FGR                  1.23121465                   1.3375270
#>          Striatum.Young.Adulthood Thalamus.Young.Adulthood
#> TSPAN6                 2.99049286               2.02080371
#> TNMD                   0.02120714               0.01032114
#> DPM1                   6.07945043               4.76993557
#> SCYL3                  1.22306457               0.86949514
#> C1orf112               0.40029029               0.26962957
#> FGR                    1.77013057               1.81920600
```
