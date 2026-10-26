# Load a regression fixture produced by pSI 1.1 (see fixtures/README.md).
fixture <- function(name) {
  readRDS(test_path("fixtures", paste0(name, ".rds")))
}
