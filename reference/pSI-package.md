# pSI: Specificity Index Statistic

Tools for the Specificity Index (pSI) statistic, which identifies genes
enriched in specific cell types or tissues from a matrix of expression
profiles, and for Cell type-Specific Expression Analysis (CSEA) of
candidate gene lists. The typical workflow is:

1.  [`specificity.index`](https://dunderchief.github.io/pSI/reference/specificity.index.md)
    computes pSI values from an expression matrix with genes in rows and
    cell types/samples in columns.

2.  [`pSI.list`](https://dunderchief.github.io/pSI/reference/pSI.list.md)
    and
    [`pSI.count`](https://dunderchief.github.io/pSI/reference/pSI.count.md)
    list and count the genes specific to each cell type at four pSI
    thresholds (0.05, 0.01, 0.001, 0.0001).

3.  [`candidate.overlap`](https://dunderchief.github.io/pSI/reference/candidate.overlap.md)
    and
    [`fisher.iteration`](https://dunderchief.github.io/pSI/reference/fisher.iteration.md)
    intersect a candidate gene list with those specific genes and test
    the overlap for significance with Fisher's exact test.

Bundled example data:
[`sample.data`](https://dunderchief.github.io/pSI/reference/sample.data.md),
[`candidate.genes`](https://dunderchief.github.io/pSI/reference/candidate.genes.md)
and
[`dataset.s1`](https://dunderchief.github.io/pSI/reference/dataset.s1.md).

## Companion data

Precomputed pSI tables for 35 mouse cell types (bacTRAP) and for human
brain regions across development (BrainSpan), formerly the companion
package `pSI.data`, are too large for CRAN and are downloaded on first
use with
[`psi_data`](https://dunderchief.github.io/pSI/reference/psi_data.md).

## References

Dougherty JD, Schmidt EF, Nakajima M, Heintz N (2010). Analytical
approaches to RNA profiling data for the identification of genes
enriched in specific cells. *Nucleic Acids Research* 38(13):4218-4230.
[doi:10.1093/nar/gkq130](https://doi.org/10.1093/nar/gkq130)

Xu X, Wells AB, O'Brien DR, Nehorai A, Dougherty JD (2014). Cell
type-specific expression analysis to identify putative cellular
mechanisms for neurogenetic disorders. *Journal of Neuroscience*
34(4):1420-1431.
[doi:10.1523/JNEUROSCI.4488-13.2014](https://doi.org/10.1523/JNEUROSCI.4488-13.2014)

Wells A, Kopp N, Xu X, O'Brien DR, Yang W, Nehorai A, Adair-Kirk TL,
Kopan R, Dougherty JD (2015). The anatomical distribution of genetic
associations. *Nucleic Acids Research* 43(22):10804-10820.
[doi:10.1093/nar/gkv1262](https://doi.org/10.1093/nar/gkv1262)

## See also

Useful links:

- <https://github.com/DunderChief/pSI>

- Report bugs at <https://github.com/DunderChief/pSI/issues>

## Author

**Maintainer**: David R. O'Brien <dunder.chief@gmail.com>
([ORCID](https://orcid.org/0009-0007-0339-0517))

Authors:

- David R. O'Brien <dunder.chief@gmail.com>
  ([ORCID](https://orcid.org/0009-0007-0339-0517))

- Xiaoxiao Xu

- Alan B. Wells

- Arye Nehorai

- Joseph D. Dougherty
