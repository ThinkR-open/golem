# Release summary

This is a major release (0.5.1 -> 1.0.0). It contains a number of breaking
changes, which are listed first in `NEWS.md`. The most user-visible ones are:

* `get_sysreqs()`, `use_recommended_deps()` and `add_rstudioconnect_file()`
  have been removed (`add_rstudioconnect_file()` is replaced by
  `add_positconnect_file()`).
* The path-style arguments of all functions (`wd`, `path`, `pkg`) have been
  standardized to a single `golem_wd` argument.
* `get_current_config()` no longer guesses non-standard config paths.

# R CMD check results

0 errors | 0 warnings | 0 notes

# Reverse dependencies

We ran R CMD check on the reverse dependencies of golem with revdepcheck
(62 packages: 54 from CRAN + 8 from Bioconductor).

* We saw 0 new problems.
* Five packages failed to check: `AbSolution`, `iModMix`, `spatialLIBD`,
  `SVMDO` and `wpm`. None of these failures is caused by golem: each one fails
  *before installation* because its own Bioconductor dependencies (e.g.
  `Biostrings`, `HDF5Array`, `Rhdf5lib`, `org.Hs.eg.db`, `SpatialExperiment`)
  could not be downloaded/installed in the check environment. The failures
  reproduce identically against the current CRAN version of golem (0.5.1) and
  the dev version, confirming they are pre-existing and unrelated to this
  release.
