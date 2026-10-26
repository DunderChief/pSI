# Regression check of the current source tree against pSI 1.1 as published on
# CRAN. Run from the package root:
#     Rscript dev/regression_vs_1.1.R
# Needs: gdata (pSI 1.1 depends on it), internet access (fetches the 1.1
# tarball from the CRAN archive), about a minute. The fixtures used by
# tests/testthat were produced the same way; see tests/testthat/fixtures/README.md.

if (!requireNamespace("gdata", quietly = TRUE)) stop("pSI 1.1 needs gdata: install.packages('gdata')")
work <- tempfile("psi-regress-"); dir.create(work)
lib11 <- file.path(work, "lib11"); libnew <- file.path(work, "libnew")
dir.create(lib11); dir.create(libnew)
tarball11 <- file.path(work, "pSI_1.1.tar.gz")
download.file("https://cran.r-project.org/src/contrib/Archive/pSI/pSI_1.1.tar.gz", tarball11, mode = "wb", quiet = TRUE)
message("installing pSI 1.1 and the current source into temporary libraries ...")
stopifnot(system2("R", c("CMD", "INSTALL", "--no-docs", "-l", shQuote(lib11), shQuote(tarball11)), stdout = FALSE, stderr = FALSE) == 0)
stopifnot(system2("R", c("CMD", "INSTALL", "--no-docs", "-l", shQuote(libnew), "."), stdout = FALSE, stderr = FALSE) == 0)

runner <- file.path(work, "run.R")
writeLines(c(
  'args <- commandArgs(TRUE); .libPaths(c(args[1], .libPaths()))',
  'suppressPackageStartupMessages(library(pSI)); data(sample.data); data(candidate.genes)',
  'inp <- sample.data$pSI.input; outp <- sample.data$pSI.output; filt <- inp; filt[1:500, ] <- NA',
  'r <- list(version = as.character(packageVersion("pSI")))',
  'set.seed(42); r$si        <- specificity.index(inp, e_min = 20)',
  'set.seed(42); r$si_SI     <- specificity.index(inp, e_min = 20, SI = TRUE)',
  'set.seed(42); r$si_filter <- specificity.index(inp, pSI.in.filter = filt, e_min = 20)',
  'set.seed(7);  r$si_bts10  <- specificity.index(inp, bts = 10, p_max = 0.2, e_min = 5)',
  'r$lst <- pSI.list(outp, write.csv = FALSE); r$cnt <- pSI.count(outp)',
  'r$ov_upper <- candidate.overlap(outp, toupper(candidate.genes$AutDB))',
  'r$ov_ret   <- candidate.overlap(outp, candidate.genes$retinopathy.genes)',
  'r$fi       <- fisher.iteration(outp, candidate.genes$AutDB)',
  'r$fi_nom   <- fisher.iteration(outp, candidate.genes$AutDB, p.adjust = FALSE)',
  'r$fi_hcrt  <- fisher.iteration(outp, candidate.genes$hcrt.genes)',
  'saveRDS(r, args[2])'), runner)
run <- function(lib) { out <- tempfile(fileext = ".rds"); stopifnot(system2("Rscript", c(shQuote(runner), shQuote(lib), shQuote(out))) == 0); readRDS(out) }
a <- run(lib11); b <- run(libnew)
message("comparing pSI ", a$version, " with pSI ", b$version, " (current source)")
ok <- TRUE
for (n in setdiff(names(a), "version")) {
  same <- identical(a[[n]], b[[n]]); ok <- ok && same
  cat(sprintf("  %-10s %s\n", n, if (same) "identical" else "DIFFERENT"))
}
if (!ok) stop("current source does not reproduce pSI 1.1") else message("all outputs identical")
