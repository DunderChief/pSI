# Internal helper: column-bind data frames that have different numbers of rows,
# padding the shorter ones with NA so that all columns have equal length.
#
# pSI <= 1.1 used gdata::cbindX() for this. It was the only gdata function the
# package called, so pSI 1.2.0 replaces it with this helper and drops the gdata
# dependency. The output is identical to cbindX() for data frame inputs, which
# is all pSI ever passes.
cbind_pad <- function(...) {
  x <- list(...)
  stopifnot(all(vapply(x, is.data.frame, logical(1))))
  n_max <- max(vapply(x, nrow, integer(1)))
  x <- lapply(x, function(d) {
    n_pad <- n_max - nrow(d)
    if (n_pad > 0L) {
      pad <- as.data.frame(matrix(NA, nrow = n_pad, ncol = ncol(d)))
      names(pad) <- names(d)
      d <- rbind(d, pad)
    }
    d
  })
  do.call(cbind, x)
}
