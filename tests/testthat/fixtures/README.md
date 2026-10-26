# Regression fixtures

Outputs of **pSI 1.1 as published on CRAN** (installed from the archived
`pSI_1.1.tar.gz`, run under R 4.5.3 on x86_64 Linux) on the data bundled with
the package. The tests check that pSI 1.2.0 reproduces them.

| File | How it was produced (pSI 1.1) |
|---|---|
| `psi11_specificity_index_seed42_emin20.rds` | `set.seed(42); specificity.index(sample.data$pSI.input, e_min = 20)` |
| `psi11_specificity_index_seed42_emin20_SI.rds` | same with `SI = TRUE` |
| `psi11_specificity_index_seed42_emin20_filter.rds` | same with `pSI.in.filter = filt`, where `filt <- sample.data$pSI.input; filt[1:500, ] <- NA` |
| `psi11_list.rds` | `pSI.list(sample.data$pSI.output, write.csv = FALSE)` |
| `psi11_count.rds` | `pSI.count(sample.data$pSI.output)` |
| `psi11_overlap_AutDB_upper.rds` | `candidate.overlap(sample.data$pSI.output, toupper(candidate.genes$AutDB))` (upper-cased because 1.1 did not upper-case candidates itself) |
| `psi11_fisher_AutDB.rds` | `fisher.iteration(sample.data$pSI.output, candidate.genes$AutDB)` |
| `psi11_fisher_AutDB_nominal.rds` | same with `p.adjust = FALSE` |
| `psi11_fisher_hcrt.rds` | `fisher.iteration(sample.data$pSI.output, candidate.genes$hcrt.genes)` |

`specificity.index()` resamples with `sample()`, so these fixtures depend on
R's default RNG (`Mersenne-Twister`, `Rejection` sampling, R >= 3.6.0) and the
seed shown.
