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
  ## how many genes are specific to each mouse cell type at each threshold
  pSI.count(mouse$psi.out)
  ## CSEA of a candidate list against these cell types (a few seconds):
  ## fisher.iteration(mouse$psi.out, candidate.genes$AutDB)
}
#>        RetR.Rods Hyp Hyp.Hcrt  BF BF.Chat  BS BS.chat BS.Slc6a4  Cb Cb.septin4
#> 0.0001        71  13       43   1      22   1      40        24  13         55
#> 0.001         96  25       63   9      41   7      70        33  39        108
#> 0.01         227  60      124  44      90  39     146        56 130        233
#> 0.05         556 243      264 230     205 232     312       121 513        572
#>        Cb.pcp2 Cb.Neurod1 Cb.Lypd6 Cb.grp Cb.Grm2 Cb.Aldh1L1 Cb.cnp Cpu Cpu.D2
#> 0.0001      87         18       37     22      17         31    104   3     32
#> 0.001      109         41       50     39      35         81    175   8     65
#> 0.01       186        136      104     85      92        249    335  60    167
#> 0.05       365        366      208    222     271        632    675 259    452
#>        Cpu.D1 Cpu.Chat Ctx Ctx.pdgfrajd340 Ctx.etv1_ts88 Ctx.pnoc Ctx.Ntsr
#> 0.0001     24       32   0              54            37       18        6
#> 0.001      55       45   2             104            65       37       13
#> 0.01      173      103  37             218           152       65       65
#> 0.05      515      251 217             520           485      150      258
#>        Ctx.glt25d2 Ctx.Aldh1L1 Ctx.cort Ctx.cnp Epi Epi.Chat Spc Spc.Chat
#> 0.0001           5          62        6      77  25       70  28       36
#> 0.001           13         105       17     137  49      105  56       73
#> 0.01            67         224       56     303 107      171 156      151
#> 0.05           300         462      195     603 290      397 540      361
#>        RetC.Cones
#> 0.0001        130
#> 0.001         214
#> 0.01          458
#> 0.05          864
# }
```
