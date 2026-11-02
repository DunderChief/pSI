# Download the companion pSI data sets (the former pSI.data package)

`psi_data` fetches the precomputed Specificity Index (pSI) tables that
used to be distributed as the companion package `pSI.data`: mouse cell
types profiled by bacTRAP, and human brain regions from BrainSpan. They
are too large for CRAN (about 10 MB together), so they are published as
a release on the pSI GitHub repository and downloaded on first use.

## Usage

``` r
psi_data(dataset = c("mouse", "human"), cache = NULL, quiet = FALSE)
```

## Source

<https://github.com/DunderChief/pSI/releases/tag/pSI.data-1.0>. Mouse
expression data from GEO series GSE13379 and GSE30626; human data from
the BrainSpan Atlas of the Developing Human Brain,
<https://www.brainspan.org>.

## Arguments

- dataset:

  `"mouse"` or `"human"`.

- cache:

  logical or `NULL`; see Details.

- quiet:

  logical. If `TRUE`, no download messages are shown.

## Value

The requested data set, a named list of data frames as described above.
If the file is not already available and cannot be downloaded (for
example when offline), `NULL` is returned invisibly with a message
rather than an error.

## Details

The two data sets, unchanged from pSI.data 1.0 (2014):

- `"mouse"`:

  a list of three data frames of 16907 genes by 35 mouse cell types or
  regions, profiled by translating ribosome affinity purification
  (bacTRAP) on one microarray platform, as of October 2013: `psi.in`
  (averaged expression values), `psi.in.filter` (`NA` marks genes to
  exclude for a cell type) and `psi.out` (pSI values).

- `"human"`:

  a list of two aggregations of BrainSpan RNA-seq data for 16866 genes:
  `developmental.periods` (six brain regions across ten developmental
  periods, 60 columns) and `young.adulthood` (the same six regions for
  young adulthood only). Each holds `psi.in` and `psi.out`.

The `psi.out` tables are ready to use as the `pSIs` argument of
[`fisher.iteration`](https://dunderchief.github.io/pSI/reference/fisher.iteration.md),
[`candidate.overlap`](https://dunderchief.github.io/pSI/reference/candidate.overlap.md),
[`pSI.list`](https://dunderchief.github.io/pSI/reference/pSI.list.md)
and
[`pSI.count`](https://dunderchief.github.io/pSI/reference/pSI.count.md).

Every download is verified against the file's MD5 checksum. Where the
file is kept depends on `cache`. With `cache = TRUE` it goes under the
package's user cache directory, `tools::R_user_dir("pSI", "cache")`, so
later R sessions reuse it. With `cache = FALSE` it goes under
[`tempdir()`](https://rdrr.io/r/base/tempfile.html) and disappears with
the session. The default, `NULL`, asks you once per session when R is
interactive and otherwise behaves like `FALSE`. To skip the question in
every session, set `options(pSI.data.cache = TRUE)` (or `FALSE`) in your
`.Rprofile`. To delete the cached files, remove that directory:
`unlink(tools::R_user_dir("pSI", "cache"), recursive = TRUE)`.

## See also

[`sample.data`](https://dunderchief.github.io/pSI/reference/sample.data.md)
for the small built-in example data.

## Examples

``` r
# \donttest{
## about 4 MB, kept only for this session
mouse <- psi_data("mouse", cache = FALSE)
#> Downloading mouse.rda (4.3 MB) from https://github.com/DunderChief/pSI/releases/download/pSI.data-1.0/mouse.rda
if (!is.null(mouse)) {
  names(mouse)
  dim(mouse$psi.out)
  ## CSEA: is the AutDB candidate list enriched in any mouse cell type?
  fisher.iteration(mouse$psi.out, candidate.genes$AutDB)
}
#>                 0.05 - adjusted 0.01 - adjusted 0.001 - adjusted
#> RetR.Rods          7.449052e-01     0.835318816        1.0000000
#> Hyp                1.428057e-01     0.701482667        1.0000000
#> Hyp.Hcrt           6.964979e-01     0.744652895        0.9763077
#> BF                 1.941180e-02     0.835318816        1.0000000
#> BF.Chat            7.258860e-02     0.240080559        0.8491814
#> BS                 3.099572e-01     0.114810985        0.1888174
#> BS.chat            8.915541e-01     0.835318816        1.0000000
#> BS.Slc6a4          2.581054e-01     0.688489098        0.7185308
#> Cb                 1.428057e-01     0.835318816        1.0000000
#> Cb.septin4         4.954710e-01     0.744652895        1.0000000
#> Cb.pcp2            5.132206e-01     0.835318816        1.0000000
#> Cb.Neurod1         6.402928e-01     0.798355047        1.0000000
#> Cb.Lypd6           2.540340e-01     0.835318816        1.0000000
#> Cb.grp             4.848021e-01     0.798355047        1.0000000
#> Cb.Grm2            2.838006e-01     1.000000000        1.0000000
#> Cb.Aldh1L1         4.954710e-01     0.835318816        1.0000000
#> Cb.cnp             5.282949e-01     0.835318816        1.0000000
#> Cpu                1.925814e-03     0.100231191        1.0000000
#> Cpu.D2             2.407722e-06     0.057825501        0.7185308
#> Cpu.D1             5.244334e-06     0.010701978        0.7185308
#> Cpu.Chat           1.489991e-01     0.318225674        0.8491814
#> Ctx                1.504973e-01     0.395044660        1.0000000
#> Ctx.pdgfrajd340    7.810931e-01     0.931021473        1.0000000
#> Ctx.etv1_ts88      1.489991e-01     0.835318816        1.0000000
#> Ctx.pnoc           1.143759e-03     0.003325116        0.3999107
#> Ctx.Ntsr           1.157879e-08     0.050772523        0.8512958
#> Ctx.glt25d2        1.877604e-02     0.114810985        1.0000000
#> Ctx.Aldh1L1        4.954710e-01     0.835318816        1.0000000
#> Ctx.cort           1.934004e-04     0.095320891        1.0000000
#> Ctx.cnp            5.132206e-01     0.835318816        1.0000000
#> Epi                6.990869e-04     0.910424027        1.0000000
#> Epi.Chat           1.504973e-01     0.744652895        1.0000000
#> Spc                2.315843e-01     0.835318816        0.9179855
#> Spc.Chat           5.132206e-01     1.000000000        1.0000000
#> RetC.Cones         6.402928e-01     0.835318816        1.0000000
#>                 1e-04 - adjusted
#> RetR.Rods              1.0000000
#> Hyp                    1.0000000
#> Hyp.Hcrt               1.0000000
#> BF                     1.0000000
#> BF.Chat                0.5164376
#> BS                     0.2887857
#> BS.chat                1.0000000
#> BS.Slc6a4              0.5164376
#> Cb                     0.9729095
#> Cb.septin4             1.0000000
#> Cb.pcp2                1.0000000
#> Cb.Neurod1             1.0000000
#> Cb.Lypd6               1.0000000
#> Cb.grp                 1.0000000
#> Cb.Grm2                1.0000000
#> Cb.Aldh1L1             1.0000000
#> Cb.cnp                 1.0000000
#> Cpu                    1.0000000
#> Cpu.D2                 0.5684382
#> Cpu.D1                 1.0000000
#> Cpu.Chat               1.0000000
#> Ctx                    1.0000000
#> Ctx.pdgfrajd340        1.0000000
#> Ctx.etv1_ts88          1.0000000
#> Ctx.pnoc               0.1056685
#> Ctx.Ntsr               0.5684382
#> Ctx.glt25d2            1.0000000
#> Ctx.Aldh1L1            1.0000000
#> Ctx.cort               1.0000000
#> Ctx.cnp                1.0000000
#> Epi                    1.0000000
#> Epi.Chat               1.0000000
#> Spc                    1.0000000
#> Spc.Chat               1.0000000
#> RetC.Cones             1.0000000
# }
```
