# cbind_pad() replaces gdata::cbindX(); its output was verified identical to
# cbindX() on these cases when it was written.

test_that("cbind_pad() pads shorter data frames with NA", {
  a <- data.frame(a = c("x", "y", "z"), stringsAsFactors = FALSE)
  b <- data.frame(b = "q", stringsAsFactors = FALSE)
  out <- cbind_pad(a, b)
  expect_s3_class(out, "data.frame")
  expect_identical(dim(out), c(3L, 2L))
  expect_identical(names(out), c("a", "b"))
  expect_identical(out$a, a$a)
  expect_identical(out$b, c("q", NA, NA))
})

test_that("cbind_pad() handles zero-row inputs and equal-length inputs", {
  a <- data.frame(a = c("x", "y"), stringsAsFactors = FALSE)
  z <- data.frame(z = character(0), stringsAsFactors = FALSE)
  out <- cbind_pad(z, a)
  expect_identical(dim(out), c(2L, 2L))
  expect_true(all(is.na(out$z)))
  expect_identical(out$a, a$a)
  out2 <- cbind_pad(a, z)
  expect_identical(out2$a, a$a)
  expect_true(all(is.na(out2$z)))
  expect_identical(cbind_pad(a, a), cbind(a, a))
})

test_that("cbind_pad() accepts several data frames and rejects non-data-frames", {
  out <- cbind_pad(data.frame(a = 1:3), data.frame(b = 2.5), data.frame(c = c("u", "v"), stringsAsFactors = FALSE))
  expect_identical(dim(out), c(3L, 3L))
  expect_identical(out$b, c(2.5, NA, NA))
  expect_identical(out$c, c("u", "v", NA))
  expect_error(cbind_pad(data.frame(a = 1:3), 1:3))
})
