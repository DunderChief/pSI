inp <- sample.data$pSI.input

test_that("specificity.index() reproduces the pSI 1.1 output on the bundled data", {
  set.seed(42)
  out <- specificity.index(inp, e_min = 20)
  ref <- fixture("psi11_specificity_index_seed42_emin20")
  expect_s3_class(out, "data.frame")
  expect_identical(dim(out), dim(inp))
  expect_identical(dimnames(out), dimnames(ref))
  expect_identical(is.na(out), is.na(ref))
  expect_equal(out, ref, tolerance = 1e-8)
})

test_that("SI = TRUE returns the specificity index itself", {
  set.seed(42)
  si <- specificity.index(inp, e_min = 20, SI = TRUE)
  expect_equal(si, fixture("psi11_specificity_index_seed42_emin20_SI"), tolerance = 1e-8)
  # the SI is a mean rank, so it lies between 1 and the number of rankable genes
  v <- unlist(si)
  v <- v[!is.na(v)]
  expect_true(all(v >= 1 & v <= nrow(inp)))
})

test_that("pSI.in.filter excludes the filtered genes", {
  filt <- inp
  filt[1:500, ] <- NA
  set.seed(42)
  out <- specificity.index(inp, pSI.in.filter = filt, e_min = 20)
  expect_true(all(is.na(out[1:500, ])))
  expect_equal(out, fixture("psi11_specificity_index_seed42_emin20_filter"), tolerance = 1e-8)
})

test_that("pSI values are p-values no larger than p_max, and NA below e_min", {
  set.seed(1)
  out <- specificity.index(inp, e_min = 20, p_max = 0.1)
  v <- unlist(out)
  v <- v[!is.na(v)]
  expect_true(length(v) > 0)
  expect_true(all(v > 0 & v <= 0.1))
  expect_true(all(is.na(out[inp < 20])))
})

test_that("hist_file writes a PDF and leaves the graphics device untouched", {
  f <- withr::local_tempfile(fileext = ".pdf")
  dev_before <- grDevices::dev.cur()
  set.seed(42)
  out <- specificity.index(inp, e_min = 20, hist_file = f)
  expect_true(file.exists(f))
  expect_gt(file.size(f), 1000)
  expect_identical(grDevices::dev.cur(), dev_before)
  # plotting must not change the numbers
  set.seed(42)
  expect_equal(out, specificity.index(inp, e_min = 20))
})

test_that("hist = TRUE draws on the current device and restores par()", {
  grDevices::pdf(NULL)
  withr::defer(grDevices::dev.off())
  mfrow_before <- graphics::par("mfrow")
  set.seed(42)
  out <- specificity.index(inp, e_min = 20, hist = TRUE)
  expect_identical(graphics::par("mfrow"), mfrow_before)
  expect_s3_class(out, "data.frame")
})

test_that("specificity.index() writes nothing to the working directory", {
  d <- withr::local_tempdir()
  withr::local_dir(d)
  set.seed(1)
  specificity.index(inp[1:2000, ], e_min = 20, bts = 5)
  expect_length(list.files(d, all.files = TRUE, no.. = TRUE), 0)
})
