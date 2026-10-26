outp <- sample.data$pSI.output
autdb <- candidate.genes$AutDB

test_that("candidate.overlap() reproduces pSI 1.1 (which required upper-case candidates)", {
  ov <- candidate.overlap(outp, autdb)
  expect_identical(ov, fixture("psi11_overlap_AutDB_upper"))
})

test_that("candidate matching is case-insensitive (new in 1.2.0)", {
  ov <- candidate.overlap(outp, autdb)
  expect_identical(candidate.overlap(outp, tolower(autdb)), ov)
  expect_identical(candidate.overlap(outp, toupper(autdb)), ov)
})

test_that("overlap columns are the candidate genes that are specific at that threshold", {
  ov <- candidate.overlap(outp, autdb)
  lst <- pSI.list(outp)
  cand <- toupper(autdb)
  expect_named(ov, names(lst))
  for (nm in names(ov)) {
    expect_identical(names(ov[[nm]]), names(lst[[nm]]))
    for (j in seq_along(ov[[nm]])) {
      got <- ov[[nm]][, j]
      got <- as.character(got[!is.na(got)])  # an empty column is logical NA
      specific <- lst[[nm]][, j]
      expect_identical(got, cand[cand %in% specific])
    }
  }
})

test_that("candidate.overlap() writes nothing unless asked", {
  d <- withr::local_tempdir()
  withr::local_dir(d)
  candidate.overlap(outp, autdb)
  expect_length(list.files(d), 0)
  candidate.overlap(outp, autdb, write.csv = TRUE)
  expect_setequal(list.files(d), c("pSi_0.0001.csv", "pSi_0.001.csv", "pSi_0.01.csv", "pSi_0.05.csv"))
})
