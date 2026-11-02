# Supplementary Data Set 1: Genes Differentially Expressed in Autistic Cortex

Genes differentially expressed (up- and down-regulated) in the cortex of
autistic versus control subjects, from human transcriptomic data
(Voineagu et al. 2011).

## Usage

``` r
dataset.s1
```

## Format

A list of two character vectors of gene symbols:

- `up.regulated`:

  up-regulated genes (N = 234)

- `down.regulated`:

  down-regulated genes (N = 229)

## Source

Voineagu I, Wang X, Johnston P, Lowe JK, Tian Y, Horvath S, et al.
(2011). Transcriptomic analysis of autistic brain reveals convergent
molecular pathology. *Nature* 474:380-384.
[doi:10.1038/nature10110](https://doi.org/10.1038/nature10110)

## Details

Differential expression was assessed with SAM (Significance Analysis of
Microarrays) at FDR \< 0.05 and fold change \> 1.3.

## Examples

``` r
data(dataset.s1)
lengths(dataset.s1)
#>   up.regulated down.regulated 
#>            234            229 
```
