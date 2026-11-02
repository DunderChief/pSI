## Resubmission of an archived package with a new maintainer

pSI 1.0 and 1.1 were published on CRAN in January 2014. The package was
archived on 2020-09-11 because email to the maintainer address
(Alan B. Wells, awells@dsgmail.wustl.edu) bounced. This was an administrative
archival, not a check failure.

* The previous maintainer has left the lab and cannot be reached at that
  address.
* The new maintainer, David R. O'Brien, is a co-author of the package, listed
  in DESCRIPTION since version 1.0, and a co-author of the package paper
  (Xu et al. 2014, <doi:10.1523/JNEUROSCI.4488-13.2014>).
* The lab PI and co-author, Joseph D. Dougherty, agreed in writing on
  2026-10-22 to the change of maintainer. His email is available on request.

## Changes since 1.1

The public API is unchanged: the same five exported functions with the same
arguments, and their results on the bundled data are identical to 1.1 (checked
by regression tests). The changes are CRAN-policy and packaging fixes, listed
in NEWS.md:

* `pSI.list()` no longer writes CSV files into the working directory by
  default.
* `specificity.index(hist = TRUE)` no longer writes PNG files into the working
  directory; it draws on the current device or, with the new `hist_file`
  argument, into a user-supplied PDF path. The device and graphical parameters
  are restored on exit.
* The optional internet access in `fisher.iteration()` fails gracefully with an
  informative message.
* The unused `gdata` dependency was removed; base-R functions are imported
  explicitly.
* roxygen2 documentation with `\value` for every exported function;
  `Authors@R`; DOIs for all references; dead URLs removed.
* Examples and tests write only to `tempdir()`.
* New `psi_data()` downloads the 10 MB companion data (formerly the `pSI.data`
  package, never on CRAN) from a GitHub release of this package on first use.
  It verifies checksums, writes outside `tempdir()` only with the user's
  consent (`tools::R_user_dir()`, hence `R (>= 4.0.0)`), and returns `NULL`
  with a message if the download fails. Its example is in `\donttest` and
  tolerates being offline; the test that fetches the real files is skipped on
  CRAN, the rest of its tests use a mocked download.

## Test environments

* Local: R 4.5.3 on x86_64 Linux (Ubuntu), `R CMD check --as-cran`.
* R Under development (unstable) (2026-10-19 r90708) on x86_64 Linux, in the
  rocker/r-devel Docker image, `R CMD check --as-cran`.
* TODO before submission: win-builder (R-devel) and the GitHub Actions matrix
  (Linux devel/release/oldrel-1, macOS release, Windows release).

## R CMD check results

0 errors | 0 warnings | 1 note

* checking CRAN incoming feasibility ... NOTE
  New submission; Package was archived on CRAN; new maintainer. All three
  are explained above.

## Downstream dependencies

pSI has no reverse dependencies on CRAN.
