outp <- sample.data$pSI.output
autdb <- candidate.genes$AutDB

test_that("fisher.iteration() reproduces the pSI 1.1 output", {
  expect_identical(fisher.iteration(outp, autdb), fixture("psi11_fisher_AutDB"))
  expect_identical(fisher.iteration(outp, autdb, p.adjust = FALSE), fixture("psi11_fisher_AutDB_nominal"))
  expect_identical(fisher.iteration(outp, candidate.genes$hcrt.genes), fixture("psi11_fisher_hcrt"))
})

test_that("output has one row per cell type, one column per threshold, BH-adjusted by default", {
  adj <- fisher.iteration(outp, autdb)
  nom <- fisher.iteration(outp, autdb, p.adjust = FALSE)
  expect_identical(rownames(adj), colnames(outp))
  expect_identical(colnames(adj), paste(c("0.05", "0.01", "0.001", "1e-04"), "adjusted", sep = " - "))
  expect_identical(colnames(nom), paste(c("0.05", "0.01", "0.001", "1e-04"), "nominal", sep = " - "))
  expect_true(all(unlist(nom) >= 0 & unlist(nom) <= 1))
  expect_true(all(unlist(adj) >= unlist(nom)))
  for (k in seq_len(ncol(adj))) {
    expect_equal(adj[[k]], stats::p.adjust(nom[[k]], method = "BH"))
  }
})

test_that("candidate symbols are matched case-insensitively and duplicates are ignored", {
  ref <- fisher.iteration(outp, autdb)
  expect_identical(fisher.iteration(outp, tolower(autdb)), ref)
  expect_identical(fisher.iteration(outp, c(autdb, autdb[1:10])), ref)
})

test_that("an unknown background is an error", {
  expect_error(fisher.iteration(outp, autdb, background = "fish"), "incorrectly assigned")
})

test_that("a failed kgXref download gives an informative error", {
  local_mocked_bindings(download.file = function(...) stop("simulated network failure"))
  expect_error(
    fisher.iteration(outp, autdb, background = "mouse.human"),
    "Could not download the UCSC kgXref table"
  )
})

test_that("cross-species backgrounds work when the UCSC table can be downloaded", {
  skip_on_cran()
  skip_if_offline("hgdownload.soe.ucsc.edu")
  fi <- fisher.iteration(outp, autdb, background = "human.mouse")
  expect_identical(dim(fi), c(ncol(outp), 4L))
  expect_true(all(unlist(fi) >= 0 & unlist(fi) <= 1))
})
