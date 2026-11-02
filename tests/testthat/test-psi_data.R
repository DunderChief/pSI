# The real files are 4-6 MB each, so the download/cache/checksum logic is tested
# offline with a tiny stand-in file and mocked download.file(); one test at the
# end fetches the real files when there is a network and we are not on CRAN.

fake_rda <- function(object) {
  path <- tempfile(fileext = ".rda")
  env <- new.env()
  assign(object, list(psi.in = data.frame(a = 1:3), psi.out = data.frame(a = c(0.01, NA, 0.5))), envir = env)
  save(list = object, file = path, envir = env)
  path
}

fake_info <- function(path) {
  data.frame(object = c("mouse", "human"), url = c("https://example.invalid/mouse.rda", "https://example.invalid/human.rda"),
             md5 = rep(unname(as.character(tools::md5sum(path))), 2), size = c("1 KB", "1 KB"),
             row.names = c("mouse", "human"), stringsAsFactors = FALSE)
}

# Give every test a private persistent-cache root and a clean session temp dir.
isolate_dirs <- function(env = parent.frame()) {
  root <- withr::local_tempdir(.local_envir = env)
  withr::local_envvar(R_USER_CACHE_DIR = root, .local_envir = env)
  session_dir <- file.path(tempdir(), "pSI")
  unlink(session_dir, recursive = TRUE)
  withr::defer(unlink(session_dir, recursive = TRUE), envir = env)
  list(cache = tools::R_user_dir("pSI", "cache"), session = session_dir)
}

test_that("psi_data_info() lists both files on the GitHub release with MD5 checksums", {
  info <- psi_data_info()
  expect_identical(rownames(info), c("mouse", "human"))
  expect_true(all(grepl("^https://github\\.com/DunderChief/pSI/releases/download/", info$url)))
  expect_true(all(grepl("^[0-9a-f]{32}$", info$md5)))
})

test_that("psi_data() downloads, verifies, loads, and reuses the file within the session", {
  dirs <- isolate_dirs()
  fake <- fake_rda("mouse")
  downloads <- 0L
  local_mocked_bindings(
    psi_data_info = function() fake_info(fake),
    download.file = function(url, destfile, ...) { downloads <<- downloads + 1L; file.copy(fake, destfile, overwrite = TRUE); 0L }
  )
  expect_message(m <- psi_data("mouse", cache = FALSE), "Downloading mouse.rda")
  expect_named(m, c("psi.in", "psi.out"))
  expect_identical(downloads, 1L)
  expect_true(file.exists(file.path(dirs$session, "mouse.rda")))
  expect_false(dir.exists(dirs$cache))
  # second call: no download, same object, and quiet
  expect_silent(m2 <- psi_data("mouse", cache = FALSE, quiet = TRUE))
  expect_identical(m2, m)
  expect_identical(downloads, 1L)
})

test_that("cache = TRUE stores the file under R_user_dir() and later calls reuse it", {
  dirs <- isolate_dirs()
  fake <- fake_rda("human")
  downloads <- 0L
  local_mocked_bindings(
    psi_data_info = function() fake_info(fake),
    download.file = function(url, destfile, ...) { downloads <<- downloads + 1L; file.copy(fake, destfile, overwrite = TRUE); 0L }
  )
  h <- psi_data("human", cache = TRUE, quiet = TRUE)
  expect_named(h, c("psi.in", "psi.out"))
  expect_true(file.exists(file.path(dirs$cache, "human.rda")))
  expect_false(file.exists(file.path(dirs$session, "human.rda")))
  # a cached copy is used even when the caller asks for no caching
  h2 <- psi_data("human", cache = FALSE, quiet = TRUE)
  expect_identical(h2, h)
  expect_identical(downloads, 1L)
})

test_that("cache = NULL never writes outside tempdir() when not interactive, and honours the option", {
  dirs <- isolate_dirs()
  fake <- fake_rda("mouse")
  local_mocked_bindings(
    psi_data_info = function() fake_info(fake),
    download.file = function(url, destfile, ...) { file.copy(fake, destfile, overwrite = TRUE); 0L }
  )
  expect_false(interactive())
  psi_data("mouse", quiet = TRUE)
  expect_true(file.exists(file.path(dirs$session, "mouse.rda")))
  expect_false(dir.exists(dirs$cache))
  unlink(dirs$session, recursive = TRUE)
  withr::local_options(pSI.data.cache = TRUE)
  psi_data("mouse", quiet = TRUE)
  expect_true(file.exists(file.path(dirs$cache, "mouse.rda")))
})

test_that("a corrupt download is rejected and removed, with a message rather than an error", {
  dirs <- isolate_dirs()
  fake <- fake_rda("mouse")
  local_mocked_bindings(
    psi_data_info = function() fake_info(fake),
    download.file = function(url, destfile, ...) { writeLines("not an rda file", destfile); 0L }
  )
  expect_message(res <- psi_data("mouse", cache = FALSE, quiet = TRUE), "Could not download mouse.rda")
  expect_null(res)
  expect_false(file.exists(file.path(dirs$session, "mouse.rda")))
})

test_that("a failed download gives a message rather than an error", {
  dirs <- isolate_dirs()
  fake <- fake_rda("mouse")
  local_mocked_bindings(
    psi_data_info = function() fake_info(fake),
    download.file = function(url, destfile, ...) stop("simulated network failure")
  )
  expect_message(res <- psi_data("mouse", cache = FALSE, quiet = TRUE), "Could not download mouse.rda")
  expect_null(res)
  expect_false(file.exists(file.path(dirs$session, "mouse.rda")))
})

test_that("an unknown dataset name is an error", {
  expect_error(psi_data("rat"))
})

test_that("the real files download from the GitHub release and have the documented structure", {
  skip_on_cran()
  skip_if_offline("github.com")
  dirs <- isolate_dirs()
  mouse <- suppressMessages(psi_data("mouse", cache = FALSE, quiet = TRUE))
  if (is.null(mouse)) skip("pSI.data release assets could not be downloaded (release not published yet, or no network)")
  expect_named(mouse, c("psi.in", "psi.in.filter", "psi.out"))
  expect_identical(dim(mouse$psi.out), c(16907L, 35L))
  human <- psi_data("human", cache = FALSE, quiet = TRUE)
  expect_named(human, c("developmental.periods", "young.adulthood"))
  expect_identical(dim(human$young.adulthood$psi.out), c(16866L, 6L))
  expect_identical(dim(human$developmental.periods$psi.out), c(16866L, 60L))
  # the bundled sample.data is the young-adulthood slice
  expect_identical(colnames(human$young.adulthood$psi.out), colnames(sample.data$pSI.output))
})
