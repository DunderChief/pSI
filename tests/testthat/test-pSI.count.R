outp <- sample.data$pSI.output

test_that("pSI.count() reproduces the pSI 1.1 output", {
  cnt <- pSI.count(outp)
  expect_identical(cnt, fixture("psi11_count"))
  expect_identical(rownames(cnt), c("0.0001", "0.001", "0.01", "0.05"))
  expect_identical(colnames(cnt), colnames(outp))
})

test_that("pSI.count() agrees with pSI.list()", {
  cnt <- pSI.count(outp)
  lst <- pSI.list(outp)
  for (th in rownames(cnt)) {
    expect_equal(unname(unlist(cnt[th, ])), unname(colSums(!is.na(lst[[paste0("pSi_", th)]]))))
  }
})

test_that("pSI.count() writes nothing unless asked", {
  d <- withr::local_tempdir()
  withr::local_dir(d)
  pSI.count(outp)
  expect_length(list.files(d), 0)
  pSI.count(outp, write.csv = TRUE)
  expect_identical(list.files(d), "gene_count_1.csv")
})
