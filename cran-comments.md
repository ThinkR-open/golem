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

We ran R CMD check on the reverse dependencies of golem with revdepcheck.

The only package that fails to check is `spatialLIBD`. This failure is
pre-existing and unrelated to this release of golem: it is caused by that
package's own (Bioconductor) dependencies failing to install in the check
environment, not by any change introduced here.
