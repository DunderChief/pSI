outp <- sample.data$pSI.output
thresholds <- c(pSi_0.0001 = 1e-4, pSi_0.001 = 1e-3, pSi_0.01 = 1e-2, pSi_0.05 = 5e-2)

test_that("pSI.list() reproduces the pSI 1.1 output", {
  lst <- pSI.list(outp)
  expect_named(lst, names(thresholds))
  expect_identical(lst, fixture("psi11_list"))
})

test_that("each column holds exactly the genes below the threshold, upper-cased, NA-padded", {
  lst <- pSI.list(outp)
  for (nm in names(thresholds)) {
    df <- lst[[nm]]
    expect_s3_class(df, "data.frame")
    expect_identical(names(df), paste(colnames(outp), sub("pSi_", "", nm), sep = "_"))
    for (j in seq_len(ncol(outp))) {
      expected <- toupper(rownames(outp)[!is.na(outp[, j]) & outp[, j] < thresholds[[nm]]])
      got <- df[, j]
      got <- as.character(got[!is.na(got)])  # an empty column is logical NA
      expect_identical(got, expected)
    }
    expect_equal(nrow(df), max(colSums(!is.na(df))))
  }
})

test_that("pSI.list() writes nothing unless asked, and writes one CSV per threshold when asked", {
  d <- withr::local_tempdir()
  withr::local_dir(d)
  pSI.list(outp)
  expect_length(list.files(d), 0)
  pSI.list(outp, write.csv = TRUE)
  expect_setequal(list.files(d), c("pSi_0.05.csv", "pSi_0.01.csv", "pSi_0.001.csv", "pSi_1e-04.csv"))
})
