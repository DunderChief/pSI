# pSI 1.2.0

pSI is back on CRAN after being archived in September 2020, when email to the
previous maintainer's address started bouncing. David R. O'Brien, a co-author
since version 1.0, is the new maintainer. The five exported functions keep
their names, arguments and results; the changes below are packaging and
CRAN-policy fixes plus two small bug fixes.

## New

* `psi_data()` downloads the companion data sets formerly distributed as the
  `pSI.data` package (35 mouse bacTRAP cell types and human BrainSpan brain
  regions) from this package's GitHub releases, verifies each file's checksum,
  and keeps it under `tools::R_user_dir("pSI", "cache")` only with the user's
  consent (otherwise in `tempdir()`). When offline it returns `NULL` with a
  message rather than an error. pSI therefore now requires R >= 4.0.0.

## Behavior changes

* `pSI.list()` no longer writes CSV files unless asked: `write.csv` now
  defaults to `FALSE`, as the documentation always said and as the other
  functions already did. CRAN packages may not write to the working directory
  by default.
* `specificity.index(hist = TRUE)` draws the rank histograms on the current
  graphics device (one page per cell type) instead of writing PNG files into
  the working directory. The new `hist_file` argument writes them to a
  multi-page PDF instead. The device is closed and graphical parameters are
  restored on exit.
* `candidate.overlap()` now compares gene symbols in upper case on both sides,
  as `fisher.iteration()` already did. Lower-case (e.g. mouse) candidate
  symbols previously never matched and silently gave empty overlaps.
* `fisher.iteration(background = "human.mouse")` and `"mouse.human"` download
  the UCSC kgXref table over HTTPS from hgdownload.soe.ucsc.edu in binary mode
  (the previous text-mode download produced a corrupt file on Windows) and
  stop with an informative message if the download fails.

## Packaging and documentation

* gdata is no longer a dependency. The one function used, `cbindX()`, is
  replaced by an internal helper with identical output.
* `Authors@R` with ORCID for the maintainer; `Encoding: UTF-8`; `URL` and
  `BugReports`; explicit imports of the base-R functions used; `NEWS.md`;
  `LICENSE.md`; roxygen2-generated documentation and `NAMESPACE`.
* Every exported function now documents its return value. Descriptions that
  said six pSI thresholds now say four, and `fisher.iteration()` is documented
  as using Benjamini-Hochberg (not Bonferroni) adjustment, which is what the
  code has always done.
* The download URL for the companion data package `pSI.data`
  (genetics.wustl.edu) no longer exists and has been removed from the
  documentation; see the README for where the data live now. Other links were
  updated to their current locations or replaced by DOIs.

# pSI 1.1 (2014-01-30)

* URL to download pSI.data package was added to package documentation to
  facilitate use of sample mouse & human data and allow for reproducible
  research.
* `fisher.iteration` function now excludes duplicated genes in user supplied
  candidate gene list.

# pSI 1.0 (2014-01-10)

* First CRAN release.
