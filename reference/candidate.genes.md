# Candidate Gene Lists

Five candidate gene lists, provided as examples for use with
[`fisher.iteration`](https://dunderchief.github.io/pSI/reference/fisher.iteration.md)
and
[`candidate.overlap`](https://dunderchief.github.io/pSI/reference/candidate.overlap.md).

## Usage

``` r
candidate.genes
```

## Format

A list of five character vectors of official gene symbols:

- `AutDB`:

  Hand-curated list of Autism Spectrum Disorder (ASD) candidate genes
  derived from human genetics studies, downloaded from AutDB (N = 328).

- `protein.disrupting.rdnv`:

  Genes affected by protein-disrupting rare de novo variants in ASD
  probands, collected from four exome studies published in 2012 (N =
  122).

- `silent.rdnv`:

  Negative control: genes affected by silent rare de novo variants in
  unaffected siblings, from the same four studies (N = 122).

- `hcrt.genes`:

  Genes differentially regulated in narcoleptic mice with hypocretin
  (Hcrt) neuron ablation versus controls (N = 63).

- `retinopathy.genes`:

  Genes implicated in human congenital retinopathies, from the curated
  RetNet database (N = 120).

## Source

`AutDB`: Basu SN, Kollu R, Banerjee-Basu S (2009). AutDB: a gene
reference resource for autism research. *Nucleic Acids Research*
37:D832-D836.
[doi:10.1093/nar/gkn835](https://doi.org/10.1093/nar/gkn835)

`protein.disrupting.rdnv` and `silent.rdnv`: Iossifov I, Ronemus M, Levy
D, et al. (2012). De novo gene disruptions in children on the autistic
spectrum. *Neuron* 74:285-299.
[doi:10.1016/j.neuron.2012.04.009](https://doi.org/10.1016/j.neuron.2012.04.009)
. Neale BM, Kou Y, Liu L, et al. (2012). Patterns and rates of exonic de
novo mutations in autism spectrum disorders. *Nature* 485:242-245.
[doi:10.1038/nature11011](https://doi.org/10.1038/nature11011) . Sanders
SJ, Murtha MT, Gupta AR, et al. (2012). De novo mutations revealed by
whole-exome sequencing are strongly associated with autism. *Nature*
485:237-241.
[doi:10.1038/nature10945](https://doi.org/10.1038/nature10945) . O'Roak
BJ, Vives L, Girirajan S, et al. (2012). Sporadic autism exomes reveal a
highly interconnected protein network of de novo mutations. *Nature*
485:246-250.
[doi:10.1038/nature10989](https://doi.org/10.1038/nature10989) .

`hcrt.genes`: Honda M, Eriksson KS, Zhang S, et al. (2009). IGFBP3
colocalizes with and regulates hypocretin (orexin). *PLoS ONE* 4:e4254.
[doi:10.1371/journal.pone.0004254](https://doi.org/10.1371/journal.pone.0004254)

`retinopathy.genes`: Daiger SP. RetNet, the Retinal Information Network.
<https://web.sph.uth.edu/RetNet/>

## Examples

``` r
data(candidate.genes)
names(candidate.genes)
#> [1] "AutDB"                   "protein.disrupting.rdnv"
#> [3] "silent.rdnv"             "hcrt.genes"             
#> [5] "retinopathy.genes"      
lengths(candidate.genes)
#>                   AutDB protein.disrupting.rdnv             silent.rdnv 
#>                     328                     122                     122 
#>              hcrt.genes       retinopathy.genes 
#>                      63                     120 
head(candidate.genes$AutDB)
#> [1] "ABAT"    "ADA"     "ADK"     "ADORA2A" "ADRB2"   "ADSL"   
```
