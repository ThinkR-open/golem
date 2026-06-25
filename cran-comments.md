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
(63 packages).

* We saw 0 new problems caused by golem.
* One package, `spatialLIBD`, is reported as broken. Its failures are not
  caused by golem: they come from external data downloads being unavailable in
  the check environment, not from any golem API. Specifically:
  - `checking examples` fails in the `add_images` example, where
    `fetch_data("spe")` reads a corrupt/incomplete BiocFileCache download and
    errors with `error reading from connection` in `load()`.
  - `checking running R code from vignettes` fails in
    `TenX_data_download.Rmd`, where an FTP download from
    `ftp://ftp.ebi.ac.uk/...gencode.v32.annotation.gtf.gz` could not be reached
    (`bfcadd() failed; download failed`).
  Neither failing code path calls golem. `spatialLIBD` imports only
  `with_golem_options`, `get_golem_options`, `activate_js` and `favicon`, none
  of which changed in a way that affects it. Against the current CRAN version of
  golem (0.5.1) this package previously timed out, so the dev version is not a
  regression.
